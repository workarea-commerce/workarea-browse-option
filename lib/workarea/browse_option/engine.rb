module Workarea
  module BrowseOption
    class Engine < ::Rails::Engine
      include Workarea::Plugin
      isolate_namespace Workarea::BrowseOption

      config.to_prepare do
        Catalog::Category.include(FeaturedBrowseOptionProducts)
        Search::Customization.include(FeaturedBrowseOptionProducts)

        Admin::CategoryViewModel.include(
          Admin::FeaturedBrowseOptionProductsViewModel
        )
        Admin::SearchCustomizationViewModel.include(
          Admin::FeaturedBrowseOptionProductsViewModel
        )
      end
    end
  end
end
