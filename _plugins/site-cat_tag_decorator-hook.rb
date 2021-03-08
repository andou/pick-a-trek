#!/usr/bin/env ruby

Jekyll::Hooks.register :site, :post_read do |site|
  sentieri = site.collections['sentieri'].docs
  for post in sentieri
      if post['tags'].size > 0
        for the_tag in post['tags']
            site.tags[the_tag] << post
        end
      end
      if post['categories'].size > 0
        for the_cat in post['categories']
            site.categories[the_cat] << post
        end
      end
  end
end
