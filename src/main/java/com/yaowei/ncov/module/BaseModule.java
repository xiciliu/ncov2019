package com.yaowei.ncov.module;

import java.text.SimpleDateFormat;
import java.util.List;

import org.nutz.dao.Condition;
import org.nutz.dao.Dao;
import org.nutz.dao.QueryResult;
import org.nutz.dao.pager.Pager;
import org.nutz.ioc.loader.annotation.Inject;
import org.nutz.lang.util.NutMap;

public abstract class BaseModule {

    /** 注入同名的一个ioc对象 */
    @Inject protected Dao dao;

    //@Inject protected EmailService emailService;
    
    public static SimpleDateFormat ds = new SimpleDateFormat("yyyy-MM-dd");
	public static SimpleDateFormat dl = new SimpleDateFormat(
			"yyyy-MM-dd HH:mm:ss");

    protected QueryResult query(Class<?> klass, Condition cnd, Pager pager, String regex) {
        if (pager != null && pager.getPageNumber() < 1) {
            pager.setPageNumber(1);
        }
        List<?> roles = dao.query(klass, cnd, pager);
        dao.fetchLinks(roles, null);
        pager.setRecordCount(dao.count(klass, cnd));
        return new QueryResult(roles, pager);
    }

    protected NutMap ajaxOk(Object data) {
        return new NutMap().setv("ok", true).setv("data", data);
    }

    protected NutMap ajaxFail(String msg) {
        return new NutMap().setv("ok", false).setv("msg", msg);
    }
}
