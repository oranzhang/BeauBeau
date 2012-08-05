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
function Login(){
    var user = $("#L_user")[0].value;
    var re = /[a-zA-Z0-9]{3,16}/;
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
    else{$("#ajax_loginstatus").html('<a id="temp_st" style="color:red">用户名由3-16个字符组成，且只能是数字或字母。</a>');}
}

$(document).ready(function(){
$(".topiclist").load('/!!/GetIndexData');
$("#ajaxwait_user").load('/!!/Userbox');

});
