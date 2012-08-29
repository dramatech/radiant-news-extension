module Admin::NewsHelper
  def news_type_options_for_select(selected=nil)
    NewsExtension.news_paths.each_with_index.map{ |p,i| [NewsExtension.news_types[i]||p,p] unless Page.find_by_path(p).nil? }.compact
  end

  def status_to_display
    Status.selectable.map{ |s| [I18n.translate(s.name.downcase), s.id] }
  end

  def item_type(item)
    return '' if item.parent_path.nil?
    path = item.parent_path
    pos = NewsExtension.news_paths.index(path)
    unless pos.nil? || NewsExtension.news_types[pos].nil?
      NewsExtension.news_types[pos]
    else
      path
    end
  end

  def item_status_or_date(item)
    if item.published?
      I18n.localize(item.published_at.to_date, :format =>:long)
    else
      item.status.name
    end
  end
end
