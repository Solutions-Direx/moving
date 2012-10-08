var I18n = (function() {
  var locales = {
    'en': {
      'hour_not_match': "Hours don't match hours billed on invoice. Please check again.",
      'internal': 'Internal',
      'not_internal': 'Not Internal'
    },
    'fr': {
      'hour_not_match': "Les heures ne correspondent pas au temps facturé. Veuillez vérifier.",
      'internal': 'Interne',
      'not_internal': 'Externe'
    }   
  };

  var t = function(key) {
    return locales[CURRENT_LOCALE][key];
  };

  return {
    t: t
  }
})();
