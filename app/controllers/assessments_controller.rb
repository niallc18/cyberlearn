class AssessmentsController < ApplicationController
  before_action :set_assessment, only: %i[ show edit update destroy ]

  # GET /assessments or /assessments.json
  def index
    @assessments = Assessment.all
  end

  # GET /assessments/1 or /assessments/1.json
  def show
    authorize @assessment
    @assessments = @course.assessments
  end

  # GET /assessments/new
  def new
    @assessment = Assessment.new
    @course = Course.friendly.find(params[:course_id])
  end

  # GET /assessments/1/edit
  def edit
  end

  # POST /assessments or /assessments.json
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

  # PATCH/PUT /assessments/1 or /assessments/1.json
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

  # DELETE /assessments/1 or /assessments/1.json
  def destroy
    @assessment.destroy

    respond_to do |format|
      format.html { redirect_to course_path(@course), notice: "Assessment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assessment
      @course = Course.friendly.find(params[:course_id])
      @assessment = Assessment.friendly.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def assessment_params
      params.require(:assessment).permit(:title, :questions, :answers)
    end
end
