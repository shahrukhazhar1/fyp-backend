$(document).ready(function(){
  
  if(!$("#device-tutorial-3").hasClass('hidden')){
    $("#show-device-tutorial-4").effect( "pulsate", {times:5}, 8000 );
  }

  if(!$("#device-tutorial-2").hasClass('hidden')){
    $("#show-device-tutorial-3").effect( "pulsate", {times:5}, 8000 );
  }


  if(!$("#device-tutorial-3").hasClass('hidden')){
    $("#show-device-tutorial-2").effect( "pulsate", {times:5}, 8000 );
  }


  if(!$("#device-tutorial-4").hasClass('hidden')){
    $("#device-tutorial-end").effect( "pulsate", {times:5}, 8000 );
  }

  setTimeout(function(){
    console.log('Interval Newwwwwww');
    $.ajax({
      type: "POST",
      url: "/send_report",
      success: function(data) {
      },
      error: function() {
      }
    });
  },86400000);


  $("#tst-uniq").click(function(){
    window.location = "/devices/"+this.getAttribute('device_id')+"/quiz_queue";
  });

  $("#show-device-tutorial-2").click(function(){
    $("#device-tutorial-1").addClass("hidden");
    $("#device-tutorial-2").removeClass("hidden");
    scrollTutorialHint("device-tutorial-2");
  });

  $("#device-modal-close").click(function(){
    $("#deviceModal").remove();
    $('.modal-backdrop').remove();
    $('body').css('overflow-y', 'auto') 

    $.ajax({
      type: 'POST',
      url: '/user_settings/device_status',
      dataType: 'script',
      success: function(data, textStatus, jqXHR)
      {
        if (data=="true") {
          $("#device-connect-error").removeClass("hidden");
          $(".tutorial-popup").remove();
          $("#device-tutorial-1").addClass('hidden');
        }
        else{
          $("#device-connect-error").addClass("hidden");
          $("#device-tutorial-1").removeClass('hidden');
        }
      },
      error: function (jqXHR, textStatus, errorThrown)
      {}
    });
    // $("#device-tutorial-popup").addClass("hidden");
  });

  // $("#close-device-new-tutorial").click(function(){
  $("#close-device-edit-tutorial").click(function(e){
    e.preventDefault();
    $("#device-tutorial-edit").addClass("hidden");
    $("#device-tutorial-edit-2").removeClass("hidden");
  });

  $("#close-device-edit-tutorial-2").click(function(e){
    e.preventDefault();
    $("#device-tutorial-edit-2").addClass("hidden");
    userId = this.getAttribute('user-id');
    deviceId = this.getAttribute('device-id');
    tutorialId = this.getAttribute('tutorial-id');
    $.ajax({
      type: 'POST',
      url: '/user_settings/tutorial_seen',
      dataType: 'script',
      data: {
        user_id: userId,
        tutorial_id: tutorialId,
        next_step: 'step_6'
      }
    });
  });

  $("#dc-close").click(function(){
    $("#device-connect-error").addClass("hidden");
  });

  $("#show-device-tutorial-4").click(function(){
    $("#device-tutorial-2").addClass("hidden");
    $("#device-tutorial-4").removeClass("hidden");
    scrollTutorialHint("device-tutorial-4");
  });

  $("#show-device-tutorial-3").click(function(){
    $("#device-tutorial-2").addClass("hidden");
    $("#device-tutorial-3").removeClass("hidden");
    scrollTutorialHint("device-tutorial-3");
  });


  $("#device-tutorial-end").click(function(){
    $("#device-tutorial-4").addClass("hidden");

    userId = this.getAttribute('user-id');
    tutorialId = this.getAttribute('tutorial-id');
    $.ajax({
      type: 'POST',
      url: '/user_settings/tutorial_seen',
      dataType: 'script',
      data: {
        user_id: userId,
        tutorial_id: tutorialId,
        tutorial_seen: true,
        next_step: 'step_6'
      }
    });

  });

  $("#show-queue-tutorial-2").click(function(){
    $("#queue-tutorial-1").addClass("hidden");
    $("#queue-tutorial-2").removeClass("hidden");
    scrollTutorialHint("queue-tutorial-2");
  });

  $("#show-queue-tutorial-3").click(function(){
    $("#queue-tutorial-2").addClass("hidden");
    $("#queue-tutorial-3").removeClass("hidden");
    $("#show-queue-tutorial-4").removeClass('hidden');
    scrollTutorialHint("show-queue-tutorial-4");
  });

  $("#close-quiz-queue").click(function(){
    $("#queue-tutorial-3").addClass("hidden");
    $("#quiz-queue-next").removeClass('hidden');
    $("#quiz-queue-next").removeClass('hidden');
  });


  $("#show-queue-tutorial-4").click(function(){
    userId = this.getAttribute('user-id');
    tutorialId = this.getAttribute('tutorial-id');
    deviceId = this.getAttribute('device-id');
    $.ajax({
      type: 'POST',
      url: '/user_settings/tutorial_seen',
      dataType: 'script',
      data: {
        user_id: userId,
        tutorial_id: tutorialId,
        next_step: 'step_2'
      }
    });

    window.location = "/plans/devices/"+deviceId+"/subscriptions";

  });

  $("#close-plan-tutorial-1").click(function(){
    $("#plan-tutorial-1").addClass("hidden");

    userId = this.getAttribute('user-id');
    tutorialId = this.getAttribute('tutorial-id');
    $.ajax({
      type: 'POST',
      url: '/user_settings/tutorial_seen',
      dataType: 'script',
      data: {
        user_id: userId,
        tutorial_id: tutorialId,
        next_step: 'step_2'
      }
    });

  });

  $(".plan-tick").click(function(){
    $(".payment-ripple-1").addClass('hidden');
  });

  $("#close-payment-tutorial-1").click(function(){
    $("#plan-tutorial-1").addClass("hidden");
    userId = this.getAttribute('user-id');
    tutorialId = this.getAttribute('tutorial-id');
    deviceId = this.getAttribute('device-id');
    $(".payment-ripple-1").removeClass('hidden');
  });

  $("#close-payment-tutorial-2").click(function(){
    $("#payment-tutorial-1").addClass("hidden");
    userId = this.getAttribute('user-id');
    tutorialId = this.getAttribute('tutorial-id');
    deviceId = this.getAttribute('device-id');
    $(".payment-card-ripple").removeClass('hidden');
    // $.ajax({
    //   type: 'POST',
    //   url: '/user_settings/tutorial_seen',
    //   dataType: 'script',
    //   data: {
    //     user_id: userId,
    //     tutorial_id: tutorialId,
    //     next_step: 'step_1'
    //   }
    // });
    // window.location = "/devices/"+deviceId+"/edit"
  });

  $("#show-shop-tutorial-search").click(function(e){
    e.preventDefault();
    // $("#shop-tutorial-1").removeClass("hidden");
    $("#shop-tutorial-2").removeClass("hidden");
    scrollTutorialHint("shop-tutorial-2");
    $("#shop-search-box").addClass("hidden");
  });

  $("#show-shop-tutorial-2").click(function(e){
    e.preventDefault();
    $("#shop-tutorial-1").addClass("hidden");
    // $("#shop-tutorial-2").removeClass("hidden");
  });

  $("#show-shop-tutorial-3").click(function(e){
    e.preventDefault();
    $("#shop-tutorial-2").addClass("hidden");
    $("#shop-tutorial-3").removeClass("hidden");
    scrollTutorialHint("shop-tutorial-3");
  });

  $("#show-last-shop-tutorial").click(function(e){
    e.preventDefault();
    $("#shop-tutorial-3").addClass("hidden");
    $("#last-shop-tutorial").removeClass("hidden");
    scrollTutorialHint("last-shop-tutorial");
  });

  $("#close-shop-tutorial").click(function(e){
    e.preventDefault();
    $("#last-shop-tutorial").addClass("hidden");
    $("#quiz-shop-ripple").removeClass('hidden');
    userId = this.getAttribute('user-id');
    tutorialId = this.getAttribute('tutorial-id');
    deviceId = this.getAttribute('device-id');

    // $.ajax({
    //   type: 'POST',
    //   url: '/user_settings/tutorial_seen',
    //   dataType: 'script',
    //   data: {
    //     user_id: userId,
    //     tutorial_id: tutorialId,
    //     next_step: 'step_4'
    //   }
    // });

    // window.location = "/devices/"+deviceId+"/quiz_queue";

  });

  $("#close-shop-tutorial-1").click(function(e){
    e.preventDefault();

    $("#last-shop-tutorial-1").addClass("hidden");
    userId = this.getAttribute('user-id');
    tutorialId = this.getAttribute('tutorial-id');
    deviceId = this.getAttribute('device-id');

  });

  $("#quiz-q1").click(function(e){
    e.preventDefault();
    $("#last-shop-tutorial").remove();
    $("#last-shop-tutorial-1").addClass("hidden");
    userId = this.getAttribute('data-user-id');
    tutorialId = this.getAttribute('data-tutorial-id');
    deviceId = this.getAttribute('data-device-id');
    $.ajax({
      type: 'POST',
      url: '/user_settings/verify_quiz_queue',
      dataType: 'script',
      data: {
        device_id: deviceId
      },
      success: function(data, textStatus, jqXHR)
      {
        if (data == "true") {
          $("#last-shop-tutorial-1").addClass("hidden");
          $.ajax({
            type: 'POST',
            url: '/user_settings/tutorial_seen',
            dataType: 'script',
            data: {
              user_id: userId,
              tutorial_id: tutorialId,
              next_step: 'step_4'
            }
          }); 
          window.location = "/devices/"+deviceId+"/quiz_queue";
        }
        else{
          $("#last-shop-tutorial-1").removeClass("hidden");
        }
      },
      error: function (jqXHR, textStatus, errorThrown)
      {}
    });

  });

  function scrollTutorialHint(divId) {
    $('html, body').animate({
      scrollTop: Math.max($("#"+divId).offset().top - 200, 0)
    }, 1000);
  }
});
