module Workarea
  module Admin
    module FeaturedBrowseOptionProductsViewModel
      def featured_products
        @featured_products ||=
          begin
            models = Catalog::Product.any_in(id: model.unique_product_ids).to_a

            results = model.product_ids.map do |id|
              id, option = BrowseOptionIds.split(id)
              tmp = models.detect { |m| m.id == id }
              next unless tmp.present?

              Admin::FeaturedBrowseOptionProductViewModel.new(
                tmp,
                tmp.browse_option => option&.optionize
              )
            end
          end
      end
    end
  end
end
