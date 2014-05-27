# // This is a manifest file that'll be compiled into including all the files listed below.
# // Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
# // be included in the compiled file accessible from http://example.com/assets/application.js
# // It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# // the compiled file.
jQuery -> 
        $('.datatables').dataTable
          sDom: "<'row-fluid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>"
          sPaginationType: "bootstrap"
          bProcessing: true
          bServerSide: true
          sAjaxSource: $('.datatables').data('source')