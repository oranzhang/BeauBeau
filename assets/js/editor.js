
    $(document).ready(function(){

   var converter1 = Markdown.getSanitizingConverter();
   var editor1 = new Markdown.Editor(converter1);
   editor1.run();
 $('input#tags1').tagEditor({ url: '/TagEditor/Tags', param: 'start', method: 'post', suggestChars: 1, suggestDelay: 300, cache: true, ignoreCase: true, tagMaxLength: 20 });});