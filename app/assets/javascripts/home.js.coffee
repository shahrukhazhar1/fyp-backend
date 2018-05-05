# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready page:load', ->

  $('.device-switch-send-mail').on 'change', ->
    value = $(this).parent().hasClass('switch-on')
    enabler_parent = $("#edit_device_#{$(this).prop('id')}");
    enabler = enabler_parent.children('#device_send_mail');
    $(enabler).val(value)
    $("#edit_device_#{$(this).prop('id')}").submit()

  $('.device-switch-is-enabled').on 'change', ->
    value = $(this).parent().hasClass('switch-on')
    enabler_parent = $("#edit_device_#{$(this).prop('id')}");
    enabler = enabler_parent.children('#device_is_enabled');
    $(enabler).val(value)
    $("#edit_device_#{$(this).prop('id')}").submit()

  $('.app-switch-is-enabled').on 'change', ->
    value = $(this).parent().hasClass('switch-on')
    appId = $(this).prop('id');
    $("#block-status-#{$(this).prop('id')}").val(value)
    # debugger
    $("#app-toggle-form-#{$(this).prop('id')}").submit()
  