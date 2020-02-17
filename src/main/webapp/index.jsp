<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="include.jsp" %>
<%
	List<Province> list=dao.query(Province.class,null);
if(dao==null){
	out.println("null dao");
}

//out.println("list:"+list.size());
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=EDGE">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=2.0, minimum-scale=1.0, user-scalable=yes">
  <title>2019-nCov全国形势图</title>
  <style>
    body {
        background:#fafafa;
    }
    .box {
        position:relative;
        /*width:800px;*/
		width:100%;
        margin:0 auto;
        padding-top:1px;
    }
    #china-map {
        /*width:760px;*/
		width:100%;
        height:660px;
        margin:auto;
		padding-top:1px;
    }
    #back {
        position:absolute;
        top:2px;
        left:0;
        cursor:pointer;
    }
    .hidden {
        display:none;
    }
	div.source{
		text-align:right;
		padding-right:10px;
		color:#999;
	}
	li{
		
	}
	table th{
		background-color:#CCC;
	}
	table td{
		background-color:white;
	}
  </style>
  <script src="js/jquery.min.js"></script>
  <script type="text/javascript" src="js/echarts.min.js"></script>
  <script type="text/javascript" src="js/map/china.js"></script>
  
  
  <script type="text/javascript" src="js/vue.min.js"></script>
  <link href="css/timeline.css" rel="stylesheet" type="text/css" />
  <script type="text/javascript" src="js/modernizr.js"></script>
  
  <script>
  	/*endlesspage.js*/
	
	$(function () {
		var gPageSize = 5;
		var i = 1; //设置当前页数，全局变量
	
	    //根据页数读取数据
	    function getData(pagenumber) {
	        i++; //页码自动增加，保证下次调用时为新的一页。
	        //console.log(i);
	        //console.log(pagenumber);
	        $.ajax({
	            type: "get",
	            url: '<%=request.getContextPath()%>/province/record',
	            data: { pagesize: gPageSize, page: pagenumber },
	            dataType: "json",
	            success: function (res) {
	                $(".loaddiv").hide();
	                if(res.ok){
						res.data.list.forEach(record=>{
							var rec={};
							rec.date=record.timeset;
							rec.title=record.title;
							rec.detail=record.detail;
							rec.source=record.source;
							rec.url=record.url;
							
							addnewrecord(rec);
						});
						
					}
	            },
	            beforeSend: function () {
	                $(".loaddiv").show();
	            },
	            error: function () {
	                $(".loaddiv").hide();
	            }
	        });
	    }
	    //初始化加载第一页数据
	    getData(1);
	 
	    
	 
	    //==============核心代码=============
	    var winH = $(window).height(); //页面可视区域高度 
	 
	    var scrollHandler = function () {
	        var pageH = $(document.body).height();
	        var scrollT = $(window).scrollTop(); //滚动条top 
	        var aa = (pageH - winH - scrollT) / winH;
	        //console.log('scolled');
	        if (aa < 0.02) {//0.02是个参数
	            if (i % 10 === 0) {//每10页做一次停顿！
	                getData(i);
	                $(window).unbind('scroll');
	                $("#btn_Page").show();
	            } else {
	                getData(i);
	                $("#btn_Page").hide();
	            }
	        }
	    }
	    //定义鼠标滚动事件
	    $(window).scroll(scrollHandler);
	    //==============核心代码=============
	 
	    //继续加载按钮事件
	    $("#btn_Page").click(function () {
	        getData(i);
	        $(window).scroll(scrollHandler);
	    });
	});
  </script>
</head>

