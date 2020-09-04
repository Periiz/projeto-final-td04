class ProductsController < ApplicationController
  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
    @product_categories = ProductCategory.all
  end

  def create
    @product = Product.new(product_params)
    @product.collaborator = current_collaborator
    @product.seller_domain = current_collaborator.domain

    if @product.valid?
      @product.save
      redirect_to @product, notice: 'Produto anunciado com sucesso!'
    else
      @product_categories = ProductCategory.all
      render :new
    end
  end

  def search
    @products = Product.where('name LIKE ? OR description LIKE ?', "%#{params[:q]}%", "%#{params[:q]}%")
                       .where('seller_domain = ?', current_collaborator.domain)
                       .where(status: :avaiable).where('collaborator_id != ?', current_collaborator.id)
    if (params.has_key?(:cat))
      @products = @products.where('product_category_id = ?', params[:cat])
    end
    render search_products_path
  end

  private

  def product_params
    params.require(:product)
          .permit(:name,:product_category_id,
                  :description, :sale_price)
  end
end
