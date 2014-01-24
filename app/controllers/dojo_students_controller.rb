class DojoStudentsController < ApplicationController
  before_action :set_dojo_student, only: [:show, :edit, :update, :destroy]

  # GET /dojo_students
  # GET /dojo_students.json
  def index
    @dojo_students = DojoStudent.all
  end

  # GET /dojo_students/1
  # GET /dojo_students/1.json
  def show
  end

  # GET /dojo_students/new
  def new
    @dojo_student = DojoStudent.new
  end

  # GET /dojo_students/1/edit
  def edit
  end

  # POST /dojo_students
  # POST /dojo_students.json
  def create
    @dojo_student = DojoStudent.new(dojo_student_params)

    respond_to do |format|
      if @dojo_student.save
        format.html { redirect_to @dojo_student, notice: 'Dojo student was successfully created.' }
        format.json { render action: 'show', status: :created, location: @dojo_student }
      else
        format.html { render action: 'new' }
        format.json { render json: @dojo_student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dojo_students/1
  # PATCH/PUT /dojo_students/1.json
  def update
    respond_to do |format|
      if @dojo_student.update(dojo_student_params)
        format.html { redirect_to @dojo_student, notice: 'Dojo student was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @dojo_student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dojo_students/1
  # DELETE /dojo_students/1.json
  def destroy
    @dojo_student.destroy
    respond_to do |format|
      format.html { redirect_to dojo_students_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dojo_student
      @dojo_student = DojoStudent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dojo_student_params
      params.require(:dojo_student).permit(:student_id, :dojo_id, :start_date, :end_date)
    end
end
