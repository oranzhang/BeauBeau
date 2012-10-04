	var t = document.title;
	var last_page;
function check_post(title,data) {
	var ok = 0
	if (title == ''){
		ok++;
	}
	if (data == '<div class="preview"></div>'){
		ok++;
	}
	if (ok == 0) {
		var ok2 = true;
	}
	return ok2;
}
function check_reply(data) {
	var ok = 0
	if (data == '<div class="preview"></div>'){
		ok++;
	}
	if (ok == 0) {
		var ok2 = true;
	}
	return ok2;
}
function new_ct(node){
	var list = $("#ajaxwait_latest_topic");
	var view = $("#ajaxwait_view_topic");
	$("#ajax_loading").show();
	view.load("/!!/CTbox/" + node,'',function(){
		post_to();
		list.slideUp();
		view.slideDown();
		$("#ajax_loading").hide();
	});
}
function new_LRbox(){
		$("#dark").load("/!!/LRbox");
		$("#dark").slideToggle();
	}
function reguser(){
	$("#dark").load('/!!/LRbox_reg');
}
function luser(){
	$("#dark").load('/!!/LRbox');
}
function Login(){
	var user = $("#L_user")[0].value;
	var re =/^[A-Za-z0-9]+$/;
	$("#ajax_loginstatus").html('<a id="temp_st">登录中，请稍候，若长时间无响应请刷新页面。</a>');
	if (re.test(user)){
		var pass = SHA1($("#L_pass")[0].value);
		$.getJSON('/!!/Login/' + user + '&' + pass,function(d){
			var status = d.msg;
			if(status == 1) {
				$("#ajax_loginstatus").html('<a id="temp_st" style="color:green">登入成功，若无反应请刷新。</a>');
				index_topic(1);
				$("#ajaxwait_user").load('/!!/Userbox',"",function(){setTimeout('$("#dark").slideToggle()',800);regNavitoggle();});
			}
			else
			{
				$("#ajax_loginstatus").html('<a id="temp_st" style="color:red">用户名或密码错误或用户名不存在。</a>');
			}
		});
	}
	else{$("#ajax_loginstatus").html('<a id="temp_st" style="color:red">用户名只能由字母和数字组成</a>');}
}
function CreatUser(){
		var email_p = /^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(.[a-zA-Z0-9_-])+/;
		var user_p =/^[A-Za-z0-9]+$/;
		var count = 0;
		var user = $("#R_user")[0].value;
		var pass = $("#R_pass")[0].value;
		var repass = $("#R_repass")[0].value;
		var mail = $("#R_mail")[0].value;
		var err1 = "";
		var err2 = "";
		var err3 = "";
		if	(user_p.test(user)) {
			count++;
		}
		else {
			err1 = "用户名只能由字母和数字组成。";
		}
		if (pass == repass) {
			count++;
			var p_sha1 = SHA1(pass)
		}
		else {
			 err2 = "两次密码输入不一致。";
		}
		if (email_p.test(mail)) {
			count++;
		}
		else {
			err3 = "邮箱不符合格式。";
		}
		if (count == 3) {
			var json = '{"user":"' + user + '","pass":"' + p_sha1 + '","mail":"' + mail +'"}' ;
			var b64 = BASE64.encode(json);
			$.getJSON('/!!/Register/' + b64 , function(b){
				var status = b.msg;
				if (status == 1) {
					$("#ajax_loginstatus").html('<a id="temp_st" style="color:red">抱歉，用户名已经存在。</a>');
				}
				if (status == 2) {
					$("#ajax_loginstatus").html('<a id="temp_st" style="color:red">抱歉，邮箱地址已经存在。</a>');
				}
				if (status == 0) {
					$("#ajax_loginstatus").html('<a id="temp_st" style="color:green">恭喜，注册成功，若页面长时间无相应请刷新页面！</a>');
					$("#ajaxwait_user").load('/!!/Userbox');
					setTimeout(function(){$("#dark").load('/!!/LRbox')},100);
				}
			});
		}
		else {
			$("#ajax_loginstatus").html('<a id="temp_st" style="color:red">' + err1 + err2 + err3 + '</a>');
		}
}
function logout() {
	$.getJSON("/!!/CookieClean",function(a){
		if (a.logout == true) {
			location.reload();
		}
	});
}
$(document).ready(function(){
	$("#index").load('/index_s.html','',function(){
		document.title = t + '::Topics';
		index_topic(1);
		$("#ajaxwait_user").load('/!!/Userbox',"",function (){
			regNavitoggle();
			setTimeout('getUrlact();',1500)
		});
	});
});
function index_topic(page) {
	$("#ajaxwait_view_topic").hide();
	$(".topiclist").slideUp(function(){
		$(".topiclist").load('/!!/GetIndexData/page/'+page,'',function(){
			$.getScript('/!!/GetIndexData_js/page/'+page);
			document.title = t + '::Topics';
			$(".topiclist").slideDown();
		});
	});
}
function index_href(ref) {
	$("#ajaxwait_view_topic").hide();
	show_load();
	$(".topiclist").slideUp(
		function(){$(".topiclist").load(ref,function(){
			$(".topiclist").slideDown();
			hide_load();
		});
	});
}
function index_node() {
	$("#ajaxwait_view_topic").hide();
	$(".topiclist").slideUp(
		function(){$(".topiclist").load("/!!/GetNodeList",'',function(){
			document.title = t + '::Nodes';
			$(".topiclist").slideDown();
		});
	});
}
function regNavitoggle() {
			$("#navi_index").click(function(){index_topic(1);});
			$("#navi_node").click(function(){index_node();});
			$('#l_my_info').mouseenter(function(){$(".user_act").show(100);});
			$('#l_my_info').mouseleave(function(){$(".user_act").hide(100);});
			$('.navi').mouseenter(function(){$(".navi_inner").show(100);});
			$('.navi').mouseleave(function(){$(".navi_inner").hide(100);});
}
function show_load() {
	$("#ajax_loading").slideDown();
}
function hide_load() {
	$("#ajax_loading").slideUp();
}
function view_topic(hash) {
	var topic_add = "/!!/viewpost/" + hash;
	var reply_add = "/!!/getreplies/" + hash;
	var list = $("#ajaxwait_latest_topic");
	var view = $("#ajaxwait_view_topic");
	$("#ajax_loading").slideDown();
	var html = $.post(topic_add,'',function(d){
		view.html(d);
		list.slideUp();
		view.slideDown();
		$(".replybox").load("/!!/getreplies/" + hash ,'',function(){
			rep_to(hash);
		});
		$("#ajax_loading").slideUp();
	},"html");
}
function back(){
	var list = $("#ajaxwait_latest_topic");
	var view = $("#ajaxwait_view_topic");
	list.slideDown();
	view.slideUp();
}
function rep_to(hash) {
	var converter1 = Markdown.getSanitizingConverter();
	var editor1 = new Markdown.Editor(converter1);
	editor1.run();
	$("#reply_to").click(function () {
		var data = '<div class="preview">' + converter1.makeHtml($("#wmd-input")[0].value) + '</div>';
		if (check_reply(data) == true) {
			var json = JSON.stringify({
				"mother":hash,
				"data":data
			});
				 var b64data = BASE64.encode(json);
			$.post('/!!/reply/' + b64data,"",function(x) {
				var st = x.status;
				if(st == 1) {
					$(".replybox").load("/!!/getreplies/" + hash,'',function(){
						rep_to(hash);
					});
				}
					else {
				alert("发表失败，请重试。");
				}
			},"json");
		}
	});
}
function post_to() {
	var converter2 = Markdown.getSanitizingConverter();
	var editor2 = new Markdown.Editor(converter2);
	editor2.run();
	$("#CT_push").click(function () {
		var data = '<div class="preview">' + converter2.makeHtml($("#wmd-input")[0].value) + '</div>';
		var title = $("#CT_title")[0].value;
		var node = $("#CT_node")[0].value;
		if (check_post(title,data) == true) {
			var json = JSON.stringify({
				"title":title,
				"data":data,
				"node":node
			});
			 var b64data = BASE64.encode(json);
			$.post('/!!/post/' + b64data,"",function(x) {
				var st = x.status;
				var ha = x.hasH;
				if(st == 1) {
					view_topic(ha);
				}
				else {
					alert("发表失败，请重试。");
				}
			},"json");
		}
	});
}
function getUrlact() {
	var url =  window.location.href;
	var sharp1 = $.url(url).fsegment(1);
	var sharp2 = $.url(url).fsegment(2);
	if (sharp1 == "post") {
		 if (sharp2 != undefined) {
			 view_topic(sharp2);
		}
	}
	if (sharp1 == "node") {

	}
	if(sharp1 == "user") {

	}
}
