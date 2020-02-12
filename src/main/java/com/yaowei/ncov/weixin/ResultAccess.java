package com.yaowei.ncov.weixin;

public class ResultAccess {
	private String access_token = "";
	private String refresh_token = "";
	private String openid = "";
	private String snsapi_base = "";
	private int expires_in;

	public String getAccess_token() {
		return access_token;
	}

	public void setAccess_token(String access_token) {
		this.access_token = access_token;
	}

	public String getRefresh_token() {
		return refresh_token;
	}

	public void setRefresh_token(String refresh_token) {
		this.refresh_token = refresh_token;
	}

	public String getOpenid() {
		return openid;
	}

	public void setOpenid(String openid) {
		this.openid = openid;
	}

	public String getSnsapi_base() {
		return snsapi_base;
	}

	public void setSnsapi_base(String snsapi_base) {
		this.snsapi_base = snsapi_base;
	}

	public int getExpires_in() {
		return expires_in;
	}

	public void setExpires_in(int expires_in) {
		this.expires_in = expires_in;
	}

}
