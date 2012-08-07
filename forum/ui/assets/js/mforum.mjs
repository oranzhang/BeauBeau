function new_ct(node){
    $("#dark").load("/!!/CTbox/" + node);
    setTimeout('var editor = new EpicEditor().load();',1000)
    $("#dark").slideToggle();
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
if (re.test(user)){
    var pass = SHA1($("#L_pass")[0].value);
    $.getJSON('/!!/Login/' + user + '&' + pass,function(d){
    var status = d.msg;
    if(status == 1) {
    $("#ajax_loginstatus").html('<a id="temp_st" style="color:green">登入成功，若无反应请刷新。</a>');
    $("#ajaxwait_user").load('/!!/Userbox');
    setTimeout('$("#dark").slideToggle()',3000);
    }
    else
    {
    $("#ajax_loginstatus").html('<a id="temp_st" style="color:red">用户名或密码错误。</a>');
    }
    });
    }
    else{$("#ajax_loginstatus").html('<a id="temp_st" style="color:red">用户名只能由字母和数字组成</a>');}
}
function CreatUser(){
    var email_p = /^([a-z0-9A-Z]+[-|\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\.)+[a-zA-Z]{2,}$/;
    var user_p =/^[A-Za-z0-9]+$/;
    var count = 0;
    var user = $("#R_user")[0].value;
    var pass = $("#R_pass")[0].value;
    var repass = $("#R_repass")[0].value;
    var mail = $("#R_mail")[0].value;
    if  (user_p.test(user)) {
      count++;
    }
    else {
      var err1 = "用户名只能由字母和数字组成。";
    }
    if (pass == repass) {
      count++;
      var p_sha1 = SHA1(pass)
    }
    else {
       var err2 = "两次密码输入不一致。";
    }
    if (email_p.test(mail)) {
      count++;
    }
    else {
      var err3 = "邮箱不符合格式。";
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
          setTimeout('location.reload()',1500);
        }
      });
    }


}
$(document).ready(function(){
$(".topiclist").load('/!!/GetIndexData');
$("#ajaxwait_user").load('/!!/Userbox');

});
