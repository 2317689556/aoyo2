package spring.controller;

import com.github.pagehelper.PageInfo;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import spring.pojo.Fangwu;
import spring.service.UserService;

import javax.annotation.Resource;

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
}
