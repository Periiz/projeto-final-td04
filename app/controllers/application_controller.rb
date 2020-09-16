class ApplicationController < ActionController::Base
    before_action :authenticate_collaborator!
end
