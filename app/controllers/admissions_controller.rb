class AdmissionsController < ApplicationController
  before_action :set_admission, only: %i[ show edit update destroy ]
  before_action :set_coruse, only: [:new, :create]

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
    render 'index'
  end

  # GET /admissions/1 or /admissions/1.json
  def show
  end

  # GET /admissions/new
  def new
    @admission = Admission.new
  end

  # GET /admissions/1/edit
  def edit
    authorize @admission
  end

  # POST /admissions or /admissions.json
  def create
      @admission = current_user.admit_course(@course)
      redirect_to course_path(@course), notice: "Admitted"
    
  end

  # PATCH/PUT /admissions/1 or /admissions/1.json
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

  # DELETE /admissions/1 or /admissions/1.json
  def destroy
    authorize @admission
    @admission.destroy
    respond_to do |format|
      format.html { redirect_to admissions_url, notice: "Admission was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_coruse
      @course = Course.friendly.find(params[:course_id])
    end
    
    def set_admission
      @admission = Admission.friendly.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def admission_params
      params.require(:admission).permit(:rating, :review)
    end
end
