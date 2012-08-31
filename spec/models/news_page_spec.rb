require File.expand_path("../../spec_helper", __FILE__)

describe NewsPage do
  dataset :news

  let(:news){ pages(:news_item)}  

  subject{ news }
  its(:cache?) { should be_true }
  its(:news?) { should be_true }
  its(:virtual?) { should be_false }
  its(:layout) { should be_nil }

  describe '.new_with_defaults' do
    describe '#parts' do
      let(:parts){ NewsPage.new_with_defaults.parts }
      subject{ parts }
      its(:length) { should == 1 }
      it "should have a body part" do
        parts[0].name.should == 'body'
      end
    end
    describe '#fields' do
      let(:fields){ NewsPage.new_with_defaults.fields }
      subject{ fields }
      its(:length) { should == 1 }
      it "should have a `Description' field" do
        fields[0].name.should == 'Description'
      end
    end
  end

  describe '#digest' do
    it 'should return an md5 hash of the rendered contents' do
      news.digest.should == Digest::MD5.hexdigest(news.render)
    end
  end

  context 'when validating a new page' do
    it "should automatically set the slug to the given title" do
      i = NewsPage.new(:title => 'News Page')
      i.valid?
      i.slug.should == 'news-page'
    end
    it "should automatically set the breadcrumb to the given title" do
      i = NewsPage.new(:title => 'News Page')
      i.valid?
      i.breadcrumb.should == 'News Page'
    end
  end

  context 'when saving a new page' do
    subject { s = NewsPage.new_with_defaults
        s.title = 'News Page'
        s.save!
        s }
    
    context 'with the default page status set to published' do
      it 'should save a new page with a published status' do
        Radiant::Config['defaults.page.status'] = 'published'
        new_sheet = NewsPage.new_with_defaults
        new_sheet.title = 'Published News'
        new_sheet.save!
        new_sheet.status.should == Status[:published]
      end
    end
  end
end
