class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, 
                                     :photos, :invisible,
                                     :avaiable, :canceled]

  def show
  end

  def new
    @product = Product.new
    @product_categories = ProductCategory.all
  end

  def edit
    @product_categories = ProductCategory.all
  end

  def create
    @product = Product.new(product_params)
    @product.collaborator = current_collaborator

    if @product.save
      redirect_to @product, notice: 'Produto anunciado com sucesso!'
    else
      @product_categories = ProductCategory.all
      render :new
    end
  end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: 'Produto editado com sucesso!'
    else
      @product_categories = ProductCategory.all
      render :edit
    end
  end

  def search
    @products = Product.where('name LIKE ? OR description LIKE ?', "%#{params[:q]}%", "%#{params[:q]}%")
                       .where(seller_domain: current_collaborator.domain)
                       .avaiable.where.not(collaborator: current_collaborator)

    @products = @products.where(product_category_id: params[:cat]) if (params.has_key?(:cat))
  end

  def photos
  end

  ###Métodos para mudar o estado
  ###################

  def invisible
    @product.invisible!
    redirect_to @product
  end

  def avaiable
    @product.avaiable!
    @product.update(buyer_id: -1)
    redirect_to @product
  end

  def canceled
    if @product.buyer_id < 0 #Se for -1 é porque está avaiable, do contrário, tem o ID de quem está querendo comprar
      @product.canceled!
      Negotiation.where(product_id: params[:id]).waiting.each {|w| w.canceled!} #Cancela as que estavam em espera
    else
      flash[:notice] = 'Não é possível cancelar um produto que faz parte de uma negociação em andamento'
    end
    redirect_to @product
  end

  private

  def product_params
    params.require(:product)
          .permit(:name, :description, :sale_price,
                  :product_category_id, photos: [])
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
