class MessagesController < ApplicationController
  before_action :authenticate_collaborator!

  def create
    @negotiation = Negotiation.find(params[:negotiation_id])
    @message = @negotiation.messages.new
    @message.update(collaborator: current_collaborator)
    @message.update(message_params)
    redirect_to negotiation_path(@negotiation)
  end

  def show
    @message = Message.find(params[:id])
  end

  private

  def message_params
    params.require(:message)
          .permit(:text, :collaborator_id, :negotiation_id)
  end
end