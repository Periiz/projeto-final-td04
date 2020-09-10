class HomeController < ApplicationController
  before_action :authenticate_collaborator!

  def index
    @product_selection = Product.where(seller_domain: current_collaborator.domain)
                                .where.not(collaborator: current_collaborator)
                                .avaiable.last(3)
  end
end
