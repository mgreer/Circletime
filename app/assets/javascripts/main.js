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
  $test = $("body").append("<div class='tester' id='tester'>&nbsp;</div>");
  $test = $("#tester");
  $test.css({
      "font-size": $(object).css("font-size"),
      "font-family": $(object).css("font-family"),
      "font-weight": $(object).css("font-weight"),
      "letter-spacing": $(object).css("letter-spacing")
    });
  $test.html(content+"W");
  $height = $test.height();
  $width = $test.width();
  $test.remove();
  return {"height":$height, "width":$width};
}

//TODO: CONSOLIDATE THIS SHIT!!!
$.fn.resizeable = function(options) {
  this.resize = function(){
    if( $(this).val() == "" ){return;}
    $dim = test_size( $(this).val(), $(this) );
    $(this).width($dim.width);    
  }
  $(this).keydown(this.resize);
  $(this).change(this.resize);
  this.resize();
  return this;
}

$.fn.madlib = function(options) {
  $uls = [];
  if( !$is_mobile ){
    /*wire up selects first*/
    $(this).find("select:parent").each(function() {
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
          $(this).addClass("current");
          $real_width = $("li.current a", $ul).width();
          $ul.parent().animate(
            {width: $real_width}
          ,200,'linear');
          $option.trigger("change");
        }
        $ul.css("top" ,($("li.current", $ul).position().top*-1) );      
        $ul.toggleClass("lit");
      });    
      /*kill open ones on doc click*/
      $(document).click(function() {
        return $("ul.lit li.option",this).filter(".current").click();
      });
      //resize them all when we load later
      $uls.push( $ul );
    });
  }else{
    //TODO: CONSOLIDATE THIS SHIT!!!
    //resize the selects on load
    $(this).find("select").each(function(){
      this.resize = function(){
        $content = $("option:selected",$(this)).text();
        if( $content == "" ){return;}
        $dim = test_size( $content, $(this) );
        $(this).width( $dim.width+10 );
      }
      $(this).change(this.resize);
      this.resize();
    });
    //TODO: resize selects on change
    //$(this).find("select").resizeable();
  }

  /*wire up text inputs next*/
  $(this).find("input").resizeable(); 
  
  /*and then textareas*/
  $(this).find("textarea").keyup(function(e) {
    while($(this).outerHeight() < this.scrollHeight + parseFloat($(this).css("borderTopWidth")) + parseFloat($(this).css("borderBottomWidth"))) {
      $(this).height($(this).height()+30);
    };
  }).triggerHandler("keyup");  
  
  //show it
  $(this).fadeTo( 200, 1, "linear", function(){
    $uls.forEach( function(ul){
      window.setTimeout(function(){
        ul.parent().width( $("li.current a", ul).width() );          
      },0)
    })
  });
  return this; 
};


$(function() {
  /*
  Form elements setup
  */  
  $(".madlibs").madlib();
  if( !$is_mobile ){  
    $('input.ui-date-picker').datepicker({ dateFormat: 'M d, yy', minDate: new Date() });
  }else{
    //TODO: wire up Android picker    
  }

});


})(jQuery);