package com.yaowei.ncov.bean;

import java.util.Date;

import org.nutz.json.Json;
import org.nutz.json.JsonFormat;

public abstract class BasePojo {

	/*
    @Column("ct")
    protected Date createTime;
    */
    
    protected Date modifydate;
    
    
    
    public Date getModifydate() {
		return modifydate;
	}



	public void setModifydate(Date modifydate) {
		this.modifydate = modifydate;
	}



	public String toString() {
        // 这不是必须的, 只是为了debug的时候方便看
        return Json.toJson(this, JsonFormat.compact());
    }

    
}