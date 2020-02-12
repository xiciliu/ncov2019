package com.yaowei.ncov.module;

import java.util.Date;
import java.util.List;

import org.nutz.castor.Castors;
import org.nutz.castor.FailToCastObjectException;
import org.nutz.castor.castor.String2Number;
import org.nutz.dao.Cnd;
import org.nutz.dao.QueryResult;
import org.nutz.dao.pager.Pager;
import org.nutz.ioc.loader.annotation.Inject;
import org.nutz.ioc.loader.annotation.IocBean;
import org.nutz.lang.Strings;
import org.nutz.lang.util.NutMap;
import org.nutz.mvc.annotation.At;
import org.nutz.mvc.annotation.Attr;
import org.nutz.mvc.annotation.Fail;
import org.nutz.mvc.annotation.Ok;
import org.nutz.mvc.annotation.Param;

import com.alibaba.fastjson.JSON;
import com.yaowei.ncov.bean.Province;
import com.yaowei.ncov.bean.Record;
import com.yaowei.ncov.service.ProvinceService;


@IocBean // 还记得@IocBy吗? 这个跟@IocBy有很大的关系哦
@At("/province")
//@Ok("json")
@Ok("json:full")
@Fail("http:500")
//@Filters(@By(type=CheckSession.class, args={"me", "/"})) //如果当前Session没有带me这个attr,就跳转到/页面,即首页.
public class ProvinceModule extends BaseModule{
	
	@At
    public Object query() {
		Cnd cnd =Cnd.NEW();
        List<Province>data=dao.query(Province.class, cnd);
        Province last=dao.fetch(Province.class, Cnd.NEW().orderBy("timeset", "desc"));
        return new NutMap().setv("ok", data!=null).setv("msg", "success").setv("data", data).setv("last", last);
    }
	
	@At("/record")
    public Object queryrecord() {
		Cnd cnd =Cnd.NEW();
        List<Record>data=dao.query(Record.class, cnd.orderBy("timeset", "desc"));
        return new NutMap().setv("ok", data!=null).setv("msg", "success").setv("data", data);
    }
	
	@At("/find")
	public Object read(@Param("id")String id, @Param("..")Pager pager){
		Cnd cnd =Cnd.NEW();
        cnd=Strings.isBlank(id)? cnd : Cnd.where("id", "=", id);
        QueryResult qr = new QueryResult();
        qr.setList(dao.query(Province.class, cnd, pager));
        pager.setRecordCount(dao.count(Province.class, cnd));
        qr.setPager(pager);
        return qr; //默认分页是第1页,每页20条
	}
	
	/**
	 * 用于快捷获取上一次的参数配置，达到快速执行
	 * @param name
	 * @return
	 */
	@At
    public Object autocompletename(@Param("name")String name) {
		Cnd cnd =Cnd.NEW();
        cnd=Strings.isBlank(name)? cnd : Cnd.where("name", "like", "%"+name+"%");
        List<Province>list= dao.query(Province.class, cnd);
        StringBuffer sb=new StringBuffer();
		if(list!=null){
			for(Province s:list){
				sb.append(JSON.toJSONString(s)).append("\n");
			}
		}
        return sb.toString();
    }
	
	/**
	 * 
	 * @return
	 */
//	@At("/create")
//    public Object create(@Param("productname")String name,@Param("productcode")String code,@Param("description")String description,@Param("enable")boolean enable) {
//		Province data=new Province();
////		data.setName(name);
////		data.setCode(code);
////		data.setDescription(description);
////		data.setEnable(enable);
////		data.setTimeset(new Date());
////		data.setTimemodify(new Date());
//		provinceService._insert(data);
//		boolean s=data.getId()>0;
//		return new NutMap().setv("ok", s).setv("msg", s?data.getId():"create "+data.getClass().getName()+" fail");
//    }
	
	@At("/modify")
    public Object modify(@Param("id")int id,@Param("count")int count,@Param("type")String type
    		) {
		Province data;
		data=provinceService.fetch(id);
		switch(type) {
			case "confirm":
				data.setTotalconfirm(count);
				break;
			case "suspect":
				data.setTotalsuspect(count);
				break;
			case "dead":
				data.setTotaldead(count);
				break;
			case "cure":
				data.setTotalcure(count);
				break;
			case "clear":
				data.setTotalconfirm(0);
				data.setTotalsuspect(0);
				data.setTotaldead(0);
				data.setTotalcure(0);
				break;
		}
		data.setTimeset(new Date());
		
		
		provinceService._update(data);
		boolean s=data.getId()>0;
		System.out.println("modify province "+id+": "+s);
		return new NutMap().setv("ok", s).setv("msg", s?"":"modify fail").setv("data", data);
    }
	
	

	@Inject
	private ProvinceService provinceService;
	
	
}
