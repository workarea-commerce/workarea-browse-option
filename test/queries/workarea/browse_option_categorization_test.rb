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
      category_three = create_category

      categorization = Categorization.new(product)
      assert(categorization.manual.include?(category_one.id))
      assert(categorization.manual.include?(category_two.id))
      refute(categorization.manual.include?(category_three.id))

      release = create_release(publish_at: 1.day.from_now)

      release.as_current do
        category_one.update!(product_ids: [])
        category_three.update!(
          product_ids: [BrowseOptionIds.build(product.id, 'red')]
        )

        categorization = Categorization.new(product)
        refute(categorization.manual.include?(category_one.id))
        assert(categorization.manual.include?(category_two.id))
        assert(categorization.manual.include?(category_three.id))
      end
    end
  end
end
