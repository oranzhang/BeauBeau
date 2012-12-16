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
function Login(){
	var user = $("#L_user")[0].value;
	var re =/^[A-Za-z0-9]+$/;
	if(re.test(user)) {
		$("#L_input").removeAttr("disabled");
		$("#L_input")[0].innerHTML='提交';
		$("#L_input").removeClass("red");
		$("#L_input").addClass("blue");
		$("#ajax_loginstatus").html('');
	}else{
		$("#L_input").attr("disabled","disabled");
		$("#L_input").addClass("red");
		$("#L_input").removeClass("blue");
		$("#L_input")[0].innerHTML='请先填写上面的表单';
		$("#ajax_loginstatus").html('<a id="temp_st" style="color:red">' + err1 + err2 + err3 + '</a>');
	}
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
			$("#R_input").removeAttr("disabled");
			$("#R_input")[0].innerHTML='提交';
			$("#R_input").removeClass("red");
			$("#R_input").addClass("blue");
			$("#ajax_loginstatus").html('');
		}
		else {
			$("#R_input").attr("disabled","disabled");
			$("#R_input").addClass("red");
			$("#R_input").removeClass("blue");
			$("#R_input")[0].innerHTML='请先填写上面的表单';
			$("#ajax_loginstatus").html('<a id="temp_st" style="color:red">' + err1 + err2 + err3 + '</a>');
		}
}

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
