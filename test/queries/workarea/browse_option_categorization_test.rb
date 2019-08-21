require 'test_helper'

module Workarea
  class BrowseOptionCategorizationTest < TestCase
    def test_manual
      product = create_product(
        browse_option: 'color',
        variants: [{ sku: 'SKU', details: { 'color' => 'red' } }]
      )
      category_one = create_category(product_ids: [product.id])
      category_two = create_category(
        product_ids: [BrowseOptionIds.build(product.id, 'red')]
      )

      categorization = Categorization.new(product)
      assert(categorization.manual.include?(category_one.id))
      assert(categorization.manual.include?(category_two.id))
    end
  end
end
