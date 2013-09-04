# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  _.each _.range(1, $('.download-url').length+1), (i) =>
    $("#jquery_jplayer_#{i}").jPlayer
      ready: ->
        $(this).jPlayer "setMedia",
          mp3: $("#download-url-#{i}").attr("href")
      swfPath: "/js"
      supplied: "mp3"
