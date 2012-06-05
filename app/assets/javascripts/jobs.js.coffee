# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $el = $("#jobs-new .madlibs")
  fixUnits = ($job_type=false) ->
    $duration = $("#job_duration option:selected",$el).val()
    $suffix = ""
    if !$job_type
      $job_type = new Object()
      $base = $("#units",$el).text()
      $s_place = $base.indexOf("s,")
      if $s_place == -1
        $s_place = $base.indexOf(",")
      $job_type.unit = $base.substring(0,$s_place)
    if $duration > 1
      $suffix = "s"
    $("#units",$el).text( $job_type.unit+""+$suffix+"," )

  #on job_type select change
  $el.find("select#job_job_type_id").change ->
    $id = $(this).val()
    $job_type = $job_types[$id]

    fixUnits($job_type)
    
    #remove time if work_unit hours > 12
    if $job_type.is_misc
      $("#time,#duration",$el).addClass("hide")       
    else if $job_type.hours < 24    
      $("#time,#duration",$el).removeClass("hide")      
    else
      $("#duration",$el).removeClass("hide")       
      $("#time",$el).addClass("hide")     
    true  

  #on stars and duration change
    #correct unit plural
  $el.find("select#job_duration").change ->
    fixUnits()
    true
    
    