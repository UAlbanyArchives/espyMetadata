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
        @icpsr_records = IcpsrRecord.all.where(limiter).order("id ASC")
      end
    else
      @icpsr_records = IcpsrRecord.none
    end
  end
  
  # GET /dedup
  # GET /dedup.json
  def dedup
    if params[:state]
      if params[:state] == "*"
        @icpsr_records = IcpsrRecord.all
      else
        limiter = "state_abbreviation = '" + params[:state].upcase + "'"
        @records = IcpsrRecord.all.where(limiter)
        
        dups = []
        dates = []
        @records.each do |record|
            if dates.include?(record.date_execution)
                dups << record.id
            else
                dates << record.date_execution
            end
        
        end

        #@icpsr_records = dups
        @icpsr_records = IcpsrRecord.find(dups)
        #@icpsr_records = IcpsrRecord.none
        #@icpsr_records = IcpsrRecord.all.where(limiter)
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

  def reindex

    #Rake::Task['search_suggestions:add'].invoke
    IcpsrRecord.where(:icpsr_id => nil).each do |record|
      name = record.name
      puts name
      state = record.state_abbreviation
      date = record.date_execution.to_s
      1.upto(name.length) do |n|
        prefix = name[0, n]
        $redis.zadd 'search-suggestions:' + prefix.downcase, record.icpsr_id, name.downcase + " - " + state
      end
      1.upto(date.length) do |n|
        prefix = date[0, n]
        $redis.zadd 'search-suggestions:' + prefix.downcase, record.icpsr_id, date + " - " + name.downcase + " - " + state
      end
    end

    redirect_to "/icpsr_records"
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

  def remove_link
    @ref = Reference.find(params[:ref])
    @ref.used_check = false
    @ref.save
    IcpsrRecord.find(params[:id]).references.delete(@ref)
    respond_to do |format|
      format.html { redirect_to "/icpsr_records/" + params[:id].to_s + "/edit", notice: 'Reference Link was Removed.' }
    end
  end

  # PATCH/PUT /icpsr_records/1
  # PATCH/PUT /icpsr_records/1.json
  def update
    respond_to do |format|
      #if @icpsr_record.big_id.to_s != icpsr_record_params[:big_id].to_s
      #  @big_card = BigCard.find(@icpsr_record.big_id.to_i)
      #  @big_card.update_attribute :used_check, false
      #end
      if @icpsr_record.update(icpsr_record_params)
        format.html { redirect_to @icpsr_record, notice: 'Icpsr record was successfully updated. Any linked big cards were marked unused.' }
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
    if not @icpsr_record.big_id.blank?
      @big_card = BigCard.find(@icpsr_record.big_id)
      @big_card.update_attribute :used_check, false
    end
    @icpsr_record.references.each do |refLink|
      @ref = Reference.find(refLink.id)
      @ref.used_check = false
      @ref.save
    end
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
      params.require(:icpsr_record).permit(:used_check, :icpsr_id, :name, :date_execution, :age, :race, :sex, :occupation, :crime, :execution_method, :location_execution, :jurisdiction, :state, :state_abbreviation, :county_code, :county_name, :compensation_case, :icpsr_state, :big_id, :ref_id)
    end
end