<body>
    <div class="box">
        <button id="back" class="hidden">返回全国</button>
        <div style="width:100%; text-align:center;">全国: 确诊<span style="color:red;" id="allconfirm">599</span>，疑似<span style="color:#C90;" id="allsuspect">399</span>，死亡<span style="color:white; background-color:red;padding:2px;" id="alldead">17</span>，治愈<span style="color:white;background-color:green;padding:2px;" id="allcure">28</span></div>
        <div id="china-map"></div>
    </div>

  <script>
    // 金额转换万字单位 start
    function unitConvert(num) {
        if (num) {
            var moneyUnits = ["", "万"],
                dividend = 10000,
                curentNum = num, //转换数字
                curentUnit = moneyUnits[0]; //转换单位 
            for (var i = 0; i < 2; i++) {
                curentUnit = moneyUnits[i];
                if (strNumSize(curentNum) < 5) {
                    return num;
                }
            }
            curentNum = curentNum / dividend;
            var m = {
                num: 0,
                unit: ""
            }
            m.num = curentNum.toFixed(2);
            m.unit = curentUnit;
            return m.num + m.unit;
        }
    }

    function strNumSize(tempNum) {
        var stringNum = tempNum.toString()
        var index = stringNum.indexOf(".")
        var newNum = stringNum
        if (index != -1) {
            newNum = stringNum.substring(0, index)
        }
        return newNum.length;
    }
    // 金额转换万字单位 end
    var myChart = echarts.init(document.getElementById('china-map'));
    var oBack = document.getElementById("back");

    var provinces = ['shanghai', 'hebei', 'shanxi', 'neimenggu', 'liaoning', 'jilin', 'heilongjiang', 'jiangsu', 'zhejiang', 'anhui', 'fujian', 'jiangxi', 'shandong', 'henan', 'hubei', 'hunan', 'guangdong', 'guangxi', 'hainan', 'sichuan', 'guizhou', 'yunnan', 'xizang', 'shanxi1', 'gansu', 'qinghai', 'ningxia', 'xinjiang', 'beijing', 'tianjin', 'chongqing', 'xianggang', 'aomen','taiwan'];
    var provincesText = ['上海', '河北', '山西', '内蒙古', '辽宁', '吉林', '黑龙江', '江苏', '浙江', '安徽', '福建', '江西', '山东', '河南', '湖北', '湖南', '广东', '广西', '海南', '四川', '贵州', '云南', '西藏', '陕西', '甘肃', '青海', '宁夏', '新疆', '北京', '天津', '重庆', '香港', '澳门','台湾'];
    // 全国省份数据
    var toolTipData = [{
        "provinceName": "北京",
        "provinceKey": 110000,
        "cityName": null,
        "cityKey": null,
        "totalConfirm": 58,
        "totalSuspect": 860448.7,
        "totalDead": 31744,
        "totalCure": 0
    }, {
        "provinceName": "天津",
        "provinceKey": 120000,
        "cityName": null,
        "cityKey": null,
        "totalConfirm": 74,
        "totalSuspect": 697438.3,
        "totalDead": 30025,
        "totalCure": 0
    }, {
        "provinceName": "河北",
        "provinceKey": 130000,
        "cityName": null,
        "cityKey": null,
        "totalConfirm": 175,
        "totalSuspect": 1051461.5,
        "totalDead": 50625,
        "totalCure": 0
    }, {
        "provinceName": "山西",
        "provinceKey": 140000,
        "cityName": null,
        "cityKey": null,
        "totalConfirm": 73,
        "totalSuspect": 432680.2,
        "totalDead": 20427,
        "totalCure": 0
    }, {
        "provinceName": "内蒙古",
        "provinceKey": 150000,
        "cityName": null,
        "cityKey": null,
        "totalConfirm": 46,
        "totalSuspect": 379952.5,
        "totalDead": 14585,
        "totalCure": 0
    }, {
        "provinceName": "辽宁",
        "provinceKey": 210000,
        "cityName": null,
        "cityKey": null,
        "totalConfirm": 74,
        "totalSuspect": 543290.6,
        "totalDead": 27143,
        "totalCure": 0
    }, {
        "provinceName": "吉林",
        "provinceKey": 220000,
        "cityName": null,
        "cityKey": null,
        "totalConfirm": 25,
        "totalSuspect": 234353.7,
        "totalDead": 11123,
        "totalCure": 0
    }, {
        "provinceName": "黑龙江",
        "provinceKey": 230000,
        "cityName": null,
        "cityKey": null,
        "totalConfirm": 25,
        "totalSuspect": 152894.8,
        "totalDead": 6481,
        "totalCure": 0
    }, {
        "provinceName": "上海",
        "provinceKey": 310000,
        "cityName": null,
        "cityKey": null,
        "totalConfirm": 78,
        "totalSuspect": 665877.5,
        "totalDead": 26753,
        "totalCure": 0
    }, {
        "provinceName": "江苏",
        "provinceKey": 320000,
        "cityName": null,
        "cityKey": null,
        "totalConfirm": 475,
        "totalSuspect": 3302139.4,
        "totalDead": 158180,
        "totalCure": 0
    }, {
        "provinceName": "浙江",
        "provinceKey": 330000,
        "cityName": null,
        "cityKey": null,
        "totalConfirm": 332,
        "totalSuspect": 2285259.3,
        "totalDead": 116344,
        "totalCure": 0
    }, {
        "provinceName": "安徽",
        "provinceKey": 340000,
        "cityName": null,
        "cityKey": null,
        "totalConfirm": 168,
        "totalSuspect": 1081322.1,
        "totalDead": 57139,
        "totalCure": 0
    }, {
        "provinceName": "福建",
        "provinceKey": 350000,
        "cityName": null,
        "cityKey": null,
        "totalConfirm": 145,
        "totalSuspect": 1352019.8,
        "totalDead": 65228,
        "totalCure": 0
    }, {
        "provinceName": "江西",
        "provinceKey": 360000,
        "cityName": null,
        "cityKey": null,
        "totalConfirm": 103,
        "totalSuspect": 689353.7,
        "totalDead": 31822,
        "totalCure": 0
    }, {
        "provinceName": "山东",
        "provinceKey": 370000,
        "cityName": null,
        "cityKey": null,
        "totalConfirm": 198,
        "totalSuspect": 1177320.9,
        "totalDead": 59966,
        "totalCure": 0
    }, {
        "provinceName": "河南",
        "provinceKey": 410000,
        "cityName": null,
        "cityKey": null,
        "totalConfirm": 184,
        "totalSuspect": 953710.6,
        "totalDead": 52829,
        "totalCure": 0
    }, {
        "provinceName": "湖北",
        "provinceKey": 420000,
        "cityName": null,
        "cityKey": null,
        "totalConfirm": 125,
        "totalSuspect": 890921.4,
        "totalDead": 46768,
        "totalCure": 0
    }, {
        "provinceName": "湖南",
        "provinceKey": 430000,
        "cityName": null,
        "cityKey": null,
        "totalConfirm": 111,
        "totalSuspect": 1007182.7,
        "totalDead": 44094,
        "totalCure": 0
    }, {
        "provinceName": "广东",
        "provinceKey": 440000,
        "cityName": null,
        "cityKey": null,
        "totalConfirm": 384,
        "totalSuspect": 3792306.1,
        "totalDead": 165774,
        "totalCure": 0
    }, {
        "provinceName": "广西",
        "provinceKey": 450000,
        "cityName": null,
        "cityKey": null,
        "totalConfirm": 194,
        "totalSuspect": 1252955,
        "totalDead": 69882,
        "totalCure": 0
    }, {
        "provinceName": "海南",
        "provinceKey": 460000,
        "cityName": null,
        "cityKey": null,
        "totalConfirm": 58,
        "totalSuspect": 617514,
        "totalDead": 33090,
        "totalCure": 0
    }, {
        "provinceName": "重庆",
        "provinceKey": 500000,
        "cityName": null,
        "cityKey": null,
        "totalConfirm": 35,
        "totalSuspect": 468892.6,
        "totalDead": 20163,
        "totalCure": 0
    }, {
        "provinceName": "四川",
        "provinceKey": 510000,
        "cityName": null,
        "cityKey": null,
        "totalConfirm": 127,
        "totalSuspect": 793622.7,
        "totalDead": 43625,
        "totalCure": 0
    }, {
        "provinceName": "贵州",
        "provinceKey": 520000,
        "cityName": null,
        "cityKey": null,
        "totalConfirm": 78,
        "totalSuspect": 659747.2,
        "totalDead": 28817,
        "totalCure": 0
    }, {
        "provinceName": "云南",
        "provinceKey": 530000,
        "cityName": null,
        "cityKey": null,
        "totalConfirm": 87,
        "totalSuspect": 657485.2,
        "totalDead": 30916,
        "totalCure": 0
    }, {
        "provinceName": "西藏",
        "provinceKey": 540000,
        "cityName": null,
        "cityKey": null,
        "totalConfirm": 5,
        "totalSuspect": 106922.4,
        "totalDead": 2470,
        "totalCure": 0
    }, {
        "provinceName": "陕西",
        "provinceKey": 610000,
        "cityName": null,
        "cityKey": null,
        "totalConfirm": 65,
        "totalSuspect": 589961.2,
        "totalDead": 27093,
        "totalCure": 0
    }, {
        "provinceName": "甘肃",
        "provinceKey": 620000,
        "cityName": null,
        "cityKey": null,
        "totalConfirm": 40,
        "totalSuspect": 248209.2,
        "totalDead": 12390,
        "totalCure": 0
    }, {
        "provinceName": "青海",
        "provinceKey": 630000,
        "cityName": null,
        "cityKey": null,
        "totalConfirm": 3,
        "totalSuspect": 33328.1,
        "totalDead": 1161,
        "totalCure": 0
    }, {
        "provinceName": "宁夏",
        "provinceKey": 640000,
        "cityName": null,
        "cityKey": null,
        "totalConfirm": 0,
        "totalSuspect": 146590.7,
        "totalDead": 5240,
        "totalCure": 0
    }, {
        "provinceName": "新疆",
        "provinceKey": 650000,
        "cityName": null,
        "cityKey": null,
        "totalConfirm": 43,
        "totalSuspect": 0,
        "totalDead": 11741,
        "totalCure": 0
    }, {
        "provinceName": "香港",
        "provinceKey": 700000,
        "cityName": null,
        "cityKey": null,
        "totalConfirm": 43,
        "totalSuspect": 0,
        "totalDead": 11741,
        "totalCure": 0
    }, {
        "provinceName": "澳门",
        "provinceKey": 800000,
        "cityName": null,
        "cityKey": null,
        "totalConfirm": 43,
        "totalSuspect": 0,
        "totalDead": 11741,
        "totalCure": 0
    }, {
        "provinceName": "台湾",
        "provinceKey": 900000,
        "cityName": null,
        "cityKey": null,
        "totalConfirm": 43,
        "totalSuspect": 0,
        "totalDead": 11741,
        "totalCure": 0
    }]
    var seriesData = [];
    for (var i = 0; i < toolTipData.length; i++) {
        seriesData[i] = {};
        seriesData[i].name = toolTipData[i].provinceName;
        seriesData[i].value = toolTipData[i].totalConfirm;
        seriesData[i].provinceKey = toolTipData[i].provinceKey;
    }
    // 请求省市数据，传递provinceKey进行ajax请求 province(key)
    var provinceData = [
    
    {
        "provinceName": null,
        "provinceKey": null,
        "cityName": "乌鲁木齐市",
        "cityKey": 650100,
        "totalConfirm": 0,
        "totalSuspect": 0,
        "totalDead": 0,
        "totalCure": 0
    }, {
        "provinceName": null,
        "provinceKey": null,
        "cityName": "克拉玛依市",
        "cityKey": 650200,
        "totalConfirm": 1,
        "totalSuspect": 363.6,
        "totalDead": 17,
        "totalCure": 0
    }, {
        "provinceName": null,
        "provinceKey": null,
        "cityName": "昌吉回族自治州",
        "cityKey": 652300,
        "totalConfirm": 3,
        "totalSuspect": 2203.7,
        "totalDead": 82,
        "totalCure": 0
    }, {
        "provinceName": null,
        "provinceKey": null,
        "cityName": "博尔塔拉蒙古自治州",
        "cityKey": 652700,
        "totalConfirm": 1,
        "totalSuspect": 7327.7,
        "totalDead": 236,
        "totalCure": 0
    }, {
        "provinceName": null,
        "provinceKey": null,
        "cityName": "巴音郭楞蒙古自治州",
        "cityKey": 652800,
        "totalConfirm": 2,
        "totalSuspect": 28768.4,
        "totalDead": 961,
        "totalCure": 0
    }, {
        "provinceName": null,
        "provinceKey": null,
        "cityName": "阿克苏地区",
        "cityKey": 652900,
        "totalConfirm": 5,
        "totalSuspect": 78415.2,
        "totalDead": 3108,
        "totalCure": 0
    }, {
        "provinceName": null,
        "provinceKey": null,
        "cityName": "喀什地区",
        "cityKey": 653100,
        "totalConfirm": 4,
        "totalSuspect": 38870.1,
        "totalDead": 1477,
        "totalCure": 0
    }, {
        "provinceName": null,
        "provinceKey": null,
        "cityName": "和田地区",
        "cityKey": 653200,
        "totalConfirm": 1,
        "totalSuspect": 10488,
        "totalDead": 218,
        "totalCure": 0
    }, {
        "provinceName": null,
        "provinceKey": null,
        "cityName": "伊犁哈萨克自治州",
        "cityKey": 654000,
        "totalConfirm": 6,
        "totalSuspect": 32864.2,
        "totalDead": 1363,
        "totalCure": 0
    }, {
        "provinceName": null,
        "provinceKey": null,
        "cityName": "塔城地区",
        "cityKey": 654200,
        "totalConfirm": 1,
        "totalSuspect": 160,
        "totalDead": 5,
        "totalCure": 0
    }, {
        "provinceName": null,
        "provinceKey": null,
        "cityName": "省直辖行政单位",
        "cityKey": 659000,
        "totalConfirm": 2,
        "totalSuspect": 5533.4,
        "totalDead": 255,
        "totalCure": 0
    }
    ];
    var seriesDataPro = [];
    for (var i = 0; i < provinceData.length; i++) {
        seriesDataPro[i] = {};
        seriesDataPro[i].name = provinceData[i].cityName;
        seriesDataPro[i].value = provinceData[i].totalConfirm;
    }

    var max = Math.max.apply(Math, seriesData.map(function(o) {
            return o.value
        })),
        min = 0; // 侧边最大值最小值
    var maxSize4Pin = 40,
        minSize4Pin = 30;
    // 点击返回按钮
    oBack.onclick = function() {
        $('#back').addClass('hidden');
        mapName = '';
        initEcharts("china", "中国");
    };

    var mapName = '';

    function getGeoCoordMap(name) {
        name = name ? name : 'china';
        /*获取地图数据*/
        var geoCoordMap = {};
        myChart.showLoading(); // loading start
        var mapFeatures = echarts.getMap(name).geoJson.features;
        myChart.hideLoading(); // loading end
        mapFeatures.forEach(function(v) {
            var name = v.properties.name; // 地区名称
            geoCoordMap[name] = v.properties.cp; // 地区经纬度
        });
        return geoCoordMap;
    }

    function convertData(data) { // 转换数据
        var geoCoordMap = getGeoCoordMap(mapName);
        var res = [];
        for (var i = 0; i < data.length; i++) {
            var geoCoord = geoCoordMap[data[i].name]; // 数据的名字对应的经纬度
            if (geoCoord) { // 如果数据data对应上，
                res.push({
                    name: data[i].name,
                    value: geoCoord.concat(data[i].value),
                });
            }
        }
        return res;
    };
    
    var timer;
    var last;
    function update(){
    	timer=setTimeout(update,5000);
    	
    	//get data
    	//url: /province/query
    	$.ajax({
			url:'<%=request.getContextPath()%>/province/query',
			method:'GET',
			//data:{testid:testid},
			success:function(resp){
				//console.log(resp)
				if (resp.ok) {
					if(resp.data){
						toolTipData=[];
						cleartable();
						
						var sumpro={
							'provincetext':'总计',
							'provincekey':'0000000',
							'totalconfirm':0,
							'totalsuspect':0,
							'totaldead':0,
							'totalcure':0
						};
						for(var i=0;i<resp.data.length;i++){
							var ele={
								"provinceName": "省份",
						        "provinceKey": 100000,
						        "cityName": null,
						        "cityKey": null,
						        "totalConfirm": 0,
						        "totalSuspect": 0,
						        "totalDead": 0,
						        "totalCure": 0
						    };
						    var pro=resp.data[i];
						    
						    ele.provinceName=pro.provincetext;
						    ele.provinceKey=pro.provincekey;
						    ele.totalConfirm=pro.totalconfirm;
						    ele.totalSuspect=pro.totalsuspect;
						    ele.totalDead=pro.totaldead;
						    ele.totalCure=pro.totalcure;
							
							sumpro.totalconfirm=sumpro.totalconfirm+pro.totalconfirm;
							sumpro.totalsuspect=sumpro.totalsuspect+pro.totalsuspect;
							sumpro.totaldead=sumpro.totaldead+pro.totaldead;
							sumpro.totalcure=sumpro.totalcure+pro.totalcure;
							
						    if(ele.totalConfirm>0 ||ele.totalSuspect>0){
						    	toolTipData.push(ele);
								insertarow(pro);
								
						    }
						}
						insertarow(sumpro);
						last=resp.last;
						
						$('#allconfirm').text(sumpro.totalconfirm);
						$('#allsuspect').text(sumpro.totalsuspect);
						$('#alldead').text(sumpro.totaldead);
						$('#allcure').text(sumpro.totalcure);
						
						
						
						//handle data
				    	//console.log(toolTipData);
				    	seriesData = [];
					    for (var i = 0; i < toolTipData.length; i++) {
					        seriesData[i] = {};
					        seriesData[i].name = toolTipData[i].provinceName;
					        seriesData[i].value = toolTipData[i].totalConfirm;
					        seriesData[i].provinceKey = toolTipData[i].provinceKey;
					    }
					    
					    max = Math.max.apply(Math, seriesData.map(function(o) {
				            return o.value
				        }));
        
					    initEcharts("china", "2019-nCov 实时形势图 ");
					    
					}
				}else{
					console.log("get last information empty");
				}
			},
			error: function () {
				console.log("get last information error");
			}
			
		});
    	
    	
    };
    
    
    // 初始化echarts-map
    //initEcharts("china", "2019-nCov 实时形势图 ");
	update();
	
    function initEcharts(pName, Chinese_) {
        var tmpSeriesData = pName === "china" ? seriesData : seriesDataPro;
        var tmp = pName === "china" ? toolTipData : provinceData;
        
        //console.log(tmpSeriesData);
        var option = {
            title: {
                text: Chinese_ || pName,
                left: 'center'
                ,subtext:'源于网络 '+(last?last.timeset:'')
            },
            tooltip: {
                trigger: 'item',
                formatter: function(params) { // 鼠标滑过显示的数据
                    if (pName === "china") {
                        var toolTiphtml = ''
                        for (var i = 0; i < tmp.length; i++) {
                            if (params.name == tmp[i].provinceName) {
                                //toolTiphtml += tmp[i].provinceName + '<br>确诊数：' + unitConvert(tmp[i].totalSuspect) + '<br>疑似数：' + tmp[i].totalDead + '' + '<br>治愈数：' + tmp[i].totalConfirm+ '<br>死亡数：' + tmp[i].totalConfirm;
								var dname=tmp[i].provinceName;
                                toolTiphtml += dname + '<br>确诊数：' + (tmp[i].totalConfirm) + '<br>疑似数：' + tmp[i].totalSuspect + '' + '<br>死亡数：<span style="color:red; background-color:white; width:100%;">' + tmp[i].totalDead+ '</span><br>治愈数：<span style="color:green; background-color:white; width:100%;">' + tmp[i].totalCure+'</span>';
                            }
                        }
                        return toolTiphtml;
                    } else {
                        var toolTiphtml = ''
                        for (var i = 0; i < tmp.length; i++) {
                            if (params.name == tmp[i].cityName) {
								var dname=tmp[i].cityName;
                                toolTiphtml += dname + '<br>p确诊数：' + (tmp[i].totalConfirm) + '<br>疑似数：' + tmp[i].totalSuspect + '' + '<br>死亡数：<span style="color:red; background-color:white; width:100%;">' + tmp[i].totalDead+ '</span><br>治愈数：<span style="color:green; background-color:white; width:100%;">' + tmp[i].totalCure+'</span>';
                            }
                        }
                        return toolTiphtml;
                    }
                }
            },
            visualMap: { //视觉映射组件
                show: true,
                //min: min,
                min:0,
                max: max, // 侧边滑动的最大值，从数据中获取
                left: '5%',
                top: '96%',
                inverse: true, //是否反转 visualMap 组件
                // itemHeight:200,  //图形的高度，即长条的高度
                text: ['高', '低'], // 文本，默认为数值文本
                calculable: false, //是否显示拖拽用的手柄（手柄能拖拽调整选中范围）
                seriesIndex: 1, //指定取哪个系列的数据，即哪个系列的 series.data,默认取所有系列
                orient: "horizontal",
                inRange: {
                    //color: ['#dbfefe', '#1066d5'] // 蓝绿
                    color: ['#F7B620', '#950303'] // 黄红
                    //color: ['#FFF', '#950303'] // 白红
                }
            },
            geo: {
                show: true,
                map: pName,
                roam: false,
                label: {
                    normal: {
                        show: false
                    },
                    emphasis: {
                        show: false,
                    }
                },
                itemStyle: {
                    normal: {
                        areaColor: '#3c8dbc', // 没有值得时候颜色
                        borderColor: '#097bba',
                    },
                    emphasis: {
                        areaColor: '#fbd456', // 鼠标滑过选中的颜色
                    }
                }
            },
            series: [{
                    name: '散点',
                    type: 'scatter',
                    coordinateSystem: 'geo',
                    data: tmpSeriesData,
                    symbolSize: '1',
                    label: {
                        normal: {
                            show: true,
                            formatter: '{b}',
                            position: 'right'
                        },
                        emphasis: {
                            show: true
                        }
                    },
                    itemStyle: {
                        normal: {
                            color: '#895139' // 字体颜色
                        }
                    }
                },
                {
                    name: Chinese_ || pName,
                    type: 'map',
                    mapType: pName,
                    roam: false, //是否开启鼠标缩放和平移漫游
                    data: tmpSeriesData,
                    // top: "3%",//组件距离容器的距离
                    // geoIndex: 0,
                    // aspectScale: 0.75,       //长宽比
                    // showLegendSymbol: false, // 存在legend时显示
                    selectedMode: 'single',
                    label: {
                        normal: {
                            show: true, //显示省份标签
                            textStyle: {
                                color: "#895139"
                                //color: "#FFF"
                            } //省份标签字体颜色
                        },
                        emphasis: { //对应的鼠标悬浮效果
                            show: true,
                            textStyle: {
                                color: "#323232"
                            }
                        }
                    },
                    itemStyle: {
                        normal: {
                            borderWidth: .5, //区域边框宽度
                            borderColor: '#0550c3', //区域边框颜色
                            //areaColor: "#0b7e9e", //区域颜色
                            areaColor: "#FFF", //区域颜色
                        },
                        emphasis: {
                            borderWidth: .5,
                            borderColor: '#4b0082',
                            areaColor: "#ece39e",
                        }
                    }
                },
                {
                    name: '点',
                    type: 'scatter',
                    coordinateSystem: 'geo',
                    symbol: 'pin', //气泡
                    symbolSize: function(val) {
                        var a = (maxSize4Pin - minSize4Pin) / (max - min);
                        var b = minSize4Pin - a * min;
                        b = maxSize4Pin - a * max;
                        return a * val[2] + b;
                    },
                    label: {
                        normal: {
                            show: true,
                            formatter: function(params) {
                                return params.data.value[2];
                            },
                            textStyle: {
                                color: '#fff',
                                fontSize: 9
                            }
                        }
                    },
                    itemStyle: {
                        normal: {
                            color: 'red' //标志颜色'#F62157'
                        }
                    },
                    zlevel: 6,
                    data: convertData(tmpSeriesData),
                },
            ]
        };
        // 针对海南放大
        if (pName == '海南') {
            option.series[1].center = [109.844902, 19.0392];
            option.series[1].layoutCenter = ['50%', '50%'];
            option.series[1].layoutSize = "300%";
        } else { //非显示海南时，将设置的参数恢复默认值
            option.series[1].center = undefined;
            option.series[1].layoutCenter = undefined;
            option.series[1].layoutSize = undefined;
        }
        
        //针对没有的，设置areaColor
        //TODO
        //console.log(option.series[2].data);
        
        myChart.setOption(option);
        /* 响应式 */
        $(window).resize(function() {
            myChart.resize();
        });

        myChart.off("click");
		/*
        if (pName === "china") { // 全国时，添加click 进入省级
            myChart.on('click', function(param) {
                // console.log(param.name);
                if (param.data && param.data.provinceKey) {
                    var key = param.data.provinceKey;
                    // province(key);  省份请求
                    if (provinceData.length) {
                        $('#back').removeClass('hidden');
                        // 遍历取到provincesText 中的下标  去拿到对应的省js
                        for (var i = 0; i < provincesText.length; i++) {
                            if (param.name === provincesText[i]) {
                                mapName = provincesText[i];
                                //显示对应省份的方法
                                showProvince(provinces[i], provincesText[i]);
                                break;
                            }
                        }
                    }
                }
            });
        } else { // 省份，添加双击 回退到全国
            myChart.on("dblclick", function() {
                $('#back').addClass('hidden');
                mapName = '';
                initEcharts("china", "中国");
            });
        }
		*/
    }

    // 展示对应的省
    function showProvince(pName, Chinese_) {
        //这写省份的js都是通过在线构建工具生成的，保存在本地，需要时加载使用即可，最好不要一开始全部直接引入。
        loadBdScript('$' + pName + 'JS', './js/map/province/' + pName + '.js', function() {
            initEcharts(Chinese_);
        });
    }

    // 加载对应的JS
    function loadBdScript(scriptId, url, callback) {
        var script = document.createElement("script");
        script.type = "text/javascript";
        if (script.readyState) { //IE
            script.onreadystatechange = function() {
                if (script.readyState === "loaded" || script.readyState === "complete") {
                    script.onreadystatechange = null;
                    callback();
                }
            };
        } else { // Others
            script.onload = function() {
                callback();
            };
        }
        script.src = url;
        script.id = scriptId;
        document.getElementsByTagName("head")[0].appendChild(script);
    };
  </script>
  
  <script>
  function insertarow(record){
		var table = document.getElementById("tab_count");
		var newRow = table.insertRow(); //创建新行
		
		var newCell1 = newRow.insertCell(0); //创建新单元格
		newCell1.innerHTML = "<td>"+record.provincetext+"</td>" ; //单元格内的内容
		newCell1.setAttribute("align","center"); //设置位置
		
		var newCell2 = newRow.insertCell(1); //创建新单元格
		newCell2.innerHTML = "<td class='confirm'>"+record.totalconfirm+"</td>";
		newCell2.setAttribute("align","center"); //设置位置
		
		var newCell3 = newRow.insertCell(2); //创建新单元格
		newCell3.innerHTML = "<td class='suspect'>"+record.totalsuspect+"</td>";
		newCell3.setAttribute("align","center"); //设置位置
		
		var newCell4 = newRow.insertCell(3); //创建新单元格
		newCell4.innerHTML = "<td class='dead'>"+record.totaldead+"</td>";
		newCell4.setAttribute("align","center"); //设置位置
		
		var newCell5 = newRow.insertCell(4); //创建新单元格
		newCell5.innerHTML = "<td class='cure'>"+record.totalcure+"</td>";
		newCell5.setAttribute("align","center"); //设置位置
  }
  function cleartable(){
  	var t1=document.getElementById("tab_count");	
	var rowNum=t1.rows.length;
	if(rowNum>0)
	{
		for(i=1;i<rowNum;i++)
		{
			t1.deleteRow(i);
			rowNum=rowNum-1;
			i=i-1;
		}
	}
  }
  </script>
  <div class="box" style="display:'';">
  <table border="0" cellpadding="3" cellspacing="1" id="tab_count" style="width:100%; background-color:#999;">
  	<tr>
    <th>省份</th><th>确诊</th><th>疑似</th><th>死亡</th><th>治愈</th>
    </tr>
    
  </table>
  </div>
  
  <div style="width:100%; background-color:#CCC;">最新动态</div>
  
  <section id="cd-timeline" class="cd-container">
  </section>
  <style>
	  .alink
	  {
	      display:none;
	  }
	  .loaddiv
	  {
	     display:none; 
	  }
  </style>
  <div class="loaddiv">
  	<img src="images/loading.gif" />
  </div>
  <div>
  	<a href="javascript:void(0);" id="btn_Page" class="alink">查看更多>>></a>
  </div> 
