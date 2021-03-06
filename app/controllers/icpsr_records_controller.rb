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
        
        unknownDates = []
        dups = []
        dates = []
        @records.each do |record|
            if dates.include?(record.date_execution)
                dups << record.id
            elsif record.name.downcase.include? "unknown" || record.name.blank?
                if unknownDates.include?(record.date_execution)
                    dups << record.id
                end
                unknownDates << record.date_execution
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
  
  # GET /combine
  # GET /combine.json
  def combine
    @to = IcpsrRecord.find(params[:combineTo])
    @from = IcpsrRecord.find(params[:combineFrom])
    @state = @to.state_abbreviation
    
    if @to.big_id != @from.big_id
        unless @to.big_id.nil? || @from.big_id.nil?
            respond_to do |format|
                format.html { redirect_to '/icpsr_records', notice: 'ERROR: cannot combine with different big cards.' }
            end
        end
        if @to.big_id.nil?
            @to.big_id = @from.big_id
        end
    end
    
    @from.references.each do |ref|
        unless @to.references.include? ref
            @to.references << ref
        end
    end
    toID = @to.id.to_s
    fromID = @from.id.to_s
    
    espyTo = EspyRecord.where("icpsr_record_id": @to.id)
    espyFrom = EspyRecord.where("icpsr_record_id": @from.id)
    
    if espyTo.count == 0 and espyFrom.count == 0
        @from.deleted = true
        @to.save
        @from.save        
        respond_to do |format|
            format.html { redirect_to '/icpsr_records', notice: 'Records were successfully combined.' }
        end
    elsif espyTo.count == 1 and espyFrom.count == 0
        espyToID = espyTo[0].id.to_s
    
        refs = []
        @to.references.each do |ref|
            unless refs.include? ref
                refs << ref
            end
        end
        @from.references.each do |ref|
            unless refs.include? ref
                refs << ref
            end
        end
        idList = []
        fileList = []
        refs.each do |ref|
            idList << ref.id
            fileList << ref.filename
        end
        espyTo[0].reference_material_id = idList.join("; ")
        espyTo[0].reference_material_files = fileList.join("; ")
        espyTo[0].save
        
        @from.deleted = true
        @to.save
        @from.save        
        respond_to do |format|
            format.html { redirect_to '/espy_records/' + espyTo[0].id.to_s + "/edit", notice: 'Records were successfully combined, be sure to review existing Espy Record.' }
        end
        
    elsif espyTo.count == 0 and espyFrom.count == 1
       espyFromID = espyFrom[0].id.to_s
       
       espyTo[0].icpsr_record = true
       espyTo[0].icpsr_record_id = @to.id
       refs = []
        @to.references.each do |ref|
            unless refs.include? ref
                refs << ref
            end
        end
        @from.references.each do |ref|
            unless refs.include? ref
                refs << ref
            end
        end
        idList = []
        fileList = []
        refs.each do |ref|
            idList << ref.id
            fileList << ref.filename
        end
        espyTo[0].reference_material_id = idList.join("; ")
        espyTo[0].reference_material_files = fileList.join("; ")
        espyTo[0].save
        
        @from.deleted = true
        @to.save
        @from.save        
        respond_to do |format|
            format.html { redirect_to '/espy_records/' + espyTo[0].id.to_s + "/edit", notice: 'Records were successfully combined, be sure to review existing Espy Record.' }
        end
        
    else
        respond_to do |format|
            format.html { redirect_to '/icpsr_records', notice: 'ERROR: Did nothing, as both Icpsr records (' + toID + ' & ' + fromID + ') have been made into Espy Records (' + espyTo[0].id.to_s + ' & ' + espyFrom[0].id.to_s + ').' }
        end
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
      params.require(:icpsr_record).permit(:used_check, :icpsr_id, :combineTo, :combineFrom, :name, :date_execution, :age, :race, :sex, :occupation, :crime, :execution_method, :location_execution, :jurisdiction, :state, :state_abbreviation, :county_code, :county_name, :compensation_case, :icpsr_state, :big_id, :ref_id)
    end
end
