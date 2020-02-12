package com.yaowei.ncov.bean;

import java.util.Date;

import org.nutz.dao.entity.annotation.Id;
import org.nutz.dao.entity.annotation.Name;
import org.nutz.dao.entity.annotation.Table;

@Table("province")
public class Province {
	@Id
	private int id;
	@Name
	private String province;
	private String provincetext;
	private String provincekey;
	
	
	private int totalconfirm;
	private int totalsuspect;
	private int totaldead;
	private int totalcure;
	
	private Date timeset=new Date();
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public Date getTimeset() {
		return timeset;
	}
	public void setTimeset(Date timeset) {
		this.timeset = timeset;
	}
	public String getProvince() {
		return province;
	}
	public void setProvince(String province) {
		this.province = province;
	}
	public String getProvincetext() {
		return provincetext;
	}
	public void setProvincetext(String provincetext) {
		this.provincetext = provincetext;
	}
	public int getTotalconfirm() {
		return totalconfirm;
	}
	public void setTotalconfirm(int totalconfirm) {
		this.totalconfirm = totalconfirm;
	}
	public int getTotalsuspect() {
		return totalsuspect;
	}
	public void setTotalsuspect(int totalsuspect) {
		this.totalsuspect = totalsuspect;
	}
	public int getTotaldead() {
		return totaldead;
	}
	public void setTotaldead(int totaldead) {
		this.totaldead = totaldead;
	}
	public int getTotalcure() {
		return totalcure;
	}
	public void setTotalcure(int totalcure) {
		this.totalcure = totalcure;
	}
	public String getProvincekey() {
		return provincekey;
	}
	public void setProvincekey(String provincekey) {
		this.provincekey = provincekey;
	}
	
	
	
	
}
