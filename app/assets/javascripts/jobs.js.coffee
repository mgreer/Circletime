# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $(".madlibs").fadeTo( 1000, 1, "linear" )
  
  #on job_type select change
  $(".madlibs select#job_job_type_id").change ->
    $el = $(this).parents(".madlibs")
    $id = $(this).val()
    $job_type = $job_types[$id]

    #replace unit with correct one
    #correct unit plural
    $duration = $("#job_duration option:selected",$el).val()
    $suffix = ""
    if $duration > 1
      $suffix = "s"
    $("#units",$el).text( $job_type.unit+""+$suffix+"," )
      
    #remove time if work_unit hours > 12
    if $job_type.hours < 24
      $("#time",$el).show(500)
      $ul = $("#time .custom_select ul", $el)
      $ul.parent().width( $("li.current a", $ul).width() )
    else
      $("#time",$el).hide(500)  
    
  #on stars and duration change
    #correct unit plural