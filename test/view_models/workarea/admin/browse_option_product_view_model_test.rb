require 'test_helper'

module Workarea
  module Admin
    class BrowseOptionProductViewModelTest < TestCase
      def test_browse_options
        product = create_product(
          variants: [
            { sku: 'SKU1', details: { color: ['Red'], size: ['Large'] } },
            { sku: 'SKU2', details: { color: ['Blue'], material: ['Cotton'] } }
          ]
        ).reload

        view_model = ProductViewModel.new(product)
        assert_equal(
          %w(None color size material),
          view_model.browse_options.map(&:first)
        )
      end
    end
  end
end
