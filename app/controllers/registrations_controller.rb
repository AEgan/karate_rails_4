class RegistrationsController < ApplicationController
  before_action :set_registration, only: [:show, :edit, :update, :destroy]

  # GET /registrations
  # GET /registrations.json
  def index
    @registrations = Registration.all
  end

  # GET /registrations/1
  # GET /registrations/1.json
  def show
  end

  # GET /registrations/new
  def new
    @registration = Registration.new
    @section_options = Array.new
    Section.all.each do |sect|
      @section_options << ["#{sect.event.name}, #{rank_name(sect.min_rank)} - #{rank_name(sect.max_rank)}, #{sect.min_age} years - #{sect.max_age} years", sect.id]
    end
  end

  # GET /registrations/1/edit
  def edit
  end

  # POST /registrations
  # POST /registrations.json
  def create
    @registration = Registration.new(registration_params)
    @registration.date = Date.today
    respond_to do |format|
      if @registration.save
        format.html { redirect_to @registration, notice: 'Registration was successfully created.' }
        format.json { render action: 'show', status: :created, location: @registration }
      else
        format.html { render action: 'new' }
        format.json { render json: @registration.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /registrations/1
  # PATCH/PUT /registrations/1.json
  def update
    respond_to do |format|
      if @registration.update(registration_params)
        format.html { redirect_to @registration, notice: 'Registration was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @registration.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /registrations/1
  # DELETE /registrations/1.json
  def destroy
    @registration.destroy
    respond_to do |format|
      format.html { redirect_to registrations_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_registration
      @registration = Registration.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def registration_params
      params.require(:registration).permit(:section_id, :student_id, :date)
    end

    # gets rank name for a rank
    def rank_name(rank)
      if rank == 1
        "Tenth Gup"
      elsif rank == 2
        "Ninth Gup"
      elsif rank == 3
        "Eighth Gup"
      elsif rank == 4
        "Seventh Gup"
      elsif rank == 5
        "Sixth Gup"
      elsif rank == 6
        "Fifth Gup"
      elsif rank == 7
        "Fourth Gup"
      elsif rank == 8
        "Third Gup"
      elsif rank == 9
        "Second Gup"
      elsif rank == 10
        "First Gup"
      elsif rank == 11
        "First Dan"
      elsif rank == 12
        "Second Dan"
      elsif rank == 13
        "Third Dan"
      elsif rank == 14
        "Fourth Dan"
      else
        "Senior Master"
      end
    end
end
