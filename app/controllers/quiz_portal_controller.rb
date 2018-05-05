class QuizPortalController < ApplicationController
	before_action :authenticate_quiz_user!, only: [:quiz_user_account]
	def quiz_user_account
	end

	def check_quiz_user_email
    puts "Params quiz user"*50
    puts params
    if params[:quiz_user].is_a?(String)
      params[:quiz_user] = eval params[:quiz_user]  
    end
    if params[:quiz_user][:email].present?
      email = QuizUser.where(email: params[:quiz_user][:email]).last
      if email.present?
        result = false
      else
        result = true
      end
      return render :status => 200, :json => { success: result }
    else
      return render :status => 200, :json => { success: true }
    end
  end
end