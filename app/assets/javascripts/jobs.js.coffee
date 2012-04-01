# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $(".madlibs").fadeTo( 1000, 1, "linear" )
  
  #on job_type select change
  $(".madlibs select#job_job_type_id").change ->
    alert 2
    #replace unit with correct one
    #correct unit plural
    #remove time if work_unit hours > 12
    
  #on stars and duration change
    #correct unit plural