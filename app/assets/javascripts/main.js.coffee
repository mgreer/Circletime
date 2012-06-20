$ ->
  $(".madlibs").each ->
    new Global.MadLib( this )
  $('.fancybox').fancybox({
    openSpeed: "fast",
    closeSpeed: "fast",
  })
