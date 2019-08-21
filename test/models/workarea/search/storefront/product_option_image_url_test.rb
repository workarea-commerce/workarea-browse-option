require 'test_helper'

module Workarea
  module Search
    class Storefront
      class ProductOptionImageUrlTest < TestCase
        def test_image
          product = create_product
          image = product.images.create!(option: 'red')
          url = ProductOptionImageUrl.new(product, option: image.option)

          assert_equal(image, url.send(:image))
          refute_nil(url.path)
          refute_nil(url.url)
        end
      end
    end
  end
end
