module Jekyll
    module FilterLiquify
      def liquify(input)
        res = Liquid::Template.parse(input).render(@context)
        return res
      end
    end
end

Liquid::Template.register_filter(Jekyll::FilterLiquify)