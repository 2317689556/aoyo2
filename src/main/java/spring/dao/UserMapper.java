package spring.dao;

import org.apache.ibatis.annotations.Param;
import spring.pojo.Fangwu;

import java.util.List;

public interface UserMapper {

    List<Fangwu> NovelShow(@Param("limit") Integer limit, @Param("offset") Integer offset,@Param("sname") String sname);

}
