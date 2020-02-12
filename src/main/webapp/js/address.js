//地址校验
//地址分割 省市区镇小区单元楼门牌号 (含自治区，直辖市，县，自治县)
$('#address').textbox({
	onChange:function(newValue,oldValue){
		var address = newValue;
		var area = {}
	    var index11 = 0
	    var index1 = address.indexOf("省")
	    //alert(index1)
	    if (index1 == -1) {
	      index11 = address.indexOf("自治区")
	      if (index11 != -1) {
	        area.Province = address.substring(0, index11 + 3)//有值得时候取到自治区
	      } else {
	        area.Province = address.substring(0, 0)//没值
	      }
	    } else {
	      area.Province = address.substring(0, index1 + 1)//取到省
	    }
	 
	    var index2 = address.indexOf("市")
	    if (index11 == -1) {
	      area.City = address.substring(index11 + 1, index2 + 1);//没有市就取到省
	    } else {
	      if (index11 == 0) {
	        area.City = address.substring(index1 + 1, index2 + 1);//有值从省取到市
	      } else {
	        area.City = address.substring(index11 + 3, index2 + 1);//从自治区取到市
	      }
	    }
	 	//var index5 = 0
	    var index3 = address.indexOf("区")
	    if (index3 == -1) {
	      index3 = address.indexOf("县");
	      area.Country = address.substring(index2 + 1, index3 + 1)
	    } else {
	      area.Country = address.substring(index2 + 1, index3 + 1)
	    }
	   
	    var index4 = address.indexOf("镇")
	    if (index4 == -1) {
	      area.Town = address.substring(index3 + 1, index4 + 1);//从区到镇
	    } else {
	      if (index4 == 0) {
	        area.Town = address.substring(index3 + 1, index4 + 1);//区到镇
	      } else {
	        area.Town = address.substring(index3 + 1 , index4 + 1);//
	      }
	    }
	    
	    var index5 = address.indexOf("号")
	    if (index5 == -1) {
	      area.Mark = address.substring(index4 + 1, index5 + 1);
	    } else {
	      if (index5 == 0) {
	        area.Mark = address.substring(index4 + 1, index5 + 1);
	      } else {
	        area.Mark = address.substring(index4 + 1 , index5 + 1);
	      }
	    }
	    
	    var index6 = address.indexOf("号楼")
	    if (index6 == -1) {
	      area.building = address.substring(index5 + 1, index6 + 2);
	    } else {
	      if (index6 == 0) {
	        area.building = address.substring(index5 + 1, index6 + 2);
	      } else {
	        area.building = address.substring(index5 + 1 , index6 + 2);
	      }
	    }
	    
	    var index7 = address.indexOf("单元")
	    if (index7 == -1) {
	      area.unit = address.substring(index6 + 2, index7 + 2);
	    } else {
	      if (index7 == 0) {
	        area.unit = address.substring(index6 + 2, index7 + 2);
	      } else {
	        area.unit = address.substring(index6 + 2 , index7 + 2);
	      }
	    }
	    
	    var index8 = address.indexOf("层")
	    if (index8 == -1) {
	      area.floor = address.substring(index7 + 2, index8 + 1);
	    } else {
	      if (index8 == 0) {
	        area.floor = address.substring(index7 + 2, index8 + 1);
	      } else {
	        area.floor = address.substring(index7 + 2 , index8 + 1);
	      }
	    }
	    
	    var index9 = address.lastIndexOf("号")
	    if (index9 == -1) {
	      area.number = address.substring(index8 + 1, index9 + 1);
	    } else {
	      if (index9 == 0) {
	        area.number = address.substring(index8 + 1, index9 + 1);
	      } else {
	        area.number = address.substring(index8 + 1 , index9 + 1);
	      }
	    }
	    
	    
		 //alert(area.number)
		
		
	    return area;
}
})