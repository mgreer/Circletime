# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
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
    if $job_type.is_misc
      $("#time,#duration",$el).addClass("hide")       
    else if $job_type.hours < 24    
      $("#time,#duration",$el).removeClass("hide")      
    else
      $("#duration",$el).removeClass("hide")       
      $("#time",$el).addClass("hide")       
  #on stars and duration change
    #correct unit plural
    
  #if URL checks one, click it
  if window.location.hash != ""
    $split = window.location.hash.slice(1).split("=")
    $type = $split[0]
    $id = $split[1]
    if $type == "job_type_id"
      setTimeout ->
        $("select#job_job_type_id option[value="+$id+"]").click()
      100
    
    