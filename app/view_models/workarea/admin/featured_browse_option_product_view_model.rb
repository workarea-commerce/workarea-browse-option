module Workarea
  module Admin
    # Used for displaying each product option in feature product UI
    class FeaturedBrowseOptionProductViewModel < ProductViewModel
      def id
        BrowseOptionIds.for(model, browse_option_value)
      end

      def name
        [model.name, browse_option_value&.titleize].compact.join(' - ')
      end

      def browse_option_value
        @options[model.browse_option]
      end
    end
  end
end
