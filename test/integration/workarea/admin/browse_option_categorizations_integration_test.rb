require 'test_helper'

module Workarea
  class Admin::BrowseOptionCategorizationsIntegrationTest < IntegrationTest
    include Admin::IntegrationTest

    setup :setup_models

    def test_creation
      post admin.catalog_product_categorizations_path(@product),
        params: { category_ids: [@category.id] }

      assert_includes(@category.reload.product_ids, @id)
      assert_equal(@product.browse_options.size, @category.products.size)
      assert_redirected_to(admin.catalog_product_categorizations_path(@product))
    end

    def test_deletion
      @category.update!(product_ids: [@id])
      delete admin.catalog_product_categorization_path(@product, @category)
      @category.reload

      refute_includes(@category.product_ids, @id)
      assert_empty(@category.products)
      assert_response(:ok)
    end

    private

    def setup_models
      @product =
        create_product(
          id:          'PROD1',
          name:        'Integration Product',
          details:     { 'Size' => %w(Medium Large) },
          filters:     { 'Size' => %w(Medium Large), 'Color' => 'Red' },
          browse_option: 'size',
          variants:    [
            { sku: 'SKU1', regular: 5.to_m, details: { 'Size' => 'Medium' } },
            { sku: 'SKU2', regular: 5.to_m, details: { 'Size' => 'Large' } }
          ]
        )
      @id = BrowseOptionIds.for(@product, @product.browse_options.first)
      @category = Storefront::CategoryViewModel.wrap(create_category)
    end
  end
end
