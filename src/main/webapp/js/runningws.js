
    var websocket = null;
    //判断当前浏览器是否支持WebSocket
    if ('WebSocket' in window) {
        //websocket = new WebSocket("ws://localhost:28080/wifiatc/testwebsocket");
        
        var ws_url=window.location.host + "<%=path%>/runningcase"; //.host包含port,不含port得叫.hostname
        
        if (location.protocol == 'http:') {
		    ws_url="ws://"+ws_url;
		} else {
		    ws_url="wss://"+ws_url;
		}
        websocket = new WebSocket(ws_url);
    }
    else {
        alert('当前浏览器 Not support websocket')
    }

    //连接发生错误的回调方法
    websocket.onerror = function () {
        setMessageInnerHTML("WebSocket连接发生错误");
    };

    //连接成功建立的回调方法
    websocket.onopen = function () {
        setMessageInnerHTML("WebSocket连接成功");
    }

    //接收到消息的回调方法
    websocket.onmessage = function (event) {
    	//console.log('got message');
        setMessageInnerHTML(event.data);
        handleResponse(event.data);
        
    }

    //连接关闭的回调方法
    websocket.onclose = function () {
        setMessageInnerHTML("WebSocket连接关闭");
    }

    //监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
    window.onbeforeunload = function () {
        closeWebSocket();
    }

    //将消息显示在网页上
    function setMessageInnerHTML(innerHTML) {
        document.getElementById('message').innerHTML += innerHTML + '<br/>';
    }

    //关闭WebSocket连接
    function closeWebSocket() {
        websocket.close();
    }

    //发送消息
    function send() {
        var message = document.getElementById('text').value;
        var m={};
        m.action="msg";
        m.data=message;
        websocket.send(JSON.stringify(m));
        
    }
    
    function cmdStop(){
    	var json = JSON.stringify({
                    "action":"stop"
                });
        sendCmd(json);
    }
    
    function cmdRun(){
    	var json = JSON.stringify({
                    "action":"run",
                    "testid":"68",
                    "config":{
                    	"readlog":true
                    }
                });
        sendCmd(json);
    }
    
    function sendCmd(json){
    	websocket.send(json);
    }
    
    function handleResponse(json){
    	var response=JSON.parse(json);
    	console.log(response);
    	console.log(response.data);
    	
    }
