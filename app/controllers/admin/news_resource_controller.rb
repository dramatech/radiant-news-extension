class Admin::NewsResourceController < Admin::ResourceController
  paginate_models
  # only_allow_access_to must be set
 
  def new
    self.model = model_class.new_with_defaults
    response_for :new
  end

  def create
    model.update_attributes!(params[model_symbol])
    response_for :create
  end
  
end
