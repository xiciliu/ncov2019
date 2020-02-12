package util.cls;

import com.alibaba.fastjson.JSONObject;
/*
import com.nsb.wifiatc.bean.Sequence;
import com.nsb.wifiatc.bean.SequenceStatus;
*/
public class ClassUtil {
	/**
	 * conver parent class object to child class object
	 * @param b, source object
	 * @param clazz, targt clazz
	 * @return
	 */
	public static <T>T convertClass(Object b,Class<?> clazz){
		String ob = JSONObject.toJSONString(b);
	    @SuppressWarnings("unchecked")
		T a = (T) JSONObject.parseObject(ob, clazz);
	    return a;
	}
	
	public static void main(String[] args){
		/*
		Sequence s=new Sequence();
		s.setAOI(true);
		
		SequenceStatus ss=convertClass(s,SequenceStatus.class);
		System.out.println(ss.getAOIStatus());
		System.out.println(ss.isFH());
		System.out.println(ss.isAOI());
		*/
	}
}
