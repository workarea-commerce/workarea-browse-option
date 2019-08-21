require 'test_helper'

module Workarea
  module Catalog
    class BrowseOptionProductTest < TestCase
      def test_browse_options
        product = Product.new(browse_option: 'color')
        product.variants.build(details: { 'color' => 'red' })
        product.variants.build(details: { 'color' => 'red' })
        product.variants.build(details: { 'color' => 'green' })
        product.variants.build(details: { 'color' => %w(blue violet) })
        product.variants.build(details: { 'color' => '' })
        product.variants.build(active: false, details: { 'color' => 'orange' })

        assert_equal(6, product.variants.length)
        assert_equal(%w(red green blue violet), product.browse_options)
      end
    end
  end
end
