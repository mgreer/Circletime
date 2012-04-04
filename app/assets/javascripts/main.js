(function($) {

function slugify(text) {
	text = text.replace(/[^-a-zA-Z0-9,&\s]+/ig, '');
	text = text.replace(/-/gi, "_");
	text = text.replace(/\s/gi, "-");
	return text;
}

$.fn.madlib = function(options) {
  return this.each(function() {
    var $el, $this, $ul, madlib;
    $this = $(this);
    madlib = $this;
    $name = slugify( $this.attr("name") );
    $this.val($this.find("option:selected").val());
    $this.wrap("<div class=\"custom_select\ "+$name+"\"></div>");
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
    return $("li.option",$ul).click(function($ev) {
      $ev.stopPropagation() 
      $(this).siblings().toggle().removeClass("current");
      var $el = $(this).parents(".custom_select");
      var $ul = $("ul", $el);
      if( $ul.hasClass("lit")){
        $el.find("select option:selected").removeAttr("selected");
        $el.find("select option[value="+$(this).attr("data-value")+"]").attr("selected","selected");
        $el.find("select option[value="+$(this).attr("data-value")+"]").change();
        $(this).addClass("current");
        $ul.parent().animate({
          width: $("li.current a", $ul).width()
        },200);
      }
      $ul.css("top" ,($("li.current", $ul).position().top*-1) );      
      $ul.toggleClass("lit");
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
    return $(".madlibs ul.lit li.option").filter(".current").click();
  });
});


})(jQuery);