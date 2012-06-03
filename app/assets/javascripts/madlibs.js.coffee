
class Global.MadLib  
  constructor: (@form) ->
    $inputs = []
    $(@form).find("input").each ->
      $inputs.push new MadLibTextInput( this )
    $(@form).find("select").each ->
      $inputs.push new MadLibSelectInput( this )
    $(@form).find("textarea").each ->
      $inputs.push new MadLibTextareaInput( this )    
    $(@form).fadeTo 200, 1, ->
      for $input in $inputs
        $input.resize()
        if $input instanceof MadLibSelectInput
          $("li.current a", $input.ul).each =>
            $real_width = $("li.current a", $input.el).width()
            $input.el.width($real_width)          
    if !Global.is_tablet && !Global.is_mobile 
      $(@form).find("input.datepicker").datepicker
        dateFormat: "M d, yy"
        minDate: new Date()
      
  class MadLibInput
    constructor: (@input) ->
      $( @input ).change =>
        @resize
      @resize
      this
    test_size: (content, object) ->
      $test = $("body").append("<div class='tester' id='tester'>&nbsp;</div>")
      $test = $("#tester")
      $test.css
        "font-size": $(object).css("font-size")
        "font-family": $(object).css("font-family")
        "font-weight": $(object).css("font-weight")
        "letter-spacing": $(object).css("letter-spacing")
      $test.html content
      $height = $test.height()
      $width = $test.width()
      $test.remove()
      height: $height
      width: $width 
    resize: =>
      return if $(@input).val() is ""
      $dim = @test_size( $(@input).val(), $(@input) )
      $(@input).width $dim.width

  class MadLibTextInput extends MadLibInput
    constructor: (@input) ->
      $( @input ).keydown =>
        @resize()
      super

  class MadLibTextareaInput extends MadLibInput
    constructor: (@input) ->
      $( @input ).keyup ->
        $(this).height $(this).height() + 30  while $(this).outerHeight() < @scrollHeight + parseFloat($(this).css("borderTopWidth")) + parseFloat($(this).css("borderBottomWidth"))
      super

  class MadLibSelectInput extends MadLibInput
    constructor: (@input) ->
      if Global.is_mobile
        return
      $input = $(@input)
      $input.wrap "<div class=\"custom_select\"></div>"
      $input.val $input.find("option:selected").val()
      $el = $input.parents(".custom_select")
      @modifying = false
      $el.append "<ul class=\"display\"></ul>"
      $ul = $("ul", $el)
      @el = $el
      $("option", $input).each ->
        $option = $(this)
        $ul.append "<li class=\"option\" data-value=\"" + $option.val() + "\"><a href=\"#\">" + $option.html() + "</a></li>"
      $input.hide()
      $selected_value = $input.find("option:selected").val()
      $ul.find("li[data-value=\"" + $selected_value + "\"]").addClass "current"
      $el.width $("li.current *", $ul).width()
      $input.change =>
        @resize()  
      $("li.option", $ul).each ->
        new MadLibOption( this )
      $(document).click ->
        $("ul.lit li.option", this).filter(".current").click()
      #allow it to scroll up and down to show a long list
      if !Global.is_tablet && !Global.is_mobile 
        $("li",$ul).mouseover ->
          $window = $(window).height()
          $top = $(this).offset()["top"]
          if $top < 0
            this.madlib.turn()
          else if $top+$(this).height() > $(window).height() 
            this.madlib.turn(false)
      else
        $ul.addClass "touchable" 
        $ul.draggable( { axis: "y", grid: [50, $("li",$ul).first().height()] } )
          
      super
 
    resize: =>
      $content = $("option:selected", $(@input)).text()
      return  if $content is ""
      $dim = @test_size($content, $(@input))
      $(@input).width $dim.width + 10
           
    class MadLibOption
      constructor: (@listItem) ->
        @el = $(@listItem).parents(".custom_select")
        @ul = $("ul", @el)
        @option = @el.find("select option[value=" + $(@listItem).attr("data-value") + "]")
        @listItem.madlib = this
        $(@listItem).click ($ev) =>
          @select( $ev )
      
      select: ( $ev ) =>
        $ev.stopPropagation()
        $(@listItem).siblings().toggle().removeClass "current"
        #if choosing an option
        if @ul.hasClass("lit")
          @el.find("select option:selected").removeAttr "selected"
          @option.attr "selected", "selected"
          $(@listItem).addClass "current"
          @resize()
          @option.trigger "change"
          $(document).unbind "keydown"
          
        #if opening the option list
        else
          #capture keys
          $(document).keydown (event) =>
            #bind up
            if event.which == 38
              event.stopPropagation
              @turn()
              false
            #bind down
            else if event.which == 40
              event.stopPropagation
              @turn(false)
              false
            #bind enter
            else if event.which == 13
              @el.find("li a:hover").click()
          
        @ul.css "top", ($("li.current", @ul).position().top * -1)
        @ul.toggleClass "lit"

      turn: ($isUp = true) =>
        $moveAmount = $("li",@ul).height()+2
        if !$isUp
          $moveAmount = $moveAmount * -1
        @ul.css "top", parseInt(@ul.css("top")) + $moveAmount
       
      resize: =>
        @ul.parent().width $("li.current a", @ul).width()              

