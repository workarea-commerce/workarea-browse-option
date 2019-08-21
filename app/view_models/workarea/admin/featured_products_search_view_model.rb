module Workarea
  module Admin
    class FeaturedProductsSearchViewModel < SearchViewModel
      def results
        @results ||= PagedArray.from(
          browse_option_results,
          model.results.page,
          model.results.per_page,
          total
        )
      end

      # Yes, I know this is dumb. But there seems to be a bug with flat_map and
      # flatten that is driving me fucking crazy and i need to avoid it.
      #
      def browse_option_results
        results = []

        persisted_results.each do |model|
          if model.browses_by_option?
            model.browse_options.each do |option|
              results.push(
                FeaturedBrowseOptionProductViewModel.wrap(
                  model,
                  view_model_options_for(model).merge(
                    model.browse_option => option.optionize
                  )
                )
              )
            end
          else
            results.push(
              FeaturedBrowseOptionProductViewModel.wrap(
                model,
                view_model_options_for(model)
              )
            )
          end
        end

        results
      end
    end
  end
end
