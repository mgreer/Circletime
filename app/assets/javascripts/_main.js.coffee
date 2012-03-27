$.fn.madlib = (options) ->
  @each ->
    $this = $(this)
    madlib = $this
    $this.val $this.find("option:first").val()
    $this.wrap "<div class=\"madlib_select\"></div>"
    $el = $(this).parents(".madlib_select")
    @modifying = false
    $el.append "<ul class=\"display\"></ul>"
    $ul = $("ul", $el)
    $("option", $this).each ->
      $option = $(this)
      $ul.append "<li data-value=\"" + $option.val() + "\"><a href=\"#\">" + $option.html() + "</a></li>"
    $("a", $ul).click $.fn.madlib.clickHandler
    $(this).hide()
    $ul.find("li:first").addClass "current"
    $el.width $("li.current *", $ul).width()
    $.fn.madlib.adjustWidth this

$.fn.madlib.adjustWidth = (rotator) ->
  $select = $(rotator)
  $el = $select.parents(".madlib_select")
  $ul = $("ul", $el)
  _.delay ((args) ->
    ul = args.ul
    el = args.el
    width = $("li.current *", ul).width()
    el.width width
  ), 400,
    ul: $ul
    el: $el

$.fn.madlib.clickHandler = (e) ->
  e.preventDefault()
  $link = $(e.currentTarget)
  $madlib = $link.parents(".madlib_select")
  $list = $link.parents("ul.display")
  $item = $link.parents("li")
  if not $item.hasClass("current")
    $("li.current *", $list).removeClass("current")
    $item.addClass("current")
    $madlib.height $item.height()
    $madlib.css "top", $item.offset().top*-1+ $item.offsetParent().offset().top
  $madlib.width = $("li.current *", $list).width()
  false

$ ->
  ###
  Form elements setup
  ###
  $('input.ui-date-picker').datepicker()
  $('input.ui-datetime-picker').datetimepicker()
  $createRotator = $(".madlibs .select").madlib(modifiable: true)[0]
  
