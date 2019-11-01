require 'test_helper'

module Workarea
  module Storefront
    class BrowseOptionProductViewModelTest < TestCase
      def test_browse_link_options
        product = create_product(
          browse_option: 'color',
          variants: [
            { sku: 'SKU1', details: { color: ['Red'] } },
            { sku: 'SKU2', details: { color: ['Blue'] } }
          ]
        )

        view_model = ProductViewModel.new(
          product,
          via: '123',
          option: 'Red'
        )

        assert_equal(
          { via: '123', color: 'Red' }.with_indifferent_access,
          view_model.browse_link_options
        )

        product.browse_option = 'Color'
        view_model = ProductViewModel.new(product, 'option' => 'red')
        merged_options = view_model.browse_link_options.merge(color: 'Blue')

        assert_equal({ 'color' => 'Blue' }, merged_options)
      end

      def test_cache_key
        cached_product = Catalog::Product.new(create_product.as_document)
        cached_product.browse_option = 'color'

        view_model = ProductViewModel.new(cached_product, color: 'red')
        assert_match(/red/, view_model.cache_key)

        view_model = ProductViewModel.new(cached_product, option: 'red')
        assert_match(/red/, view_model.cache_key)
      end

      def test_primary_image
        product = Catalog::Product.new(name: 'test', browse_option: 'color')
        product.variants.build(details: { 'Color' => ['green'] }, sku: 'foo')

        green_1 = product.images.build(option: 'green', position: 2)
        product.images.build(option: 'red', position: 1)

        assert_equal(
          green_1,
          ProductViewModel.new(product, color: 'green').primary_image
        )
      end

      def test_current_browse_option
        product = Catalog::Product.new(name: 'test')

        assert_nil(ProductViewModel.new(product).current_browse_option)

        product.browse_option = 'color'
        assert_nil(ProductViewModel.new(product).current_browse_option)

        assert_equal(
          'red',
          ProductViewModel.new(product, option: 'red').current_browse_option
        )

        assert_equal(
          'red',
          ProductViewModel.new(product, color: 'red').current_browse_option
        )
      end
    end
  end
end