<script>
$(function(){
	var $timeline_block = $('.cd-timeline-block');
	//hide timeline blocks which are outside the viewport
	$timeline_block.each(function(){
		if($(this).offset().top > $(window).scrollTop()+$(window).height()*0.75) {
			$(this).find('.cd-timeline-img, .cd-timeline-content').addClass('is-hidden');
		}
	});
	//on scolling, show/animate timeline blocks when enter the viewport
	$(window).on('scroll', function(){
		$timeline_block.each(function(){
			if( $(this).offset().top <= $(window).scrollTop()+$(window).height()*0.75 && $(this).find('.cd-timeline-img').hasClass('is-hidden') ) {
				$(this).find('.cd-timeline-img, .cd-timeline-content').removeClass('is-hidden').addClass('bounce-in');
			}
		});
	});
	
	//getnews(1);
});
</script>

	<script>
        function getnews(p){
			$.get('<%=request.getContextPath()%>/province/record',{'page':p}).then(function (res) {
					if(res.ok){
						res.data.list.forEach(record=>{
							var rec={};
							rec.date=record.timeset;
							rec.title=record.title;
							rec.detail=record.detail;
							rec.source=record.source;
							rec.url=record.url;
							
							addnewrecord(rec);
						});
						
					}
                    
                });
		}
		function addnewrecord(record){
			//var record={"date":"2019-12-30","title":"32","detail":"","source":"央视微博","url":"#"};
			var content='<div class="cd-timeline-block">\
<div class="cd-timeline-img cd-picture">\
<img src="images/cd-icon-location.svg" alt="Location">\
</div>\
<div class="cd-timeline-content">\
<h2>'+record.title+'</h2>\
<p>'+record.detail+'</p>\
<a href="'+record.url+'" target="_new" class="cd-read-more">来源 '+record.source+'</a>\
<span class="cd-date">'+record.date+'</span>\
</div> \
</div>';
		$('#cd-timeline').append(content);
		}
    </script>
     
</body>

</html>
