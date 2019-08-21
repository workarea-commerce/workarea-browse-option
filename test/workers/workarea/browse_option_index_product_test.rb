require 'test_helper'

module Workarea
  class BrowseOptionIndexProductTest < TestCase
    include TestCase::SearchIndexing

    def test_perform
      product = create_product(id: '123||456+[789]  &&')

      IndexProduct.new.perform(product.id)
      assert(1, Search::Storefront::Product.count)

      product.update_attributes!(
        browse_option: 'color',
        variants: [
          { sku: 'SKU1', details: { color: ['Red'] } },
          { sku: 'SKU2', details: { color: ['Blue'] } }
        ]
      )

      IndexProduct.new.perform(product.id)
      assert(2, Search::Storefront::Product.count)
    end

    def test_clear
      Workarea::Search::Storefront.reset_indexes!

      foo_bar = create_product(id: 'FOO BAR')
      IndexProduct.perform(create_product(id: 'FOO'))
      IndexProduct.perform(create_product(id: 'BAR'))
      IndexProduct.perform(foo_bar)

      IndexProduct.clear(foo_bar)
      assert_equal(2, Search::Storefront.count)
    end
  end
end
