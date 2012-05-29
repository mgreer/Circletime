window.App = { }

is_mobile = ->
  return true
  (/iphone|ipod|android|blackberry|mini|windows\sce|palm/i.test(navigator.userAgent.toLowerCase()))
  
slugify = (text) ->
  text = text.replace(/[^-a-zA-Z0-9,&\s]+/g, "")
  text = text.replace(/-/g, "_")
  text.replace(/\s/g, "-")
