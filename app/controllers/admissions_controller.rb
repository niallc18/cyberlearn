class AdmissionsController < ApplicationController
  before_action :set_admission, only: %i[ show edit update destroy ]
  before_action :set_course, only: [:new, :create]

  # GET /admissions or /admissions.json
  def index
    @ransack_path = admissions_path
    @q = Admission.ransack(params[:q])
    @pagy, @admissions = pagy(@q.result.includes(:user))
    authorize @admissions
  end
  
  def admitted_students
    @ransack_path = admitted_students_admissions_path
    @q = Admission.joins(:course).where(courses: {user: current_user}).ransack(params[:q])
    @pagy, @admissions = pagy(@q.result.includes(:user))
    render "index"
  end

  def show
  end

  def new
    @admission = Admission.new
  end

  def edit
    authorize @admission
  end

  def create
      @admission = current_user.admit_course(@course)
      redirect_to course_path(@course), notice: "Successfully Admitted"
    
  end

  def update
    authorize @admission
    respond_to do |format|
      if @admission.update(admission_params)
        format.html { redirect_to admission_url(@admission), notice: "Admission was successfully updated." }
        format.json { render :show, status: :ok, location: @admission }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admission.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @admission
    @admission.destroy
    respond_to do |format|
      format.html { redirect_to admissions_url, notice: "Admission was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_course
      @course = Course.friendly.find(params[:course_id])
    end
    
    def set_admission
      @admission = Admission.friendly.find(params[:id])
    end

    def admission_params
      params.require(:admission).permit(:rating, :review)
    end
end
