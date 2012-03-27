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
    $("a", $ul).click($.fn.madlib.clickHandler);
    $(this).hide();
    $ul.find("li:first").addClass("current");
    $el.width($("li.current *", $ul).width());
    return $(".custom_select ul li.option").click(function() {
      $(this).siblings().toggle().removeClass("current");
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
  $(".madlibs > div.select").madlib()[0];
  return $(document).click(function() {
    return $(".select ul li.option").siblings().not(".darr").css("display", "none");
  });
});


})(jQuery);