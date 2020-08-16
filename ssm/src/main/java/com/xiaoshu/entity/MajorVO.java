package com.xiaoshu.entity;

public class MajorVO {

	private String maname;
	private Integer ct;
	
	public String getManame() {
		return maname;
	}
	public void setManame(String maname) {
		this.maname = maname;
	}
	public Integer getCt() {
		return ct;
	}
	public void setCt(Integer ct) {
		this.ct = ct;
	}
	@Override
	public String toString() {
		return "MajorVO [maname=" + maname + ", ct=" + ct + "]";
	}
	
	
	
}
