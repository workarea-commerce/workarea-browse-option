Workarea.configure do |config|
  # Used to find irregular characters in product ids that can cause issues
  # with finding a document in elasticsearch when reindexing.
  config.search_index_id_escape_regex = %r{
    ( [-!\(\)\{\}\[\]^"~*?:\\\/]    # A special character
      | &&                          # Boolean &&
      | \|\|                        # Boolean ||
    )
  }x

  # Used to combine product_id and browse option value when storing
  # each option in featured products in the format of [ID][CONJUNCTION][OPTION]
  # i.e. 1018-5915--blue. Changing this after a category has featured a browse
  # option will not update the category automatically and will require a
  # reindex of products.
  config.browse_option_product_id_conjunction = '--'
end
