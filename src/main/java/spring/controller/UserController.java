package spring.controller;

import com.github.pagehelper.PageInfo;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import spring.pojo.AoyoMenu;
import spring.pojo.Fangwu;
import spring.pojo.SysUser;
import spring.service.UserService;
import spring.util.VerifyCodeUtils;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/user")
public class UserController {
    @Resource
    UserService userService;

    @RequestMapping("/show")
    @ResponseBody
    public PageInfo<Fangwu> show(Integer limit, Integer offset, String sname) {
        PageInfo<Fangwu> list = userService.NovelShow(limit, offset,sname);
        return list;
    }

    //登录__生成图片验证码
    @RequestMapping("/autoImage")
    public void autoImage(HttpServletResponse response, HttpSession session) throws IOException {
        response.setHeader("Pragma", "No-cache");
        response.setHeader("Cache-Control", "no-cache");
        response.setDateHeader("Expires", 0);
        response.setContentType("image/jpeg");
        //生成随机字符串
        String verifyCode = VerifyCodeUtils.generateVerifyCode(4);
        //存入会话session
        //删除以前的
        session.removeAttribute("verCode");
        session.setAttribute("verCode", verifyCode.toLowerCase());
        //生成图片
        int w = 100, h = 38;
        VerifyCodeUtils.outputImage(w, h, response.getOutputStream(), verifyCode);
    }

    //登录__验证图片验证码
    @ResponseBody
    @RequestMapping("/checkCodestext")
    public boolean checkCodestext(String codestext, HttpSession session) {
        String verCode = (String) session.getAttribute("verCode");

        if (verCode == null) {
            return false;
        } else if (!codestext.equalsIgnoreCase(verCode)) {
            return false;
        }
        return true;
    }

    @ResponseBody
    @RequestMapping("/login")
    public boolean login(SysUser sysUser) {
        SysUser rootMenus = userService.login(sysUser);
        if(rootMenus==null){
            return false;
        }else {
            return true;
        }
    }



    @ResponseBody
    @RequestMapping("/listMenu")
    public List<AoyoMenu> listMenu() {
        List<AoyoMenu> rootMenus = userService.queryMenuList();
        List<AoyoMenu> list = getMenuList(rootMenus);
        return list;
    }

    /**
     * 找出一级菜单和二级菜单
     * @param rootMenus
     * @return
     */
    private List<AoyoMenu> getMenuList(List<AoyoMenu> rootMenus){
        List<AoyoMenu> list = new ArrayList<AoyoMenu>();
        // 先找到所有的一级菜单
        for (int i=0;i<rootMenus.size();i++){
            AoyoMenu menu = rootMenus.get(i);
            //一级菜单  没有父节点
            if (menu.getMenuParentId()==0){
                list.add(menu);
                menu.setChildMenus(getChild(menu.getMenuId(),rootMenus));
            }
        }

        //查找二级菜单
        /**
         * 利用递归找出所有子菜单
         */

        return list;

    }


    /**
     * 找出子菜单
     * @param id
     * @return
     */

    private List<AoyoMenu> getChild(Integer id,List<AoyoMenu> rootMenus) {
        // 子菜单
        List<AoyoMenu> childList=new ArrayList<>();

        for (AoyoMenu menu : rootMenus) {
            // 遍历所有节点，将父菜单id与传过来的id比较
            if (menu.getMenuParentId().equals(id)) {
                childList.add(menu);
                List<AoyoMenu> child = getChild(menu.getMenuId(), rootMenus);
                if(!child.isEmpty() && child.size()>0){
                    menu.setChildMenus(child);
                }
            }
        }

        return childList;
    }
}
