(function($) {

$is_mobile = (/iphone|ipad|ipod|android|blackberry|mini|windows\sce|palm/i.test(navigator.userAgent.toLowerCase()))
//$is_mobile = true;

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
  this.resize = function(){
    $dim = test_size( $(this).val(), $(this) );
    $(this).width($dim.width+40);    
  }
  $(this).keydown(this.resize);
  $(this).change(this.resize);
  this.resize();
  return this;
}

$.fn.madlib = function(options) {
  if( !$is_mobile ){
    /*wire up selects first*/
    $(this).find("select:parent").each(function() {
      if(this.is_madlibbed) return this;
      this.is_madlibbed = true;
      var $el, $this, $ul, madlib;
      $this = $(this);
      $madlib = $this;
      $name = slugify( $this.attr("name") );
      $this.val($this.find("option:selected").val());
      $this.wrap("<div class=\"custom_select\ "+$name+"\"></div>");
      $el = $(this).parents(".custom_select");
 
      this.modifying = false;
      $el.append("<ul class=\"display\"></ul>");
      $ul = $("ul", $el);
      $("option", $this).each(function() {
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
        var $el = $(this).parents(".custom_select");
        var $ul = $("ul", $el);
        $(this).siblings().toggle().removeClass("current");
        if( $ul.hasClass("lit")){
          $el.find("select option:selected").removeAttr("selected");
          $option = $el.find("select option[value="+$(this).attr("data-value")+"]");
          $option.attr("selected","selected");
          $option.change();
          $(this).addClass("current");
          $ul.parent().animate(
            {width: $("li.current a", $ul).width()}
          ,200);
        }
        $ul.css("top" ,($("li.current", $ul).position().top*-1) );      
        $ul.toggleClass("lit");
      });
      /*kill open ones on doc click*/
      $(document).click(function() {
        return $("ul.lit li.option",this).filter(".current").click();
      });    
    });
  }

  /*wire up text inputs first*/
//  $(this).find("input").resizeable(); 
  return this; 
};


$(function() {
  /*
    Form elements setup
    */  

  $(".madlibs").madlib();
  if( !$is_mobile ){  
    $('input.ui-date-picker').datepicker({ dateFormat: 'M d, yy', minDate: new Date() });
  }
});


})(jQuery);