class HomeController < ApplicationController
  before_action :authenticate_collaborator!

  def index
  end
end