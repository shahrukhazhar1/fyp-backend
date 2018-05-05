class Api::V1::ApiController < ApplicationController

  protect_from_forgery with: :null_session

  rescue_from ActiveRecord::RecordNotFound, with: :recrod_not_found

  acts_as_token_authentication_handler_for User


  private

    def recrod_not_found
      render :json => { :message => 'The page/record you are looking for does not exist.' }, :status => :not_found
    end

end
