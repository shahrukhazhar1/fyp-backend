class UserSettingsController < ApplicationController

  before_action :authenticate_user!

  def verify_quiz_queue
    device = Device.find_by_id params[:device_id]
    if device.present? && device.quizzes.present?
      return render json: true
    else
      return render json: false
    end
  end

  def check_tutorial
    if current_user.tutorial_seen.blank? && current_user.tutorial_screen == params[:step]
      return render json: false
    else
      return render json: true
    end
  end

  def update
    user = User.find_by_id params[:id]
    if user.update_attributes user_params
      flash[:success] = "Name Updated Successfuly"
    else
      flash[:error] = "Name cannot be updated"
    end
    redirect_to account_path
  end

  def unsubscribe
    current_user.send_email = false
    if current_user.save
      flash[:notice] = "You will no longer receive Weekly Email Report from Cogli"
    end
    redirect_to root_path
  end

  def tutorial_seen
    user = User.find_by_id params[:user_id]

    tutorial = UserTutorial.find_by_id params[:tutorial_id]
    tutorial.seen = true

    if params[:tutorial_seen].present?
      user.tutorial_seen  = true
    end

    user.tutorial_screen = params[:next_step]
    user.save
    tutorial.save

    return render json: true
  end

  def device_status
    if current_user.devices.count == 0 || (current_user.devices.count == 1 && !current_user.devices.first.default_device.present?)
      return render json: true
    else
      return render json: false
    end
  end


  private
  def user_params
    params.require(:user).permit!
  end

end
