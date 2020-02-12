package com.yaowei.ncov.module;

import org.nutz.dao.Dao;
import org.nutz.ioc.Ioc;
import org.nutz.ioc.impl.NutIoc;
import org.nutz.ioc.loader.combo.ComboIocLoader;



/**
 * 这个类做出来是给jsp获取ioc,dao用的。
 * 但是发现这个做法可能导致异常 com.alibaba.druid.pool.DataSourceClosedException: dataSource already closed
 * 使用另外的方法更佳节。
 * https://nutz.cn/yvr/t/10hds3086qgj3odo9769b84ulc
 * http://nutzam.com/core/ioc/ioc_by_hand.html
 * @author xici
 *
 */
public class StaticModule {
	
	private Dao dao=null;
	public StaticModule(){
		try {
			Ioc ioc=new NutIoc(new ComboIocLoader("*js", "ioc/", "*anno", "com.yaowei.ncov"));
			dao = ioc.get(Dao.class);
			/*
			if(dao==null){
				System.out.println("dao is null in j");
			}else{
				System.out.println("dao is not null in j");
			}
			*/
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	public Dao getDao(){
		return dao;
	}
	
}
