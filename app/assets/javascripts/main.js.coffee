$ ->
  $(".madlibs").each ->
    new Global.MadLib( this )
  if !Global.is_mobile
    $("input.ui-date-picker").datepicker
      dateFormat: "M d, yy"
      minDate: new Date()
