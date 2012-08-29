require 'digest/md5'
module News
  module InvalidHomePage; end
  module Instance
    def self.included(base)
      base.class_eval {
        before_validation :set_slug
        before_validation :set_breadcrumb
        class_inheritable_accessor :news_root

        def self.default_page_parts
          PagePart.new(:name => 'body')
        end
        def self.default_page_fields
          PageField.new(:name => 'Description')
        end

        def parent_path
          unless self.parent.nil?
            self.parent.path
          else
            nil
          end
        end
        def parent_path=(path)
          self.parent_id = Page.find_by_path(path).id
        end
      }
    end

    def cache?
      true
    end

    # We want to be able to iterate over news items
    def virtual?
      false
    end
  
    def find_by_path(path, live = true, clean = true)
      path = clean_path(path) if clean
      my_path = self.path
      if (my_path == path) && (not live or published?)
        self
      elsif (path =~ /^#{Regexp.quote(my_path)}([^\/]*)/)
        slug_child = children.find_by_slug($1)
        if slug_child
          return slug_child
        else
          super
        end
      end
    end
        
    def digest
      @generated_digest ||= digest!
    end

    def digest!
      Digest::MD5.hexdigest(self.render)
    end

    def child_path(child)
      clean_path(path + '/' + child.slug + child.cache_marker)
    end

    def cache_marker
      Radiant::Config['news.use_cache_param?'] ? "?#{digest}" : ''
    end
    
    private

    def clean_path(path)
      "/#{ path.to_s.strip }".gsub(%r{//+}, '/')
    end

    def set_slug
      self.slug = self.title.to_slug
    end

    def set_breadcrumb
      self.breadcrumb = self.slug
    end
  end
end
