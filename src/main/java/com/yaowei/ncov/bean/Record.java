package com.yaowei.ncov.bean;

import java.util.Date;

import org.nutz.dao.entity.annotation.Id;
import org.nutz.dao.entity.annotation.Name;
import org.nutz.dao.entity.annotation.Table;

@Table("record")
public class Record {
	@Id
	private int id;
	private String province;
	
	private int confirm;
	private int suspect;
	private int dead;
	private int cure;
	
	private Date timeset=new Date();
	
	private String title;
	private String detail;
	private String source;
	private String url;

	
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
	public int getConfirm() {
		return confirm;
	}
	public void setConfirm(int confirm) {
		this.confirm = confirm;
	}
	public int getSuspect() {
		return suspect;
	}
	public void setSuspect(int suspect) {
		this.suspect = suspect;
	}
	public int getDead() {
		return dead;
	}
	public void setDead(int dead) {
		this.dead = dead;
	}
	public int getCure() {
		return cure;
	}
	public void setCure(int cure) {
		this.cure = cure;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getDetail() {
		return detail;
	}
	public void setDetail(String detail) {
		this.detail = detail;
	}
	public String getSource() {
		return source;
	}
	public void setSource(String source) {
		this.source = source;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	
	
	
	
}
