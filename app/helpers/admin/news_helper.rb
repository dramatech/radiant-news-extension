# encoding: utf-8
module Admin::NewsHelper
  def news_type_options_for_select(selected=nil)
    NewsExtension.news_paths.each_with_index.map{ |p,i| [page_type(p),p] }.compact
  end

  def status_to_display
    Status.selectable.map{ |s| [I18n.translate(s.name.downcase), s.id] }
  end

  def page_type(path)
    page = Page.find_by_path(path)
    unless page.nil?
      breadcrumbs = [page.breadcrumb]
      page.ancestors.each do |ancestor|
        breadcrumbs.unshift(ancestor.breadcrumb)
      end
      breadcrumbs.join(" » ")
    else
      path
    end
  end

  def item_type(item)
    unless item.parent.breadcrumb.empty?
      item.parent.breadcrumb
    else
      item.parent_path
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
