package spring.pojo;


import lombok.Data;

import java.util.List;

@Data
public class AoyoMenu {


  private Integer menuId;
  private Integer menuLevel;
  private Integer menuCode;
  private String menuName;
  private String menuPath;
  private String menuDesc;
  private Integer menuParentId;
  private Integer menuStatus;
  private String menuIconPath;
  private String menuTime;
  private Integer deleteFlag;
  private double menuDoubleTest;
  private List<AoyoMenu> childMenus;

}
