#!/usr/bin/env ruby
#
# Check for changed posts

Jekyll::Hooks.register :posts, :post_init do |post|

  if(Jekyll.env != "development")
    commit_num = `git rev-list --count HEAD "#{ post.path }"`

    if commit_num.to_i > 0
      lastmod_date = `git log -1 --pretty="%ad" --date=iso "#{ post.path }"`
      post.data['last_modified_at'] = lastmod_date
    end
  end

end

Jekyll::Hooks.register :raccolte, :post_init do |post|

  if(Jekyll.env != "development")
    commit_num = `git rev-list --count HEAD "#{ post.path }"`

    if commit_num.to_i > 0
      lastmod_date = `git log -1 --pretty="%ad" --date=iso "#{ post.path }"`
      post.data['last_modified_at'] = lastmod_date
    end
  end

end

Jekyll::Hooks.register :sentieri, :post_init do |post|

  if(Jekyll.env != "development")
    commit_num = `git rev-list --count HEAD "#{ post.path }"`

    if commit_num.to_i > 0
      lastmod_date = `git log -1 --pretty="%ad" --date=iso "#{ post.path }"`
      post.data['last_modified_at'] = lastmod_date
    end
  end

end
