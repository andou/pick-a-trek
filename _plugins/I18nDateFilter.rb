# see: https://github.com/gacha/gacha.id.lv/blob/old-blog/_plugins/i18n_filter.rb
# see: https://github.com/svenfuchs/rails-i18n/tree/master/rails/locale

require 'i18n'

LOCALE = Jekyll.configuration({})['locale']

module Jekyll
  module I18nDateFilter
    def localizeDate(input, format=nil)
      load_translations
      if(Jekyll.env == "development")
        I18n.locale = 'it'
      end
      format = (format =~ /^:(\w+)/) ? $1.to_sym : format
      return I18n.l input, :format => format
    rescue StandardError => e
      "error"
    end

    def date_loc(input, format=nil)
        if(format.nil?)
            return localizeDate(input,":short")
        end
        return localizeDate(input,format)
    end

    def load_translations
      if I18n.backend.send(:translations).empty?
        I18n.backend.load_translations Dir[File.join(File.dirname(__FILE__),'../_locales/*.yml')]
        I18n.locale = LOCALE
        Jekyll.logger.info "Locale is now: " + I18n.locale.inspect
      end
      rescue StandardError => e
        Jekyll.logger.info "Exception Loading Translations: " + e.message
        Jekyll.logger.info e.backtrace.inspect
    end
  end
end

Liquid::Template.register_filter(Jekyll::I18nDateFilter)