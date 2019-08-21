require 'test_helper'

module Workarea
  module Admin
    class BrowseOptionFeaturedProductsSystemTest < Workarea::SystemTest
      include Admin::IntegrationTest

      def test_managing_browse_option_featured_products
        create_product(
          name: 'Foo',
          browse_option: 'color',
          variants:    [
            { sku: 'SKU1', details: { 'Color' => 'Red' } },
            { sku: 'SKU2', details: { 'Color' => 'Blue' } },
            { sku: 'SKU3', details: { 'Color' => 'Green' } }
          ]
        )
        create_product(name: 'Bar')

        category = create_category
        visit admin.catalog_category_path(category)

        click_link t('workarea.admin.catalog_categories.cards.featured_products.title')
        assert(page.has_content?('Foo - Red'))
        assert(page.has_content?('Foo - Blue'))
        assert(page.has_content?('Foo - Green'))
        assert(page.has_content?('Bar'))

        click_link 'Foo - Red'
        assert(page.has_content?('Success'))
        click_link 'Foo - Blue'
        assert(page.has_content?('Success'))
        assert(page.has_selector?('.product-summary__remove'))
        click_link 'Foo - Blue'
        assert(page.has_content?('Success'))
        click_link t('workarea.admin.featured_products.select.sort_link')

        assert(page.has_content?('Foo - Red'))
        assert(page.has_no_content?('Foo - Blue'))
        assert(page.has_no_content?('Foo - Green'))
        assert(page.has_no_content?('Bar'))
        click_link t('workarea.admin.featured_products.edit.browse_link')

        assert(page.has_selector?('.product-summary__remove'))
        click_link 'Foo - Red'
        assert(page.has_content?('Success'))
        assert(page.has_no_selector?('.product-summary__remove'))
        click_link t('workarea.admin.featured_products.select.sort_link')

        assert(page.has_no_content?('Foo - Red'))
        assert(page.has_no_content?('Foo - Blue'))
        assert(page.has_no_content?('Bar'))
        assert(page.has_no_selector?('#product_ids_'))
      end
    end
  end
end
