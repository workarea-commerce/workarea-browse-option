require 'test_helper'

module Workarea
  module Storefront
    class ProductViewModel
      class ImageCollectionTest < TestCase
        def all_images
          @all_images ||= [
            Catalog::ProductImage.new(image_name: 'foo'),
            Catalog::ProductImage.new(image_name: 'bar'),
            Catalog::ProductImage.new(image_name: 'baz')
          ]
        end

        def additional_images
          @additional_images ||=
            [Catalog::ProductImage.new(image_name: 'add')]
        end

        def product
          @product ||= Catalog::Product.new(name: 'test', images: all_images)
        end

        def custom_images
          @custom_images ||= product.images.where(image_name: 'baz')
        end

        def test_initialize
          image_collection = ImageCollection.new(product, {}, custom_images)
          assert_equal(custom_images, image_collection.all)

          image_collection = ImageCollection.new(product)
          assert_equal(all_images, image_collection.all)

          image_collection = ImageCollection.new(product, {}, [])
          assert_equal([], image_collection.all)

          image_collection_a = ImageCollection.new(product, {}, all_images)
          image_collection_b = ImageCollection.new(product, {}, additional_images)
          image_collection_c = image_collection_a + image_collection_b
          combined_images = all_images + additional_images
          assert_equal(combined_images.sort, image_collection_c.all.sort)
        end

        def test_primary
          all_images.second.option = 'green'
          all_images.third.option = 'blue'

          product.browse_option = 'color'
          product_pdp_options = { color: 'green' }.with_indifferent_access

          image_collection = ImageCollection.new(
            product,
            product_pdp_options,
            all_images
          )

          assert_equal('green', image_collection.primary.option)

          product_result_options = { option: 'blue' }.with_indifferent_access

          image_collection = ImageCollection.new(
            # Storefront::ProductViewModel.wrap(product),
            product,
            product_result_options,
            all_images
          )

          assert_equal('blue', image_collection.primary.option)
        end
      end
    end
  end
end
