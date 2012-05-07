# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

sendRequestToRecipients = (user_ids, msg) ->
  FB.ui
    method: "apprequests"
    message: msg
    to: user_ids
  , requestCallback
sendRequestViaMultiFriendSelector = ->
  FB.ui
    method: "apprequests"
    message: "My Great Request"
  , requestCallback
requestCallback = (response) ->
  alert "I requested "+user_ids+" and was told: "+response
  
FB.init
  appId: FACEBOOK_APP_ID
  frictionlessRequests: false
  
$(document).ready ->
  $(".facepile .facebook_invite").click ->
    $uid = $(this).attr("id")
    sendRequestToRecipients $uid "Join me on Circletime so we can trade babysitting, petsitting, and other favors."