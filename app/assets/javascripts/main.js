(function($) {

function slugify(text) {
	text = text.replace(/[^-a-zA-Z0-9,&\s]+/ig, '');
	text = text.replace(/-/gi, "_");
	text = text.replace(/\s/gi, "-");
	return text;
}

function test_size(content, object){
  $test = $("body").append("<div class='tester' id='tester'></div>");
  $test = $("#tester");
  $test.css("font-size", $(object).css("font-size"));
  $test.css("font-family", $(object).css("font-family"));
  $test.html(content);
  $height = $test.height();
  $width = $test.width();
  $test.remove();
  return {"height":$height, "width":$width};
}

$.fn.resizeable = function(options) {
  $(this).keydown(function(){
    $dim = test_size( $(this).val(), $(this) );
    $(this).width($dim.width+40);;
  })
  return this;
}

$.fn.madlib = function(options) {
  /*wire up selects first*/
  $(this).find("select:parent").each(function() {
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
//    $(window).scroll(function($ev){
//      console.log($this.scrollTop());
//    });
    $("li.option",$ul).click(function($ev) {
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
    /*kill open ones on doc click*/
    $(document).click(function() {
      return $("ul.lit li.option",this).filter(".current").click();
    });    
  });

  /*wire up text inputs first*/
  $(this).find("input").not(".ui-date-picker").each(function() {
    $(this).resizeable();    
    $input= $(this);
    $input.val("");
    $hint = $(this).parent().find(".hint")
    $dim = test_size( $hint.text(), $hint );
    $(this).width($dim.width+40);    
    $(this).focus(function(){
      $hint.hide(100);
    })
    $hint.click(function(){
      $(this).hide(100);
      $input.focus();
    });
  }); 
  return this; 
};


$(function() {
  /*
    Form elements setup
    */  
//  $('input.ui-date-picker').datepicker().resizeable();

  $(".madlibs").madlib();
});


})(jQuery);