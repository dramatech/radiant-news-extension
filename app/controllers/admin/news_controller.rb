class Admin::NewsController < Admin::NewsResourceController
  model_class NewsPage
  only_allow_access_to :index, :new, :edit, :create, :update, :destroy,
    :when => [:designer, :admin],
    :denied_url => { :controller => 'pages', :action => 'index' },
    :denied_message => 'You must have designer or administrator privileges to edit the news.'
  
  private
  
  def edit_model_path
    edit_admin_news_path(params[:id])
  end
end
