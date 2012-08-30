module NewsTags
  include Radiant::Taggable
  class TagError < StandardError; end

  desc %{
Renders the contents of the tag if the page is a news page.

*Usage:*

<pre><code><r:if_news>This is a news page</r:if_news>
</code></pre>
  }
  tag 'if_news' do |tag|
    tag.expand if tag.locals.page.is_a?(News::Instance)
  end

  desc %{
Renders the contents of the tag if the page is not a news page.

*Usage:*

<pre><code><r:unless_news>This is not a news page</r:unless_news>
</code></pre>
  }
  tag 'unless_news' do |tag|
    tag.expand unless tag.locals.page.is_a?(News::Instance)
  end
end
