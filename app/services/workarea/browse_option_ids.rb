module Workarea
  class BrowseOptionIds
    class << self
      def all_for(product, options = [])
        return [product.id] unless product.browses_by_option?

        (Array.wrap(options).presence || product.browse_options).map do |option|
          build(product.id, option.optionize)
        end
      end

      def for(product, option = nil)
        return product.id unless product.browses_by_option?

        if option.present?
          build(product.id, option.optionize)
        else
          all_for(product).first
        end
      end

      def build(product_id, option)
        [product_id, conjunction, option.optionize].join
      end

      def split(browse_option_id)
        browse_option_id.to_s.split(conjunction)
      end

      def extract(browse_option_id)
        split(browse_option_id).first
      end

      def conjunction
        Workarea.config.browse_option_product_id_conjunction
      end
    end
  end
end
