class CommentsController < ApplicationController

  def create
    @product = Product.find(params[:product_id])
    @comment = @product.comments.new
    @comment.update(collaborator: current_collaborator)
    @comment.update(comment_params)
    redirect_to product_path(@product)
  end

  def show
    @comment = Comment.find(params[:id])
  end

  private

  def comment_params
    params.require(:comment)
          .permit(:text, :collaborator_id, :product_id)
          #post_date?
  end
end
