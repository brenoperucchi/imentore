jQuery ->
  # $("a[rel~=popover], .has-popover").popover()
  $('a[data-toggle^="tooltip"]').tooltip()