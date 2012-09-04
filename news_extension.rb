# Uncomment this if you reference any of your controllers in activate
# require_dependency "application_controller"
require "radiant-news-extension"

class NewsExtension < Radiant::Extension
  version     RadiantNewsExtension::VERSION
  description RadiantNewsExtension::DESCRIPTION
  url         RadiantNewsExtension::URL

  # See your config/routes.rb file in this extension to define custom routes

  Radiant::Config['news.paths'] ||= '/news/'
  def self.news_paths
    Radiant::Config['news.paths'].split(',')
  end
  def self.news_paths=(paths)
    Radiant::Config['news.paths'] = paths.join(',')
  end

  def activate
    MenuRenderer.exclude 'NewsPage'

    tab 'Content' do
      add_item 'News', '/admin/news', :after => 'Pages', :visibility => [:developer, :admin]
    end

    ArchivePage.send(:include, ArchivePageExtensions) if defined? ArchiveExtension
    Page.send(:include, PageExtensions)
    admin.page.edit.add :extended_metadata, 'admin/pages/news_meta_fields'


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
