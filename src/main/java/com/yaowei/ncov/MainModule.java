package com.yaowei.ncov;

import org.nutz.ioc.Ioc;
import org.nutz.mvc.NutConfig;
import org.nutz.mvc.annotation.IocBy;
import org.nutz.mvc.annotation.Localization;
import org.nutz.mvc.annotation.Modules;
import org.nutz.mvc.annotation.SetupBy;
import org.nutz.mvc.ioc.provider.ComboIocProvider;

@Localization(value="msg/", defaultLocalizationKey="zh-CN") //配置Localization，按需求来
@SetupBy(value=MainSetup.class)
@IocBy(type=ComboIocProvider.class, args={"*js", "ioc/",
        "*anno", "com.yaowei.ncov"
        ,"webservice.module", //扫描第二个包
        "*tx", // 事务拦截 aop
        "*async"}) // 异步执行aop
@Modules(scanPackage=true,packages="webservice.module") //扫描多个包，加上packages注解属性，低版本可能为pkgs
public class MainModule {
	
}
