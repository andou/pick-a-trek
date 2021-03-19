BASEURL = Jekyll.configuration({})['baseurl']

module Jekyll
	class TagFigure < Liquid::Tag

		def initialize(tag_name, markup, context)
			@markup = markup
            super
		end

		def render(context)
			markup = Liquid::Template.parse(@markup).render context
			arguments = markup.strip.split(',').map {|item| item.strip}

			fig_src = BASEURL + arguments[0]
			fig_caption = ""
			fig_alt = ""

			if arguments[1].nil?
				fig_classes = ""
			else
				fig_classes = arguments[1]
			end
			if arguments[2].nil?
				fig_caption = ""
			else
				fig_caption = "<figcaption class=\"figure-caption text-muted text-center\">#{arguments[2]}</figcaption>"
			end
			if arguments[3].nil?
				fig_alt = File.basename(fig_src, ".*")
			else
				fig_alt = arguments[3]
			end


          markup = <<-HTML.gsub /^\s+/, ''
              <figure class="figure #{fig_classes}">
                <img class="figure-img" src="#{fig_src}" alt="#{fig_alt}">
                #{fig_caption}
              </figure>
          HTML


			#Jekyll.logger.info "rendering -> " + markup

			return markup
		end
	end
end

Liquid::Template.register_tag('figure', Jekyll::TagFigure)

