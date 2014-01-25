class @Util
  @onReady: (do_on_load) ->
    $(document).ready(do_on_load)
    $(window).bind('page:change', do_on_load)