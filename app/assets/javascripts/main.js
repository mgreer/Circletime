(function($) {

$.fn.madlib = function(options) {
  return this.each(function() {
    var $el, $this, $ul, madlib;
    $this = $(this);
    madlib = $this;
    $this.val($this.find("option:selected").val());
    $this.wrap("<div class=\"custom_select\"></div>");
    $el = $(this).parents(".custom_select");
    this.modifying = false;
    $el.append("<ul class=\"display\"></ul>");
    $ul = $("ul", $el);
    $("option", $this).each(function() {
      var $option;
      $option = $(this);
      return $ul.append("<li class=\"option\" data-value=\"" + $option.val() + "\"><span>" + $option.html() + "</span></li>");
    });
    $("li a", $ul).click(function(e){false});
    $(this).hide();
    $selected_value = $this.find("option:selected").val();
    $ul.find("li[data-value=\""+$selected_value+"\"]").addClass("current");
    $el.width($("li.current *", $ul).width());
    return $("li.option",$ul).click(function($ev) {
      $ev.stopPropagation() 
      var $ul = $(this).parent();
      $ul.toggleClass("lit");      
//      $(this).siblings().toggle().removeClass("current");
      $(this).siblings().removeClass("current");
      $ul.find("select option:selected").removeAttr("selected");
      $ul.find("select option[value="+$(this).attr("data-value")+"]").attr("selected","selected");
      $(this).addClass("current");
      $ul.width($("li.current", $ul).width());
      $ul.parent().width($ul.width());
      $ul.css("top" ,($("li.current", $ul).position().top*-1)+10 );      
    });
  });
};
$(function() {
  /*
  Form elements setup
  */  
  $('input.ui-date-picker').datepicker();
  $('input.ui-datetime-picker').datetimepicker();
  $(".madlibs select:parent").madlib();
  return $(document).click(function() {
    return $(".custom_select ul li.option").siblings().not(".current").css("display", "none");
  });
});


})(jQuery);