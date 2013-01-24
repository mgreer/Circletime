$ ->
  $(".madlibs").each ->
    new Global.MadLib( this )
  $("#messaging").delay("3000").fadeOut()