class Api::V1::LabelsController < ApplicationController

  before_action :authenticate_quiz_or_admin_from_token!

  before_action :load_label, :except => [:index, :new, :create]


  def destroy
    if @label.present? && @label.destroy
      return render :status => 200, :json => { success: true }
    else
      retrun render :status => 200, :json => { success: false }
    end
  end
  
  def index
    @labels = Label.all
    return render :status => 200, :json => { success: true, labels: @labels }
  end

  def new
    @label = Label.new
  end
  
  def create    
    if params[:label].is_a?(String)
      params[:label] = eval params[:label]
    end
    
    @label = Label.new(label_params)
    if @label.save
      return render :status => 200, :json => { success: true, label: @label }
    else
      error_message = ""
      i = 0
      e = @label.errors.messages[:name]
      if e
        0.upto(0) do |m|
          error_message = error_message + "Name " + e[m] + "\n"
          i += 1
        end
      end
      if i == 0
        error_message = "Error in creating Label."
      end
      return render json: { error: error_message.to_json, status: 403 }
    end
  end

  def update
    if params[:label].is_a?(String)
      params[:label] = eval params[:label]
    end

    if @label.update(label_params)
      return render :status => 200, :json => { success: true, label: @label }
    else
      return render :status => 400, :json => { success: false}
    end
  end


  def show
    render :status => 200, :json => { success: true, label: @label }
  end

  def edit
    render :status => 200, :json => { success: true, label: @label }
  end

  

  private

    def label_params
      params.require(:label).permit :name
    end

    def load_device
      @device = current_user.devices.find params[:device_id]
    end

    def load_label
      @label = Label.find_by_id params[:id]
    end
end
