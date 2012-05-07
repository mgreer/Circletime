# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

sendInvite = (user_id, msg) ->
  FB.ui
    method: "send"
    name: "Circletime"
    link: "https://apps.facebook.com/circletime-sandbox"
    to: user_id
    description: msg
  , (response) ->
    if response is undefined
      return
    $(".facepile .facebook_invite#"+user_id).text "invited"
    alert "testing :"+response

FB.init
  appId: FACEBOOK_APP_ID
  xfbml: true
  cookie: true
  
$(document).ready ->
  $(".facepile .facebook_invite").click ->
    $uid = $(this).attr("id")
    sendInvite $uid, "Join me on Circletime so we can trade babysitting, petsitting, and other favors."