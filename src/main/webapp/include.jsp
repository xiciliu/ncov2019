<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="com.yaowei.ncov.module.StaticModule" %>
<%@ page import="com.yaowei.ncov.MainSetup" %>
<%@ page import="org.nutz.dao.Dao" %>
<%@ page import="org.nutz.dao.Cnd" %>
<%@ page import="org.nutz.dao.pager.*" %>
<%@ page import="com.yaowei.ncov.service.ProvinceService" %>
<%@ page import="com.yaowei.ncov.bean.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="xici.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.*" %>
<%@ page import="org.nutz.mvc.Mvcs" %>


<%
SimpleDateFormat ds = new SimpleDateFormat("yyyy-MM-dd");
SimpleDateFormat dl = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
SimpleDateFormat dlhm = new SimpleDateFormat("yyyy-MM-dd HH:mm");
			
String path = request.getContextPath();
String serverPath=request.getScheme()+"://"+request.getServerName()+(request.getServerPort()==80?"":(":"+request.getServerPort()));
String basePath = serverPath+path+"/";

//更改为使用MainSetup下的dao
//StaticModule sm=new StaticModule();
//Dao dao=sm.getDao();
Dao dao=MainSetup.ioc.get(Dao.class);


//handle parameters
StringBuffer parasStr=new StringBuffer();
Enumeration enu=request.getParameterNames();
while(enu.hasMoreElements()){
	String paraName=(String)enu.nextElement();
	if(!paraName.equals("pn")){
		parasStr.append("&"+paraName+"="+request.getParameter(paraName));
	}
}
%>

