require 'test_helper'

module Workarea
  class FeaturedBrowseOptionProductsTest < TestCase
    class Foo
      include FeaturedBrowseOptionProducts
      attr_accessor :product_ids
    end

    def test_featured_product?
      model = Foo.new
      product = Catalog::Product.new

      model.product_ids = [product.id]
      assert(model.featured_product?(product.id))

      model.product_ids = [BrowseOptionIds.build(product.id, 'blue')]
      assert(model.featured_product?(product.id))
    end

    def test_unique_product_ids
      model = Foo.new
      model.product_ids = ['1245', BrowseOptionIds.build('2451', 'red')]

      assert_equal(%w(1245 2451), model.unique_product_ids)
    end
  end
end
