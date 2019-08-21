require 'test_helper'

module Workarea
  module Api
    module Storefront
      class BrowseOptionProductIntegrationTest < Workarea::IntegrationTest
        if Plugin.installed?('Workarea::Api::Storefront')
          setup :product, :category, :index_product

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

          def category
            @category ||= begin
              category = create_category(
                product_ids: [product.id],
                terms_facets: %w(Size Color)
              )

              first_level = create_taxon(name: 'First Level')
              first_level.children.create!(navigable: category)

              content = Content.for(category)
              content.blocks.build(
                area: :above_results,
                type: :text,
                data: { text: 'text' }
              )

              category
            end
          end

          def index_product
            Workarea::IndexProduct.perform(product)
          end

          def test_category_show
            get storefront_api.category_path(category)
            result = JSON.parse(response.body)

            assert_equal(category.id.to_s, result['id'])

            assert_equal(2, result['total_results'])
            assert_equal(2, result['products'].count)

            product_result = result['products'].first
            assert_equal(product.browse_option, product_result['browse_option'])
            assert_equal('Medium', product_result['current_browse_option'])
          end

          def test_product_show
            get storefront_api.product_path(@product)
            results = JSON.parse(response.body)
            product_result = results['product']

            assert_equal(product.browse_option, product_result['browse_option'])
          end
        end
      end
    end
  end
end
