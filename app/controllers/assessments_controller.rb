class AssessmentsController < ApplicationController
  before_action :set_assessment, only: %i[ show edit update destroy ]

  def index
    @assessments = Assessment.all
  end

  def show
    authorize @assessment
    @assessments = @course.assessments
    @lessons = @course.lessons
  end

  def new
    @assessment = Assessment.new
    @course = Course.friendly.find(params[:course_id])
  end

  def edit
  end

  def create
    @assessment = Assessment.new(assessment_params)
    @course = Course.friendly.find(params[:course_id])
    @assessment.course_id = @course.id
    authorize @assessment
    respond_to do |format|
      if @assessment.save
        format.html { redirect_to course_assessment_path(@course, @assessment), notice: "Assessment was successfully created." }
        format.json { render :show, status: :created, location: @assessment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @assessment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @assessment.update(assessment_params)
        format.html { redirect_to course_assessment_path(@course, @assessment), notice: "Assessment was successfully updated." }
        format.json { render :show, status: :ok, location: @assessment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @assessment.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @assessment.destroy
    respond_to do |format|
      format.html { redirect_to course_path(@course), notice: "Assessment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_assessment
      @course = Course.friendly.find(params[:course_id])
      @assessment = Assessment.friendly.find(params[:id])
    end

    def assessment_params
      params.require(:assessment).permit(:title, :questions, :answers)
    end
end
