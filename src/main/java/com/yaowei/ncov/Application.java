package com.yaowei.ncov;

import java.util.HashMap;
import java.util.Map;

public class Application {
	private static Map<String,Object> cache=new HashMap<String,Object>();
	
	public static void set(String key,Object value){
		cache.put(key, value);
	}
	
	public static Object get(String key){
		return cache.get(key);
	}
	
	public static boolean contains(String key){
		return cache.containsKey(key);
	}
	
	
	
	
}
