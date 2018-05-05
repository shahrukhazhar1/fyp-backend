class EmergencyNumbersController < ApplicationController
  before_action :authenticate_user!, :load_device
  before_action :load_emergency_number, :only => [:edit, :update, :destroy]
  before_action :verify_tutorial

  def verify_tutorial
    redirect_tutorial_for!(nil)
  end

  def index
    @emergency_numbers = [
      EmergencyNumber.new({
        name: 'Emergency Services',
        phone_number: 911
      })
    ]
    @emergency_numbers += @device.emergency_numbers.order('created_at DESC')
  end

  def new
    @emergency_number = EmergencyNumber.new
  end

  def create
    @emergency_number = @device.emergency_numbers.build(emergency_number_params)
    if @emergency_number.save
      flash[:success] = 'Emergency Number created successfully.'
      redirect_to device_emergency_numbers_path
    else
      render :new
    end
  end

  def edit

  end

  def update
    if @emergency_number.update emergency_number_params
      flash[:success] = 'Emergency Number updated successfully.'
      redirect_to device_emergency_numbers_path
    else
      render :edit
    end
  end

  def destroy
    if @emergency_number.destroy
      flash[:success] = 'Emergency Number deleted successfully.'
    else
      flash[:error] = 'Could not delete Emergency Number for some reason. Try again later.'
    end
    redirect_to device_emergency_numbers_path
  end

  private

    def load_device
      @device = current_user.devices.find params[:device_id]
    end

    def emergency_number_params
      params.require(:emergency_number).permit :name, :phone_number
    end

    def load_emergency_number
      @emergency_number = @device.emergency_numbers.find params[:id]
    end

end
