class Api::V1::CoursesController < ApplicationController

  before_action :authenticate_quiz_or_admin_from_token!

  before_action :load_course, :except => [:index, :new, :create]


  def destroy
    if @course.present? && @course.destroy
      return render :status => 200, :json => { success: true }
    else
      retrun render :status => 200, :json => { success: false }
    end
  end
  
  def index
    @courses = Course.all
    return render :status => 200, :json => { success: true, courses: @courses }
  end

  def new
    @course = Course.new
  end
  
  def create    
    if params[:course].is_a?(String)
      params[:course] = eval params[:course]
    end
    
    @course = Course.new(course_params)
    if @course.save
      return render :status => 200, :json => { success: true, course: @course }
    else
      error_message = ""
      i = 0
      e = @course.errors.messages[:name]
      if e
        0.upto(0) do |m|
          error_message = error_message + "Name " + e[m] + "\n"
          i += 1
        end
      end
      if i == 0
        error_message = "Error in creating course."
      end
      return render json: { error: error_message.to_json, status: 403 }
    end
  end

  def update
    if params[:course].is_a?(String)
      params[:course] = eval params[:course]
    end

    if @course.update(course_params)
      return render :status => 200, :json => { success: true, course: @course }
    else
      return render :status => 400, :json => { success: false}
    end
  end


  def show
    render :status => 200, :json => { success: true, course: @course }
  end

  def edit
    render :status => 200, :json => { success: true, course: @course }
  end

  
  private

    def course_params
      params.require(:course).permit :name, :attachment, :attachment2, :support
    end

    def load_course
      @course = Course.find_by_id params[:id]
    end
end
