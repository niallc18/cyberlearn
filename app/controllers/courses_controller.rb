class CoursesController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:show]
  before_action :set_course, only: [:show, :edit, :update, :destroy, :approve, :revoke]
  
  def index
    @ransack_path = courses_path
    @ransack_courses = Course.approval.ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
  end
  
  def trending
    @ransack_path = trending_courses_path
    @ransack_courses = Course.where(@trending_courses).ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    render 'index'
  end
  
  def registered
    @ransack_path = registered_courses_path
    @ransack_courses = Course.joins(:admissions).where(admissions: {user: current_user}).ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    render 'index'
  end
  
  def my_courses
    @ransack_path = my_courses_courses_path
    @ransack_courses = Course.where(user: current_user).ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    render 'index'
  end
  
  def not_approved
    @ransack_path = not_approved_courses_path
    @ransack_courses = Course.not_approved.ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    render 'index'
  end

  def approve
    authorize @course, :approve?
    @course.update_attribute(:approval, true)
    redirect_to @course, notice: "Course now approved"
  end

  def revoke
    authorize @course, :approve?
    @course.update_attribute(:approval, false)
    redirect_to @course, notice: "Course has been revoked"
  end

  def show
    authorize @course
    @lessons = @course.lessons.rank(:row_order).all
    @assessments = @course.assessments
    @admissions_review = @course.admissions.has_review
  end
  
  def new
    @course = Course.new
    authorize @course
  end

  def edit
    authorize @course
  end

  def create
    @course = Course.new(course_params)
    authorize @course
    @course.user = current_user

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @course
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @course
    @course.destroy
    respond_to do |format|
      format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  private
    def set_course
      @course = Course.friendly.find(params[:id])
    end
    def course_params
      params.require(:course).permit(:title, :description, :details, :stage, :logo)
    end
end