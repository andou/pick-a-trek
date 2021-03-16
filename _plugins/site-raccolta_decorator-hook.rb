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
      prevmulti = nil
      for stage in raccolta['stages']
        #Jekyll.logger.info  stage.inspect
        #Jekyll.logger.info  dictionary[stage].inspect
        unless prevmulti.nil?
            dictionary[stage].data['prevmulti'] = prevmulti
            dictionary[stage].data['multistage'] = raccolta
            dictionary[prevmulti.id].data['nextmulti'] = dictionary[stage]
            dictionary[prevmulti.id].data['multistage'] = raccolta
        end
        prevmulti = dictionary[stage]
        stages << dictionary[stage]
      end

      raccolta.data['stages'] = stages
    end
  end

end
