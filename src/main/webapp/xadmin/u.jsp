<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="../include.jsp" %>
<%

List<Province> list=dao.query(Province.class,Cnd.orderBy().asc("id"));
if(dao==null){
	out.println("null dao");
}

//out.println("list:"+list.size());
%>
<!DOCTYPE html>
<html>
  
  <head>
    <meta charset="UTF-8">
    <title>U</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width,user-scalable=yes, minimum-scale=0.4, initial-scale=0.8,target-densitydpi=low-dpi" />
    <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon" />
    <link rel="stylesheet" href="./css/font.css">
    <link rel="stylesheet" href="./css/xadmin.css">
    <script type="text/javascript" src="./js/jquery.min.js"></script>
    <script type="text/javascript" src="./lib/layui/layui.js" charset="utf-8"></script>
    <script type="text/javascript" src="./js/xadmin.js"></script>
    <!-- 让IE8/9支持媒体查询，从而兼容栅格 -->
    <!--[if lt IE 9]>
      <script src="./js/html5.min.js"></script>
      <script src="./js/respond.min.js"></script>
    <![endif]-->
  </head>
  
  <body>
    <div class="x-nav">
      <span class="layui-breadcrumb">
        <a href="">首页</a>
        <a href="">设置</a>
        <a>
          <cite>案例数</cite></a>
      </span>
      <a class="layui-btn layui-btn-small" style="line-height:1.6em;margin-top:3px;float:right" href="javascript:location.replace(location.href);" title="刷新">
        <i class="layui-icon" style="line-height:30px">ဂ</i></a>
    </div>
    <div class="x-body">
      <xblock>
        <span class="x-right" style="line-height:40px">共有数据：<%=list.size() %> 条</span>
      </xblock>
      <table class="layui-table">
        <thead>
          <tr>
            <th>
              <div class="layui-unselect header layui-form-checkbox" lay-skin="primary"><i class="layui-icon">&#xe605;</i></div>
            </th>
            <th hidden="true">ID</th>
            <th>Province</th>
            <th>Confirmed</th>
            <th>Suspect</th>
            <th>Dead</th>
            <th>Cured</th>
            <th>操作</th>
            </tr>
        </thead>
        <tbody>
          <%for(Province data : list){
          %>
          <tr>
            <td>
              <div class="layui-unselect layui-form-checkbox" lay-skin="primary" data-id='<%=data.getId()%>'><i class="layui-icon">&#xe605;</i></div>
            </td>
            <td hidden="true"><%=data!=null?data.getId():""%></td>
            <td><%=data.getProvincetext()%></td>
            <td><input type="text" name="aa_" id="aa_<%=data.getId() %>" value="<%=data!=null?data.getTotalconfirm():""%>" onchange="member_change(this,<%=data.getId() %>,this.value,'confirm')"></td>
            <td><input type="text" name="aa_" id="ab_<%=data.getId() %>" value="<%=data!=null?data.getTotalsuspect():""%>" onchange="member_change(this,<%=data.getId() %>,this.value,'suspect')"></td>
            <td><input type="text" name="aa_" id="ac_<%=data.getId() %>" value="<%=data!=null?data.getTotaldead():""%>" onchange="member_change(this,<%=data.getId() %>,this.value,'dead')"></td>
            <td><input type="text" name="aa_" id="ad_<%=data.getId() %>" value="<%=data!=null?data.getTotalcure():""%>" onchange="member_change(this,<%=data.getId() %>,this.value,'cure')"></td>
            
            <td class="td-manage">
              
              <a title="清除" onclick="member_change(this,<%=data.getId()%>,0,'clear')" href="javascript:;">
                <i class="layui-icon">&#xe640;</i>
              </a>
            </td>
          </tr>
          <%}%>
        </tbody>
      </table>

    </div>
    <script>
      layui.use('laydate', function(){
        var laydate = layui.laydate;
        
        //执行一个laydate实例
        laydate.render({
          elem: '#start' //指定元素
        });

        //执行一个laydate实例
        laydate.render({
          elem: '#end' //指定元素
        });
      });
		
	  
	  function member_change(obj,id,count,type){
	  	//console.log('change '+att);
	  	if(!isInt(count)){
	  		layer.msg('值必须为纯数字。',{icon: 2});
        	return;
	  	}
	  		$.ajax({
				url:'<%=request.getContextPath()%>/province/modify',
				method:'POST',
				data:{id:id,count:count,type:type},
				success:function(resp){
					//console.log('create succ');
					//console.log(resp)
						if (resp.ok) {
							if(resp.data){
								//console.log($(obj).parents("tr").children("td").children("input")[0]);
								$(obj).parents("tr").children("td")[1].innerHTML=resp.data.id;
								$(obj).parents("tr").children("td").children("input")[0].value=resp.data.totalconfirm;
								$(obj).parents("tr").children("td").children("input")[1].value=resp.data.totalsuspect;
								$(obj).parents("tr").children("td").children("input")[2].value=resp.data.totaldead;
								$(obj).parents("tr").children("td").children("input")[3].value=resp.data.totalcure;
								
							}
              				//layer.msg('已删除!',{icon:1,time:1000});
						}
					},
					error: function () {
						console.log("change出现错误");
						return false;
					}
				
				});
	  }
      
	  function isInt(val){
	  	return parseInt(val).toString() != "NaN";	
	  }
      function changeAll(airatt) {
      
        if(!isInt(airatt)){
        	layer.msg('值必须为纯数字。',{icon: 2});
        	return;
        } 

        var data = tableCheck.getData();
  		//console.log(data);
		if(!data || data.length<=0){
			layer.msg('请选择至少一项。',{icon: 2});
			return;
		}
		
        layer.confirm('确认要批量操作吗？',function(index){
            //捉到所有被选中的，发异步进行删除
			//console.log(data);
			$.ajax({
				url:'<%=request.getContextPath()%>/province/modifysome',
				method:'POST',
				data:{deviceatts:data,airatt:airatt},
				success:function(resp){
					//console.log('create succ');
					//console.log(resp)
					if (resp.ok) {
						layer.msg('操作成功', {icon: 1});
						for(var att in data){
							//console.log($('#aa_'+att));
							$('#aa_'+att).val(airatt);
						}
           				//$(".layui-form-checked").not('.header').parents('tr').remove();
					}
				},
				error: function () {
					layer.msg("出现错误", {icon: 2});
					return false;
				}
				
			});
			
            
        });
      }
    </script>
    <script></script>
  </body>

</html>