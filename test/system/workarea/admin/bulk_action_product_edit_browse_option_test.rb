require 'test_helper'

module Workarea
  module Admin
    class BulkActionProductEditBrowseOptionTest < Workarea::SystemTest
      include Admin::IntegrationTest

      def test_editing_browse_option
        products = Array.new(3) { create_product }
        Search::Settings.current.update_attributes!(terms_facets: %w(Color Size))

        assert_nil(products.first.browse_option)
        assert_nil(products.second.browse_option)
        assert_nil(products.third.browse_option)

        visit admin.catalog_products_path

        click_button(t('workarea.admin.catalog_products.index.edit'))

        find('#toggle_browses_by').click
        select 'Color', from: 'bulk_action[settings][browse_option]'

        click_button t('workarea.admin.bulk_action_product_edits.edit.review_changes')
        assert(page.has_content?('Browse Option: Color'))
        click_button t('workarea.admin.bulk_action_product_edits.review.save_and_finish')
        assert(page.has_content?('Your product edits are being processed'))

        products.each(&:reload)

        assert_equal('Color', products.first.browse_option)
        assert_equal('Color', products.second.browse_option)
        assert_equal('Color', products.third.browse_option)

        visit admin.catalog_products_path

        click_button(t('workarea.admin.catalog_products.index.edit'))

        find('#toggle_browses_by').click
        select 'None', from: 'bulk_action[settings][browse_option]'

        click_button t('workarea.admin.bulk_action_product_edits.edit.review_changes')
        assert(page.has_content?('Browse Option'))
        click_button t('workarea.admin.bulk_action_product_edits.review.save_and_finish')
        assert(page.has_content?('Your product edits are being processed'))

        products.each(&:reload)

        refute(products.first.browse_option.present?)
        refute(products.second.browse_option.present?)
        refute(products.third.browse_option.present?)
      end
    end
  end
end
