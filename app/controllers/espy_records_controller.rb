class EspyRecordsController < ApplicationController
  before_action :set_espy_record, only: [:show, :edit, :update, :destroy]

  # GET /espy_records
  # GET /espy_records.json
  def index
    @espy_records = EspyRecord.all
  end

  # GET /espy_records/1
  # GET /espy_records/1.json
  def show
  end

  # GET /espy_records/make
  def make
    @index_card = IndexCard.all
  end

  # GET /espy_records/new
  def new
    @espy_record = EspyRecord.new
    @index_card = IndexCard.all
  end

  # GET /espy_records/1/edit
  def edit
  end

  # POST /espy_records
  # POST /espy_records.json
  def create
    @espy_record = EspyRecord.new(espy_record_params)

    respond_to do |format|
      if @espy_record.save
        format.html { redirect_to @espy_record, notice: 'Espy record was successfully created.' }
        format.json { render :show, status: :created, location: @espy_record }
      else
        format.html { render :new }
        format.json { render json: @espy_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /espy_records/1
  # PATCH/PUT /espy_records/1.json
  def update
    respond_to do |format|
      if @espy_record.update(espy_record_params)
        format.html { redirect_to @espy_record, notice: 'Espy record was successfully updated.' }
        format.json { render :show, status: :ok, location: @espy_record }
      else
        format.html { render :edit }
        format.json { render json: @espy_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /espy_records/1
  # DELETE /espy_records/1.json
  def destroy
    @espy_record.destroy
    respond_to do |format|
      format.html { redirect_to espy_records_url, notice: 'Espy record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_espy_record
      @espy_record = EspyRecord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def espy_record_params
      params.require(:espy_record).permit(:uuid, :icpsr_record, :icpsr_record_id, :index_card, :index_card_id, :index_card_files, :big_card, :big_card_id, :big_card_files, :reference_material, :reference_material_id, :reference_material_files, :ocr_text, :icpsr_id, :name, :date_crime, :circa_date_crime, :date_execution, :circa_date_execution, :age, :race, :sex, :occupation, :crime, :execution_method, :location_execution, :jurisdiction, :state, :state_abbreviation, :county_code, :county_name, :compensation_case, :icpsr_state)
    end
end
