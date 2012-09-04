module PageExtensions
  def self.included(base)
    base.class_eval do
      include NewsTags
      def news?
        self.is_a?(News::Instance)
      end

      def contains_news
        NewsExtension.news_paths.include? self.path
      end
      def contains_news=(checked)
        if checked == 1
          NewsExtension.news_paths = NewsExtension.news_paths << self.path unless contains_news
        else
          NewsExtension.news_paths = NewsExtension.news_paths - [self.path]
        end 
      end
    end
  end  
end
