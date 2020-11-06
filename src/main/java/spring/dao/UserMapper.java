package spring.dao;

import org.apache.ibatis.annotations.Param;
import spring.pojo.AoyoMenu;
import spring.pojo.Fangwu;
import spring.pojo.SysUser;

import java.util.List;

public interface UserMapper {

    List<Fangwu> NovelShow(@Param("limit") Integer limit, @Param("offset") Integer offset,@Param("sname") String sname);

    List<AoyoMenu> listMenu();

    SysUser login(SysUser sysUser);
}
