# Uncomment this if you reference any of your controllers in activate
# require_dependency "application_controller"
require "radiant-news-extension"

class NewsExtension < Radiant::Extension
  version     RadiantNewsExtension::VERSION
  description RadiantNewsExtension::DESCRIPTION
  url         RadiantNewsExtension::URL

  # See your config/routes.rb file in this extension to define custom routes

  extension_config do |config|
  end

  cattr_accessor :news_types, :news_paths

  @@news_types ||= ['General']
  @@news_paths ||= ['/news/']

  def activate
    MenuRenderer.exclude 'NewsPage'

    tab 'Content' do
      add_item "News", "/admin/news", :after => "Pages", :visibility => [:developer, :admin]
    end

    Page.class_eval do      
      def news?
        self.is_a?(News::Instance)
      end

      include NewsTags
    end

    if defined? ArchivePage
      ArchivePage.class_eval do
        alias_method :child_path_original, :child_path
        def child_path(child)
          if (NewsExtension.news_paths.include?(self.path) && child.news?)
            child_path_original(child)
          else
            # Page.child_path(child)
            clean_path(path + '/' + child.slug)
          end
        end
      end
    end

    Admin::NodeHelper.module_eval do
      def render_node_with_news(page, locals = {})
        unless page.news?
          render_node_without_news(page, locals)
        end
      end
      alias_method_chain :render_node, :news
    end
    SiteController.class_eval do
      def self.news_cache_timeout
        @news_cache_timeout ||= 7.days
      end
      def self.news_cache_timeout=(val)
        @news_cache_timeout = val
      end
      
      def set_cache_control_with_news
        if @page.news?
          expires_in self.class.news_cache_timeout, :public => true, :private => false
        else
          set_cache_control_without_news
        end
      end
      alias_method_chain :set_cache_control, :news
    end
  end
end
