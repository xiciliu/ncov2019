package com.yaowei.ncov.service;

import java.util.List;

import org.nutz.dao.Cnd;
import org.nutz.ioc.loader.annotation.IocBean;
import org.nutz.service.IdEntityService;

import com.yaowei.ncov.bean.Province;

@IocBean(fields="dao")
public class ProvinceService extends IdEntityService<Province> {
	
	public Province fetch(int id){
		Province p=this.dao().fetch(Province.class, id);
		//p=this.dao().fetchLinks(p, "boms",Cnd.orderBy().desc("modifydate"));
		//p=this.dao().fetchLinks(p, "orders",Cnd.orderBy().desc("modifydate"));
		return p;
	}
	
	public List<Province> getAll(){
		return this.dao().query(Province.class, null);
	}
	
	
	

}
