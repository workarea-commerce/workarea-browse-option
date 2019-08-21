require 'test_helper'

module Workarea
  module Search
    class Storefront
      class ProductOptionTest < IntegrationTest
        setup :set_product

        def set_product
          @product = create_product
        end

        def test_id_includes_the_first_browse_sku
          @product.id = 'PROD'
          search_doc = ProductOption.new(@product, value: 'The CraZY Value')
          assert_includes(search_doc.id, 'PROD-the_crazy_value')
        end

        def test_variants_only_includes_variants_which_match_the_option
          @product.variants.build(sku: 'SKU1', details: { color: 'red' })
          @product.variants.build(sku: 'SKU2', details: { color: 'green' })
          @product.variants.build(sku: 'SKU3', details: { color: 'green' })

          search_doc = ProductOption.new(
            @product,
            option: 'color',
            value: 'green'
          )
          assert_equal(2, search_doc.variants.length)
          assert_equal('SKU2', search_doc.variants.first.sku)
          assert_equal('SKU3', search_doc.variants.second.sku)
        end

        def test_primary_image
          @product.variants.create!(sku: 'SKU1', details: { color: 'red' })
          image = @product.images.create!(option: 'red')
          product_option = ProductOption.new(@product, option: 'color', value: 'red')

          assert_includes(product_option.primary_image, '/product_images')
          assert_includes(product_option.primary_image, image.option)
          assert_includes(product_option.primary_image, @product.slug)
        end

        def test_category_positions
          @product.update(
            browse_option: 'color',
            variants: [{ sku: 'SKU3', details: { color: 'green' } }]
          )
          category = create_category(
            product_ids: ['123', BrowseOptionIds.build(@product.id, 'green')]
          )
          search_doc = ProductOption.new(
            @product,
            option: 'color',
            value: 'green'
          )

          assert_equal(
            { category.id => 1 },
            search_doc.category_positions
          )
        end

        def test_facets
          sizes = ["XS", "S", "M", "L", "XL"]
          color = 'Lilac'

          @product.update!(
            browse_option: 'color',
            filters: {
              "size" => sizes,
              "color" => ["Cotton Candy", "Cherry", "Lilac"]
            },
            variants: [
              { sku: "248428849-2", details: { "size" => ["XS"], "color" => ["Cotton Candy"] } },
              { sku: "294249838-2", details: { "size" => ["S"], "color" => ["Cotton Candy"] } },
              { sku: "498401905-0", details: { "size" => ["M"], "color" => ["Cotton Candy"] } },
              { sku: "578902813-6", details: { "size" => ["L"], "color" => ["Cotton Candy"] } },
              { sku: "512627649-2", details: { "size" => ["XL"], "color" => ["Cotton Candy"] } },
              { sku: "788914021-5", details: { "size" => ["XS"], "color" => ["Cherry"] } },
              { sku: "921696744-7", details: { "size" => ["S"], "color" => ["Cherry"] } },
              { sku: "898374652-1", details: { "size" => ["M"], "color" => ["Cherry"] } },
              { sku: "526629545-7", details: { "size" => ["L"], "color" => ["Cherry"] } },
              { sku: "606887371-4", details: { "size" => ["XL"], "color" => ["Cherry"] } },
              { sku: "096342594-3", details: { "size" => ["XS"], "color" => ["Lilac"] } },
              { sku: "896263254-3", details: { "size" => ["S"], "color" => ["Lilac"] } },
              { sku: "746152723-1", details: { "size" => ["M"], "color" => ["Lilac"] } },
              { sku: "384474791-5", details: { "size" => ["L"], "color" => ["Lilac"] } },
              { sku: "629519307-2", details: { "size" => ["XL"], "color" => ["Lilac"] } }
            ]
          )

          document = ProductOption.new(
            @product,
            option: 'color',
            value: color
          ).as_document

          assert_equal(sizes, document[:facets]['size'])
          assert_equal([color], document[:facets]['color'])
        end
      end
    end
  end
end
