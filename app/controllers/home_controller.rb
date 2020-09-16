class HomeController < ApplicationController

  def index
    if params[:q]
      @product_selection = Product.where(seller_domain: current_collaborator.domain)
                                  .where.not(collaborator: current_collaborator)
                                  .where(product_category_id: params[:q])
                                  .avaiable.last(3)
    else
      @product_selection = Product.where(seller_domain: current_collaborator.domain)
                                .where.not(collaborator: current_collaborator)
                                .avaiable.last(3)
    end
  end
end
