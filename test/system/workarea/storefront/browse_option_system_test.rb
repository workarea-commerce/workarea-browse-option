require 'test_helper'

module Workarea
  module Storefront
    class BrowseOptionSystemTest < Workarea::SystemTest
      setup :set_products
      setup :index_products

      def set_products
        @products = [
          create_product(
            id:          'PROD1',
            name:        'Integration Product 1',
            filters:     { 'Size' => ['Medium'], 'Color' => %w(Green Red) },
            created_at:  Time.now - 1.hour,
            variants:    [
              { sku: 'SKU1', regular: 10.to_m }
            ]
          ),
          create_product(
            id:          'PROD2',
            name:        'Integration Product 2',
            filters:     { 'Size' => %w(Medium Large), 'Color' => 'Red' },
            created_at:  Time.now - 2.hour,
            variants:    [
              { sku: 'SKU2', regular: 5.to_m, details: { 'Size' => 'Medium' } },
              { sku: 'SKU4', regular: 5.to_m, details: { 'Size' => 'Large' } }
            ]
          )
        ]
      end

      def index_products
        BulkIndexProducts.perform_by_models(@products)
      end

      def test_categories_with_browse_option_products
        @products.second.update_attributes(browse_option: 'size')

        category = create_category(
          product_ids: [
            BrowseOptionIds.build(@products.second.id, 'Medium'),
            @products.first.id,
            BrowseOptionIds.build(@products.second.id, 'Large')
          ]
        )

        visit storefront.category_path(category)
        assert(
          page.has_ordered_text?(
            @products.second.name,
            @products.first.name,
            @products.second.name
          )
        )

        first_sku_url  = '/products/integration-product-2?size=Medium'
        second_sku_url = '/products/integration-product-2?size=Large'

        assert_includes(page.html, first_sku_url)
        assert_includes(page.html, second_sku_url)

        @products.second.update_attributes(browse_option: '')
        category.update(product_ids: @products.map(&:id))

        visit storefront.category_path(category)
        assert_text(@products.second.name, count: 1)

        refute_includes(page.html, first_sku_url)
        refute_includes(page.html, second_sku_url)
      end

      def test_search_with_browse_option_products
        visit storefront.search_path(q: 'integration')
        assert_equal(2, page.all('.product-summary').count)

        @products.second.update_attributes!(browse_option: 'size')

        visit storefront.search_path(q: 'integration')
        assert_equal(3, page.all('.product-summary').count)

        @products.second.update_attributes!(browse_option: nil)

        visit storefront.search_path(q: 'integration')
        assert_equal(2, page.all('.product-summary').count)
      end

      def test_image_display
        product = @products.second
        product.update_attributes!(browse_option: 'size')

        images = %w(medium large).map do |color|
          path = BrowseOption::Engine.root.join('test', 'fixtures', 'files', "#{color}.jpg")
          file = File.read(path)
          product.images.create!(option: color.titleize, image: file)
        end

        visit storefront.search_path(q: 'integration')

        assert_text(product.name)

        images.each do |image|
          image_url = Search::Storefront::ProductOptionImageUrl.new(product, image_size: :large_thumb, option: image.option).url

          assert_includes(page.html, image_url)
        end
      end
    end
  end
end
