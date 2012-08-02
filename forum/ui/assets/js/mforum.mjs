$(document).ready(function(){
$(".topiclist").load('/!!/GetIndexData');
$("#ajaxwait_user").load('/!!/Userbox');

});
function new_ct(node){
    $("#dark").load("/!!/Clean");
    $("#dark").load("/!!/CTbox/" + node);
    var editor = new EpicEditor().load();
    $("#dark").slideToggle();
  }