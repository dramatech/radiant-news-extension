require File.expand_path("../../spec_helper", __FILE__)

describe "News Tags" do
  dataset :news

  let(:page){ pages(:home) }
  let(:news){ pages(:news_item)}

  describe "<r:if_news>" do
    it "should render the contained block if the page is a NewsPage" do
      news.should render('<r:if_news>true</r:if_news>').as('true')
    end

    it "should not render the contained block if the page is not a NewsPage" do
      page.should render('<r:if_news>true</r:if_news>').as('')
    end
  end


  describe "<r:unless_news>" do
    it "should not render the contained block if the page is a NewsPage" do
      news.should render('<r:unless_news>true</r:unless_news>').as('')
    end

    it "should render the contained block if the page is not a NewsPage" do
      page.should render('<r:unless_news>true</r:unless_news>').as('true')
    end
  end
end
