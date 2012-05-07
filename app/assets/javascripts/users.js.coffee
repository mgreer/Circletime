# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

sendRequestToRecipients = (user_ids) ->
  FB.ui
    method: "apprequests"
    message: "My Great Request"
    to: user_ids
  , requestCallback
sendRequestViaMultiFriendSelector = ->
  FB.ui
    method: "apprequests"
    message: "My Great Request"
  , requestCallback
requestCallback = (response) ->
FB.init
  appId: FACEBOOK_APP_ID
  frictionlessRequests: true
  
$(document).ready ->
  $(".facepile .facebook_invite").click ->
    $uid = $(this).attr("id")
    sendRequestToRecipients $uid  