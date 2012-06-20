$ ->
  $(".madlibs").each ->
    new Global.MadLib( this )
  $('.fancybox').fancybox({
    openSpeed: "fast",
    closeSpeed: "fast",
    openMethod: "zoomIn",
    closeMethod: "zoomOut"
  })
