module Workarea
  module FeaturedBrowseOptionProducts
    def featured_product?(id)
      product_ids.any? do |product_id|
        product_id == id || BrowseOptionIds.extract(product_id) == id
      end
    end

    def unique_product_ids
      product_ids.map { |id| BrowseOptionIds.extract(id) }.uniq
    end
  end
end
