(function($) {

$.fn.madlib = function(options) {
  return this.each(function() {
    var $el, $this, $ul, madlib;
    $this = $(this);
    madlib = $this;
    $this.val($this.find("option:first").val());
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
    $ul.find("li:first").addClass("current");
    $el.width($("li.current *", $ul).width());
    return $(".custom_select ul li.option").click(function($event) {
      $(this).siblings().toggle().removeClass("current");
      $(this).parents(".custom_select").find("select option:selected").removeAttr("selected");
      $(this).parents(".custom_select").find("select option[value="+$(this).attr("data-value")+"]").attr("selected","selected");
      $event.stopPropagation() 
      return $(this).addClass("current");
    });
  });
};
$(function() {
  /*
    Form elements setup
    */  
  $('input.ui-date-picker').datepicker();
  $('input.ui-datetime-picker').datetimepicker();
  $(".madlibs > div.select").madlib();
  return $(document).click(function() {
    return $(".custom_select ul li.option").siblings().not(".current").css("display", "none");
  });
});


})(jQuery);