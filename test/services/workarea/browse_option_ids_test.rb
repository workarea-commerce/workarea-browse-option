require 'test_helper'

module Workarea
  class BrowseOptionIdsTest < TestCase
    setup :set_conjunction
    teardown :reset_conjunction

    def set_conjunction
      @conjunction = Workarea.config.browse_option_product_id_conjunction
      Workarea.config.browse_option_product_id_conjunction = '~'
    end

    def reset_conjunction
      Workarea.config.browse_option_product_id_conjunction = @conjunction
    end

    def product
      @product ||= create_product(
        browse_option: 'color',
        variants:    [
          { sku: 'SKU1', details: { 'Color' => 'Red' } },
          { sku: 'SKU2', details: { 'Color' => 'Blue' } }
        ]
      )
    end

    def test_all_for
      assert_equal(
        ["#{product.id}~red", "#{product.id}~blue"],
        BrowseOptionIds.all_for(product)
      )

      assert_equal(
        ["#{product.id}~white", "#{product.id}~yellow"],
        BrowseOptionIds.all_for(product, %w(white yellow))
      )

      product.update(browse_option: nil)
      assert_equal([product.id], BrowseOptionIds.all_for(product))
    end

    def test_for
      assert_equal(
        "#{product.id}~yellow",
        BrowseOptionIds.for(product, 'yellow')
      )

      assert_equal("#{product.id}~red", BrowseOptionIds.for(product))
    end

    def test_build
      assert_equal('123~blue', BrowseOptionIds.build('123', 'blue'))
    end

    def test_split
      assert_equal(%w(PRODUCT_ID blue), BrowseOptionIds.split('PRODUCT_ID~blue'))
    end

    def test_extract
      assert_equal('PRODUCT_ID', BrowseOptionIds.extract('PRODUCT_ID~blue'))
    end
  end
end
