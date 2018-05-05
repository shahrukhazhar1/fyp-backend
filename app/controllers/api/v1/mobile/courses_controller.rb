class Api::V1::Mobile::CoursesController < ApplicationController
  before_action :verify_api_req
  
  before_action :load_course, :except => [:index, :new, :create]
  

  def index
    @courses = Course.all
    return render :status => 200, :json => { success: true, courses: @courses }
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

  

  private

    def course_params
      params.require(:course).permit :name
    end

    def load_course
      @course = Course.find_by_id params[:id]
    end
end