(function() {

  jQuery(function() {
      $("body")
        .on('mouseover', 'a[rel="popover"]', function(e) {
          $(this).popover({ html: true }).popover('show');
        })
        .on('mouseout', 'a[rel="popover"]', function(e) {
          $(this).popover({ html: true }).popover('hide');
        })

    $(".tooltip").tooltip({
      html: true
    });
    $("a[rel=tooltip]").tooltip({
      html: true
    });

    $(".alert").alert();
    $(".tabs").button();
    $(".dropdown-toggle").dropdown();
    return $(".tab").tab("show");
  });

  jQuery(function() {
    $(document).on("click",'.service-action',function(){
      var aform = $('#service-command');
      $(aform).find('input[name=command]').val($(this).attr('data-command'));
      $(aform).find('input[name=server]').val($(this).attr('data-server'));
      $(aform).find('input[name=service]').val($(this).attr('data-service'));
      aform.submit();
    }); 
  });

}).call(this);