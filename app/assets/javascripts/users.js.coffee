# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
if $("#fb-root").get(0)
  sendInvite = (user_id, user_name, msg) ->
    $.post "/facebook_friends/invite",
      name: user_name
    , (data) ->
      FB.ui
        method: "send"
        name: "Circletime"
        link: "http://circletime.herokuapp.com/users/invitation/accept?invitation_token="+data.invitation_token
        to: user_id
        description: msg
      , (response) ->
        if response is undefined
          return
        $(".facepile .facebook_invite#"+user_id).text "invited"

  FB.init
    appId: FACEBOOK_APP_ID
    xfbml: true
    cookie: true
  
  $(document).ready ->
    $(".facepile .facebook_invite").click ->
      $uid = $(this).attr("id")
      $name = $(this).attr("name")
      sendInvite $uid, $name, "Join me on Circletime so we can trade babysitting, petsitting, and other favors."
      
$(document).ready ->
  $("#invite_users .user_email").bind "keydown", (event) ->
    $input = $(this)
    if event.which == 188 || event.which == 32
      event.stopPropagation
      $clone = $input.clone( true )
      $input.after( $clone )
      $clone.before("<span>,</span>")
      $clone.select().val("")
      false
    else if event.which == 8 && $input.val() == ""
      event.stopPropagation
      if $("#invite_users .user_email").size() > 1
        $prev = $input.prev("input").focus()
        $prev.focus()
        $input.prev().remove()
        $input.remove()
      false

  #if $("#devise-registrations-new")?
  #  $("#user_time_zone").set_timezone()
