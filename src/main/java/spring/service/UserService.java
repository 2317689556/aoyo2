package spring.service;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.stereotype.Service;
import spring.dao.UserMapper;
import spring.pojo.AoyoMenu;
import spring.pojo.Fangwu;
import spring.pojo.SysUser;

import javax.annotation.Resource;
import java.util.List;

@Service
public class UserService {
    @Resource
    UserMapper userMapper;

    public PageInfo<Fangwu> NovelShow(Integer limit, Integer offset,String sname) {
        PageHelper.offsetPage(offset, limit);
        List<Fangwu> list = userMapper.NovelShow(limit, offset,sname);
        PageInfo<Fangwu> info = new PageInfo<Fangwu>(list);
        return info;
    }


    public List<AoyoMenu> queryMenuList() {
        return userMapper.listMenu();
    }

    public SysUser login(SysUser sysUser) {
        return userMapper.login(sysUser);
    }
}
