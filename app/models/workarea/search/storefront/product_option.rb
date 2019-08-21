module Workarea
  module Search
    class Storefront
      class ProductOption < Product
        def id
          "#{super}-#{value.optionize}"
        end

        # URL to the primary image for display in autocomplete results.
        #
        # @return [String]
        #
        def primary_image
          ProductOptionImageUrl.new(model, option: value).url
        end

        def option
          options[:option]
        end

        def category_positions
          Catalog::ProductPositions.find(
            BrowseOptionIds.for(model, value),
            categories: categorization.to_models
          )
        end

        def value
          options[:value].to_s
        end

        def variants
          @variants ||= model.variants.select do |variant|
            variant.matches_detail?(option, value)
          end
        end

        def skus
          variants.map(&:sku)
        end

        def as_document
          result = super
          result[:keywords][:option] = value
          result[:facets][option] = [value]
          result
        end
      end
    end
  end
end
