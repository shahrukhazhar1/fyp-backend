class Api::V1::DevicesController < Api::V1::ApiController

  def index
    @devices = current_user.devices.order 'created_at DESC'
  end

  def set_installed_apps
    @device = Device.find_by_id params[:id]
    @device.install_apps = params[:app_list].map do |app|
      InstallApp.new(app_name: app["app_name"], package_name: app["package_name"], block_status: app["block_status"])
    end
    fresh_when @device
  end

  def show
    @device = Device.includes(:emergency_numbers, :quizzes => [:grades, :questions => :answers])
      .where(user_id: current_user.id).order('quiz_selections.priority').find(params[:id])
    fresh_when @device
  end

  def show_device
    @device = Device.includes(:emergency_numbers, :quizzes => [:grades, :questions => :answers])
      .where(user_id: current_user.id).order('quiz_selections.priority').find(params[:id])
    if @device.device_id.present? && @device.device_id == params[:device_id]
      fresh_when @device
    else
      head :unprocessable_entity
    end
  end

  def subscription_date
    @device = Device.find_by_id params[:id]
    if @device.present? && @device.device_id == params[:device_id]
      fresh_when @device
    else
      render json: {status: 500, error: "Subscription not found for this device" }
      # head :unprocessable_entity
    end
  end

  def update
    @device = current_user.devices.find params[:id]
    if params[:device_id].present? && @device.update_attributes(fcm_token: params[:fcm_token], device_id: params[:device_id])
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def update_fcm_token
    @device = current_user.devices.find params[:id]
    if @device.present? && @device.update_attributes(fcm_token: params[:fcm_token])
      render json: {status: 200, success: true }
    else
      render json: {status: 500, success: false }
    end
  end

  def toggle
    @device = current_user.devices.find params[:id]
    if params[:block_type] == "1"
      @device.update_attributes(is_enabled: params[:block_status])
      render json: {status: 200, success: true }
    elsif params[:block_type] == "0"
      app = @device.install_apps.find_by_package_name params[:package_name]
      app.update_attributes(block_status: params[:block_status])
      render json: {status: 200, success: true }
    else
      render json: {status: 500, success: false }
    end

  end

  def installed_apps
    @device = current_user.devices.find params[:id]
    if @device.present?
      render status: 200, json: {installed_apps: @device.install_apps }
    else
      render head: 404
    end
    
  end

end
