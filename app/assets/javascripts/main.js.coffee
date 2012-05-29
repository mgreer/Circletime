$ ->
  $(".madlibs").each ->
    new App.MadLib( this )
  unless is_mobile()
    $("input.ui-date-picker").datepicker
      dateFormat: "M d, yy"
      minDate: new Date()
  else
