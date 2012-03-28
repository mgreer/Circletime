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
      return $ul.append("<li class=\"option\" data-value=\"" + $option.val() + "\"><a href=\"#\">" + $option.html() + "</a></li>");
    });
    $("li a", $ul).click(function(e){false});
    $(this).hide();
    $selected_value = $this.find("option:selected").val();
    $ul.find("li[data-value=\""+$selected_value+"\"]").addClass("current");
    $el.width($("li.current *", $ul).width());
    return $("ul li.option",$el).click(function($ev) {
      $ev.stopPropagation() 
      $(this).siblings().toggle().removeClass("current");
      var $el = $(this).parents(".custom_select")
      $el.find("select option:selected").removeAttr("selected");
      $el.find("select option[value="+$(this).attr("data-value")+"]").attr("selected","selected");
      $(this).addClass("current");
      $el.width($("li.current", $el).width());
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