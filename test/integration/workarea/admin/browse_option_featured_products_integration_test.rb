require 'test_helper'

module Workarea
  module Admin
    class BrowseOptionFeaturedProductsIntegrationTest < Workarea::IntegrationTest
      include Admin::IntegrationTest

      setup :product

      def product
        @product ||=
          create_product(
            id:          'PROD1',
            name:        'Integration Product',
            filters:     { 'Size' => %w(Medium Large), 'Color' => 'Red' },
            browse_option: 'size',
            variants:    [
              { sku: 'SKU1', regular: 5.to_m, details: { 'Size' => 'Medium' } },
              { sku: 'SKU2', regular: 5.to_m, details: { 'Size' => 'Large' } }
            ]
          )
      end

      def test_adding_a_product_that_browses_by_option
        option_id = BrowseOptionIds.for(product, 'Medium')
        category = create_category(product_ids: [])

        post admin.add_featured_product_path(category.to_global_id),
              params: { product_id: option_id }

        assert_equal([option_id], category.reload.product_ids)
      end

      def test_removing_a_product
        option_id = BrowseOptionIds.for(product, 'Medium')
        category = create_category(product_ids: [option_id])

        delete admin.remove_featured_product_path(category.to_global_id),
                params: { product_id: option_id }

        assert_equal([], category.reload.product_ids)
      end
    end
  end
end
