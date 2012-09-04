class NewsPage < Page
  include News::Instance

  def self.new_with_defaults(config = Radiant::Config)
    page = NewsPage.new
    page.parts.concat(self.default_page_parts)
    page.fields.concat(self.default_page_fields)
    page.parent_id = Page.find_by_path(NewsExtension.news_paths[0]).try(:id)
    page.status = Status[Radiant::Config['defaults.page.status']]
    page
  end

end
