module Jekyll
  class TagSvg < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @arguments = text.split(',').map {|item| item.strip}.map {|item| item.tr('\'', '')}

      @svg_file = @arguments[0]
      #Jekyll.logger.info File.dirname(__FILE__) + '/../assets/' + @svg_file
      @svg_string = File.read(File.dirname(__FILE__) + '/../assets/' + @svg_file)
      @svg_caption = ""

      if @arguments[1].nil?
        @svg_classes = ""
      else
        @svg_classes = @arguments[1]
      end
      if @arguments[2].nil?
        @svg_caption = ""
      else
        @svg_caption = "<figcaption class=\"text-muted text-center\">#{@arguments[2]}</figcaption>"
      end
    end

    def render(context)
      <<-HTML.gsub /^\s+/, ''
          <figure class="#{@svg_classes}">
            #{@svg_string}
            #{@svg_caption}
          </figure>
      HTML
    end
  end
end

Liquid::Template.register_tag('render_svg', Jekyll::TagSvg)