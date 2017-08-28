class IcpsrRecordsController < ApplicationController
  before_action :set_icpsr_record, only: [:show, :edit, :update, :destroy]

  # GET /icpsr_records
  # GET /icpsr_records.json
  def index
    if params[:state]
      if params[:state] == "*"
        @icpsr_records = IcpsrRecord.all
      else
        limiter = "state_abbreviation = '" + params[:state].upcase + "'"
        @icpsr_records = IcpsrRecord.all.where(limiter)
      end
    else
      @icpsr_records = IcpsrRecord.none
    end
  end

  # GET /icpsr_records/1
  # GET /icpsr_records/1.json
  def show
    @icpsr_record = IcpsrRecord.find(params[:id])
    respond_to do |format|

    format.html # show.html.erb
    format.json { render json: @icpsr_record }

   end
  end

  # GET /icpsr_records/new
  def new
    @icpsr_record = IcpsrRecord.new
  end

  # GET /icpsr_records/1/edit
  def edit
  end

  def find
    render json: IcpsrRecord.find(params[:id])
  end

  # POST /icpsr_records
  # POST /icpsr_records.json
  def create
    @icpsr_record = IcpsrRecord.new(icpsr_record_params)

    respond_to do |format|
      if @icpsr_record.save
        format.html { redirect_to @icpsr_record, notice: 'Icpsr record was successfully created.' }
        format.json { render :show, status: :created, location: @icpsr_record }
      else
        format.html { render :new }
        format.json { render json: @icpsr_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /icpsr_records/1
  # PATCH/PUT /icpsr_records/1.json
  def update
    respond_to do |format|
      if @icpsr_record.update(icpsr_record_params)
        format.html { redirect_to @icpsr_record, notice: 'Icpsr record was successfully updated.' }
        format.json { render :show, status: :ok, location: @icpsr_record }
      else
        format.html { render :edit }
        format.json { render json: @icpsr_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /icpsr_records/1
  # DELETE /icpsr_records/1.json
  def destroy
    @icpsr_record.destroy
    respond_to do |format|
      format.html { redirect_to icpsr_records_url, notice: 'Icpsr record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_icpsr_record
      @icpsr_record = IcpsrRecord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def icpsr_record_params
      params.require(:icpsr_record).permit(:used_check, :icpsr_id, :name, :date_execution, :age, :race, :sex, :occupation, :crime, :execution_method, :location_execution, :jurisdiction, :state, :state_abbreviation, :county_code, :county_name, :compensation_case, :icpsr_state)
    end
end
