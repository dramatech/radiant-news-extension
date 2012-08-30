class NewsDataset < Dataset::Base
  uses :home_page

  def load
    create_page 'news', :slug => 'news', :class_name => 'Page', :parent_id => pages(:home).id do
      create_page 'News Item', :slug => 'news-item', :class_name => 'NewsPage'
    end
  end
end
