PgSearch.multisearch_options = {
  :using => { 
    :tsearch => {
      :prefix => true # match any characters
    } 
  },
  :ignoring => :accents
}