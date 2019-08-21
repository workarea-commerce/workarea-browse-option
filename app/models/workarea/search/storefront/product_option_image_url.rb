module Workarea
  module Search
    class Storefront
      class ProductOptionImageUrl < Workarea::ProductPrimaryImageUrl
        def initialize(product, image_size: :small_thumb, option:)
          super(product, image_size)
          @option = option
        end

        def image
          @product.images.find_by(option: @option)
        rescue Mongoid::Errors::DocumentNotFound
          super
        end
      end
    end
  end
end
