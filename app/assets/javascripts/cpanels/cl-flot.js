$(function() {
  $(".cl-flot").each(function(){
    $chart = $(this);

    var tickSize = $chart.data('tick-size') || 2;

    // Data used to draw flot chart
    var data = [
      {
        data: [[1457683200000,3726.87],[1457769600000,4083.1],
              [1457856000000,5571.9],[1457938800000,5141.01],[1458025200000,2447.48],
              [1458111600000,2706.87],[1458198000000,8277.91],[1458284400000,3378.47]],
        label: 'Revenue',
        color: '#2574AB'
      },
      {
        data: [[1457683200000,1755.73],[1457769600000,1937.7],
              [1457856000000,2583.9],[1457938800000,2532.71],[1458025200000,866.89],
              [1458111600000,952.19],[1458198000000,3217.48],[1458284400000,1068.32]],
        label: 'Cost',
        color: '#D9534F'
      },
      {
        data: [[1457683200000,1971.14],[1457769600000,2145.4],
              [1457856000000,2988],[1457938800000,2608.3],[1458025200000,1580.59],
              [1458111600000,1754.68],[1458198000000,5060.43],[1458284400000,2310.15]],
        label: 'Cost',
        color: '#259DAB'
      }
    ];


    var options = {
      series: {
        lines: {
          show: true,
          fill: true
        },
        splines: {
          show: true,
          tension: 0.3,
          lineWidth: 2,
          fill: .50
        },
        shadowSize: 0
      },
      points: {
        show: true
      },
      yaxis: {
        min: 0,
      },
      xaxis: { 
        mode: "time",
        tickSize: [tickSize, "day"],
        timeformat: "%Y-%m-%d"
      }
    };

    $.plot($chart, data, options);
  });
});