package com.yaowei.ncov;

import java.util.Date;

import org.nutz.dao.Dao;
import org.nutz.dao.util.Daos;
import org.nutz.ioc.Ioc;
import org.nutz.mvc.Mvcs;
import org.nutz.mvc.NutConfig;
import org.nutz.mvc.Setup;


public class MainSetup implements Setup{
	//增加一行，给jsp界面调用dao
	public static Ioc ioc;
	
	// 特别留意一下,是init方法,不是destroy方法!!!!!
    public void init(NutConfig nc) {
        ioc = nc.getIoc();
        Dao dao = ioc.get(Dao.class);
        
        //initialAccount(dao);
        initial(dao);
        
        Global.tstfolder=Mvcs.getServletContext().getRealPath("/") + "uploadtemp";
        System.out.println("set up tst folder to "+Global.tstfolder);
        
        
    }
    
    private void initialAccount(Dao dao){
    	// 如果没有createTablesInPackage,请检查nutz版本
        //Daos.createTablesInPackage(dao, "net.wendal.nutzbook", false);
    	// 初始化默认根用户
    	/*
        if (dao.count(Account.class) == 0) {
        	Account user = new Account();
            user.setUsername("admin");
            user.setPassword("123456");
            user.setModifydate(new Date());
            dao.insert(user);
        }
        */
    }
    private void initial(Dao dao){
    	//Daos.createTablesInPackage(dao, "com.nsb.wifiatc", false);
    	
    }

    public void destroy(NutConfig nc) {
    }
}
