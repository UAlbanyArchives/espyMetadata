class EspyRecordsController < ApplicationController
  before_action :set_espy_record, only: [:show, :edit, :update, :destroy]

  # GET /espy_records
  # GET /espy_records.json
  def index
    if params[:state]
      if params[:state] == "*"
        @espy_records = EspyRecord.all
      else
        limiter = "state_abbreviation = '" + params[:state].upcase + "'"
        @espy_records = EspyRecord.all.where(limiter)
      end
    else
      @espy_records = EspyRecord.none
    end
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
        if @espy_record.icpsr_id.blank?
          @espy_record.update_attribute :icpsr_record, false
          @espy_record.update_attribute :icpsr_record_id, nil
        else
          @espy_record.update_attribute :icpsr_record, true
        end

        if @espy_record.index_card == true
          @index_card = IndexCard.find(@espy_record.index_card_id)
          @index_card.update_attribute :used_check, true
        end
        if @espy_record.icpsr_record == true
          @icpsr_record = IcpsrRecord.find(@espy_record.icpsr_record_id)
          @icpsr_record.update_attribute :used_check, true
        end

        format.html { redirect_to '/make?state=' + @espy_record.state_abbreviation }
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
        if @espy_record.icpsr_id.blank?
          @espy_record.update_attribute :icpsr_record, false
          @espy_record.update_attribute :icpsr_record_id, nil
        else
          @espy_record.update_attribute :icpsr_record, true
          @find_id = IcpsrRecord.find_by_icpsr_id(@espy_record.icpsr_id)
          @espy_record.update_attribute :icpsr_record_id, @find_id.id
        end
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

      if @espy_record.icpsr_record == true
        @icpsr_record = IcpsrRecord.find(@espy_record.icpsr_record_id)
        @icpsr_record.update_attribute :used_check, false
      end
      if @espy_record.index_card == true
        @index_card = IndexCard.find(@espy_record.index_card_id)
        @index_card.update_attribute :used_check, false
      end

      format.html { redirect_to espy_records_url + "?state=" + @espy_record.state_abbreviation, notice: 'Espy record was successfully destroyed. Any linked index cards or Icpsr records were marked as unused.' }
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
      params.require(:espy_record).permit(:uuid, :record_type, :icpsr_record, :icpsr_record_id, :index_card, :index_card_id, :index_card_files, :index_card_aspace, :big_card, :big_card_id, :big_card_files, :big_card_aspace, :reference_material, :reference_material_id, :reference_material_files, :reference_material_aspace, :ocr_text, :ocr_fixed, :icpsr_id, :first_name, :last_name, :date_crime, :circa_date_crime, :date_execution, :circa_date_execution, :age, :race, :sex, :occupation, :crime, :execution_method, :location_execution, :jurisdiction, :state, :state_abbreviation, :county_code, :county_name, :compensation_case, :icpsr_state, :date_crime_source_icpsr, :date_crime_source_index, :date_crime_source_big,:date_crime_source_ref,:date_execution_source_icpsr,:date_execution_source_index,:date_execution_source_big,:date_execution_source_ref,:age_source_icpsr,:age_source_index,:age_source_big,:age_source_ref,:race_source_icpsr,:race_source_index,:race_source_big,:race_source_ref,:sex_source_icpsr,:sex_source_index,:sex_source_big,:sex_source_ref,:crime_source_icpsr,:crime_source_index,:crime_source_big,:crime_source_ref,:execution_method_source_icpsr,:execution_method_source_index,:execution_method_source_big,:execution_method_source_ref,:county_source_icpsr,:county_source_index,:county_source_big,:county_source_ref, :big_ocr, :big_ocr_check, :name_source_icpsr,:name_source_index,:name_source_big,:name_source_ref)
    end
end
