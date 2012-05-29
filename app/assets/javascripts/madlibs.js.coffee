
class App.MadLib  
  constructor: (@form) ->
    console.log @form
    $(@form).find("input").each ->
      new MadLibTextInput( this )
    $(@form).find("select").each ->
      new MadLibSelectInput( this )
    $(@form).find("textarea").each ->
      new MadLibTextareaInput( this )    
    $(@form).fadeTo 200, 1, "linear"    
      
  class MadLibInput
    constructor: (@input) ->
      $( @input ).change =>
        @resize
      @resize
    test_size: (content, object) ->
      $test = $("body").append("<div class='tester' id='tester'>&nbsp;</div>")
      $test = $("#tester")
      $test.css
        "font-size": $(object).css("font-size")
        "font-family": $(object).css("font-family")
        "font-weight": $(object).css("font-weight")
        "letter-spacing": $(object).css("letter-spacing")
      $test.html content + "W"
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
      super
      $( @input ).keydown =>
        @resize()

  class MadLibTextareaInput extends MadLibInput
    constructor: (@input) ->
      super
      $( @input ).keyup ->
        $(this).height $(this).height() + 30  while $(this).outerHeight() < @scrollHeight + parseFloat($(this).css("borderTopWidth")) + parseFloat($(this).css("borderBottomWidth"))

  class MadLibSelectInput extends MadLibInput
    constructor: (@input) ->
      $input = $(@input)
      $input.wrap "<div class=\"custom_select\"></div>"
      $input.val $input.find("option:selected").val()
      $el = $input.parents(".custom_select")
      @modifying = false
      $el.append "<ul class=\"display\"></ul>"
      $ul = $("ul", $el)
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
      
    class MadLibOption
      constructor: (@input) ->
        @el = $(@input).parents(".custom_select")
        @ul = $("ul", @el)
        $(@input).click ($ev) =>
          @select( $ev )
      
      select: ( $ev ) =>
        $ev.stopPropagation()
        $(@input).siblings().toggle().removeClass "current"
        if @ul.hasClass("lit")
          @el.find("select option:selected").removeAttr "selected"
          $option = @el.find("select option[value=" + $(@input).attr("data-value") + "]")
          $option.attr "selected", "selected"
          $(@input).addClass "current"
          @resize()
          $option.trigger "change"
          $(document).unbind "keydown"
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
        $moveAmount = $("li",@ul).height()
        if !$isUp
          $moveAmount = $moveAmount * -1
        $newTop = parseInt(@ul.css("top")) + $moveAmount
        @ul.animate
          top: $newTop
        , 200, "linear"
       
      resize: =>
        $real_width = $("li.current a", @ul).width()
        @ul.parent().animate
          width: $real_width
        , 200, "linear"                               

    resize: =>
      $content = $("option:selected", $(@input)).text()
      return  if $content is ""
      $dim = @test_size($content, $(@input))
      $(@input).width $dim.width + 10
