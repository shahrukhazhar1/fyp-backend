$(document).ready ->
  $('#owner_id').on 'change', ->
    Turbolinks.visit "/plans/devices/#{$('#owner_id').val()}/subscriptions"

@show_plan = (plan_id) ->
  $('.plan-button').hide(0)
  $('.plan-check').prop('checked', false);
  $('.plan-button-' + plan_id).show(0)
  $('.plan-check-' + plan_id).prop('checked', true);
