//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require jquery-ui/sortable
//= require jquery-ui/effect-highlight
//= require jquery_nested_form
//= require turbolinks
//= require bootstrap
//= require dnd
//= require switch
//= require viewport-checker
//= require bootstrap-select
//= require plans
//= require Chart.min
//= require devices-2
//= require devices
//= require home
//= require shared
//= require select2.full
//= require select2.full.min
//= require select2
//= require select2.min
//= require google_analytics
//= require common
//= require auto-render.min

$(document).on('page:change', function () {
  // $(".filter-bar input[type='checkbox']").on('click',function(){
  //     $(this).closest('form').submit();
  // });
	$(".custom-filter").on('click',function(){
     $(this).closest('form').submit();
  });
});
