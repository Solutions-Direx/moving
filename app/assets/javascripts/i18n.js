var I18n = (function() {
  var locales = {
    'en': {
      'hour_not_match': "Hours don't match hours billed on invoice"
    },
    'fr': {
      'hour_not_match': "Hours don't match hours billed on invoice sadf"
    }   
  };

  var t = function(key) {
    return locales[CURRENT_LOCALE][key];
  };

  return {
    t: t
  }
})();
