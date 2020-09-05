class HomeController < ApplicationController
  before_action :authenticate_collaborator!

  def index
    @product_selection = Product.where('seller_domain = ?', current_collaborator.domain)
                                .where('collaborator_id != ?', current_collaborator.id)
                                .where(status: :avaiable).last(3)
  end
end
