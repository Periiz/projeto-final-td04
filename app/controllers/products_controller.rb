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
    if @product.valid?
      @product.save
      redirect_to @product, notice: 'Produto anunciado com sucesso!'
    else
      @product_categories = ProductCategory.all
      render :new
    end
  end

  private

  def product_params
    params.require(:product)
          .permit(:name,:product_category_id,
                  :description, :sale_price)
  end
end