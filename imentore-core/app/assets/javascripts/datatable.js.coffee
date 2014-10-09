# // This is a manifest file that'll be compiled into including all the files listed below.
# // Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
# // be included in the compiled file accessible from http://example.com/assets/application.js
# // It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# // the compiled file.
$(document).ready ->  

  $("#datatable tfoot th").each ->
    title = $("#datatable thead th").eq($(this).index()).text()
    klass = $("#datatable thead th").eq($(this).index()).attr('class')
    $(this).html "<input type=\"text\" class=" + klass + " placeholder=" + title + " />"
    return

  # jQuery -> 
  table = $('#datatable').DataTable(
    # sDom: "<'row-fluid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>"
    sDom: "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
    sPaginationType: "bootstrap"
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#datatable').data('source')
    order: [0, 'desc']
  )

  # table.columns().eq(0).each (colIdx) ->
  #   $("input", table.column(colIdx).footer()).on "keyup change", ->
  #     table.column(colIdx).search(@value).draw()
  #   return
  # return

return