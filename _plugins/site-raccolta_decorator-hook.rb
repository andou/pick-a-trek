#!/usr/bin/env ruby

Jekyll::Hooks.register :site, :post_read do |site|

  dictionary = {}

  for post in site.collections['sentieri'].docs
      #Jekyll.logger.info  post.id.inspect
      dictionary[post.id] = post
  end

  for raccolta in site.collections['raccolte'].docs
    if raccolta['stages'].size > 0
      stages = []
      for stage in raccolta['stages']
        #Jekyll.logger.info  stage.inspect
        #Jekyll.logger.info  dictionary[stage].inspect
        stages << dictionary[stage]
      end

      raccolta.data['stages'] = stages
    end
  end

end
