var hideQuizActivity = function() {
  var tooltipCount = 2;

  for (var i = 0; i < tooltipCount; i++) {
    $("#tooltip-" + i).hide();
  }
}

var chartQuizActivity = function() {
    var addTooltipLine = function(e, content) {
      e.append($('<div>').addClass('tt-line').text(content))
    }

    var addQuizLines = function(e, counts) {
      var pCnt = counts['pass'];
      switch (pCnt) {
        case 0:
          break;
        case 1:
          var content = 'Passed ' + pCnt + ' Quiz';
          e.append($('<div>').addClass('tt-quiz-line tt-pass').text(content))
          break
        default:
          var content = 'Passed ' + pCnt + ' Quizzes';
          e.append($('<div>').addClass('tt-quiz-line tt-pass').text(content))
      }

      pCnt = counts['fail'];
      switch (pCnt) {
        case 0:
          break;
        case 1:
          var content = 'Failed ' + pCnt + ' Quiz';
          e.append($('<div>').addClass('tt-quiz-line tt-fail').text(content))
          break
        default:
          var content = 'Failed ' + pCnt + ' Quizzes';
          e.append($('<div>').addClass('tt-quiz-line tt-fail').text(content))
      }
    }

    var quizPassCount = {}

    var quizFailureCount = {}

    entities = $('#quiz-activity-chart').data('chart-stats');
    labels = $.map(entities, function(e) {
      return e.label;
    });

    correct_data = $.map(entities, function(e) {
      return e.datum[0];
    });

    incorrect_data = $.map(entities, function(e) {
      return e.datum[1];
    });

    $.each(entities, function(_,e) {
      var l = e.label;
      quizPassCount[l] = e.datum[2];
      quizFailureCount[l] = e.datum[3];
    });


    var quizCountsForDate = function (date) {
      var cnt1 = quizPassCount[date];
      var cnt2 = quizFailureCount[date];

      if (isNaN(cnt1)) {
        cnt1 = 0;
      }

      if (isNaN(cnt2)) {
        cnt2 = 0;
      }

      return {pass: cnt1, fail: cnt2};
    }

    var customTooltips = function (tooltip) {
      $(this._chart.canvas).css("cursor", "pointer");

      var positionY = this._chart.canvas.offsetTop;
      var positionX = this._chart.canvas.offsetLeft;

      if (!tooltip || !tooltip.opacity) {
        return;
      }

      var $datasets = this._data.datasets;

      if (tooltip.dataPoints.length > 0) {
        tooltip.dataPoints.forEach(function (dataPoint) {
          var $dsIdx = dataPoint.datasetIndex;
          var $idx = dataPoint.index;

          var content = $datasets[$dsIdx].label + ': ';
          if (dataPoint.yLabel < 0) {
            content += (-dataPoint.yLabel);
          } else {
            content += dataPoint.yLabel;
          }

          var $tt = $('<div>');
          addTooltipLine($tt, content);

          var quizCounts = quizCountsForDate(dataPoint.xLabel);
          addQuizLines($tt, quizCounts);

          for (var i = 0; i < $datasets.length; i++) {
            var $tooltip = $("#tooltip-" + i);


            if ($dsIdx == i) {
              $tooltip.html($tt);

              $tooltip.css({
                opacity: 1,
                top: positionY + dataPoint.y + "px",
                left: positionX + dataPoint.x + "px"
              });

              $tooltip.show();
            } else {
              $tooltip.hide();
            }
          }
        });
      }
    };

    var ctx = document.getElementById("quiz-activity-chart");

    var myChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'Correct Answers',
                data: correct_data,
                backgroundColor: 'hsla(120, 80%, 50%, 0.2)',
                borderColor: 'hsla(120, 80%, 50%, 1)',
                borderWidth: 1
            },
            {
                label: 'Incorrect Answers',
                data: incorrect_data,
                backgroundColor: 'hsla(0, 80%, 50%, 0.2)',
                borderColor: 'hsla(0, 80%, 50%, 1)',
                borderWidth: 1
            }]
        },
        options: {
            tooltips: {
                enabled: false,
                custom: customTooltips
            },
            title: {
                fontSize: 30,
                display: true,
                text: 'Quiz Activity'
            },
            scales: {
                yAxes: [{
                    id: 'y-axis-0',
                    stacked: true,
                    ticks: {
                        beginAtZero:true
                    }
                }]
            }
        }
    });
}

var chartMilestones = function() {
    entities = $('#milestones-chart').data('chart-stats');

    var ctx = document.getElementById("milestones-chart");

    var labels = $.map(entities, function(e) {
      return e.label;
    });

    var data = $.map(entities, function(e) {
      return e.datum;
    });

    var hues = function(n) {
      var step = 360 / n;
      return Array.apply(0, Array(n))
        .map(function (_, i) {
          return Math.round(i * step);
        });
    }(entities.length);

    var bgColors = hues.map(function(v) {
      return 'hsla(' + v + ', 80%, 50%, 0.2)';
    });

    bColors = hues.map(function(v) {
      return 'hsla(' + v + ', 80%, 50%, 1)';
    });

    var myChart = new Chart(ctx, {
        type: 'polarArea',
        data: {
            labels: labels,
            datasets: [{
                data: data,
                backgroundColor: bgColors,
                borderColor: bColors,
                borderWidth: 1
            }]
        },
        options: {
            tooltips: {
                enabled: true,
                titleFontSize: 24,
                bodyFontSize: 16,
            },
            title: {
                fontSize: 30,
                display: true,
                text: 'Completed Quizzes'
            }
        }
    });
}

$(document).on('ready page:load', function(e) {
  if ($('#devices-show').length > 0) {
      chartQuizActivity();
      chartMilestones();
  }
});
