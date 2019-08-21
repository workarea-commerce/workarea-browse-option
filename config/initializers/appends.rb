Workarea.append_partials(
  'admin.product_fields',
  'workarea/admin/catalog_products/browse_option_field'
)

Workarea.append_partials(
  'admin.product_attributes_card',
  'workarea/admin/catalog_products/browse_option_attribute_card'
)

Workarea.append_partials(
  'admin.product_bulk_update_settings',
  'workarea/admin/bulk_action_product_edits/browse_option_field'
)

if Workarea::Plugin.installed?('Workarea::Api::Storefront')
  Workarea.append_partials(
    'api.storefront.product_details',
    'workarea/api/storefront/products/browse_option_field'
  )
end
