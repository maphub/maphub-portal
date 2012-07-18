jQuery ->
  $("a[rel=popover]").popover({
    delay: {
    show: 100,
    hide: 700
    }
  })
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()
  $('.carousel').carousel()