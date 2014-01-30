// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery.ui.all
//= require jquery_ujs
//= require address_widget.js.coffee
//= require i18n.js
//= require invoices.js.coffee.erb
//= require jquery.mask.min
//= require main.js.coffee
//= require nested_form.js
//= require quotes.js.coffee
//= require reports.js.coffee
//= require_tree ../../../vendor/assets/javascripts
//= require turbolinks


$(function() {
  // Popover
  $('a[rel=popover]').popover();

  // fix sub nav on scroll
  var $win = $(window)
    , $nav = $('.subnav')
  , navHeight = $('.navbar').first().height()
    , navTop = $('.subnav').length && $('.subnav').offset().top - navHeight
    , isFixed = 0

  processScroll()

  $win.on('scroll', processScroll)

  function processScroll() {
    var i, scrollTop = $win.scrollTop()
    if (scrollTop >= navTop && !isFixed) {
      isFixed = 1
      $nav.addClass('subnav-fixed')
    } else if (scrollTop <= navTop && isFixed) {
      isFixed = 0
      $nav.removeClass('subnav-fixed')
    }
  }
});