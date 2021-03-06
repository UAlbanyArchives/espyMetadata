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
        @espy_records = EspyRecord.all.where(limiter).order("id ASC")
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

  # GET /espy_records/dedupe
  def dedupe
    if params[:state]
      if params[:state] == "*"
        @recs = EspyRecord.all
      else
        limiter = "state_abbreviation = '" + params[:state].upcase + "'"
        @recs = EspyRecord.all.where(limiter).order("id ASC")
      end
    else
      @recs = EspyRecord.none
    end
    @dupes = []
    @previous = {}
    @recs.each do |rec|
      @name = rec.first_name.strip + " " + rec.last_name.strip
      if @name.strip.empty? || @name.nil?
        if @previous.key?(rec.date_execution)
          unless @dupes.include? @previous[rec.date_execution][0]
            @dupes << @previous[rec.date_execution][0]
          end
          @dupes << rec.id
        else
          @previous[rec.date_execution] = [rec.id, rec.date_execution]
        end
      else
        if @previous.key?(@name)
          unless @dupes.include? @previous[@name][0]
            @dupes << @previous[@name][0]
          end
          @dupes << rec.id
        else
          @previous[@name] = [rec.id, rec.date_execution]
        end
      end
    end
    @espy_records = @dupes.collect {|i| EspyRecord.where(:id => i) }.flatten
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

        if @espy_record.index_card == true
          @index_card = IndexCard.find(@espy_record.index_card_id)
          @index_card.update_attribute :used_check, true
        end
        
        unless @espy_record.icpsr_record_id.nil?
          @icpsr_record = IcpsrRecord.find(@espy_record.icpsr_record_id)
          @icpsr_record.update_attribute :used_check, true
        end

        if @espy_record.index_card == true
          format.html { redirect_to '/make?state=' + @espy_record.state_abbreviation }
        else
          #format.html { redirect_to '/icpsr_records?state=' + @espy_record.state_abbreviation }
          # just so its faster
          format.html { redirect_to '/icpsr_records' }
        end
        format.json { render :show, status: :created, location: @espy_record }
      else
        format.html { render :new }
        format.json { render json: @espy_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /combine
  # GET /combine.json
  def combine
    @to = EspyRecord.find(params[:combineTo])
    @from = EspyRecord.find(params[:combineFrom])
    @state = @to.state_abbreviation
    @error_switch = false

    unless params[:combineTo] != params[:combineFrom]
      respond_to do |format|
        @error_switch = true
        format.html { redirect_to '/dedupe?state=' + @state, notice: 'ERROR: cannot combine refs for the same record.' }
      end
    else

      if @to.icpsr_record_id != @from.icpsr_record_id
          unless @to.icpsr_record_id.nil? || @from.icpsr_record_id.nil?
              respond_to do |format|
                @error_switch = true
                format.html { redirect_to '/dedupe?state=' + @state, notice: 'ERROR: cannot combine with different ICPSR Record IDs.' }
              end
          else
            if @to.icpsr_record_id.nil?
                @to.icpsr_record_id = @from.icpsr_record_id
            end
            if @from.icpsr_record_id.nil?
              @from.icpsr_record_id = @to.icpsr_record_id
            end
          end
      end

      if @from.index_card
        @to.index_card = true
      end
      if @to.index_card
        @from.index_card = true
      end
      if @to.index_card_id != @from.index_card_id
        unless @to.index_card_id.nil? || @from.index_card_id.nil?
            respond_to do |format|
                @error_switch = true
                format.html { redirect_to '/dedupe?state=' + @state, notice: 'ERROR: cannot combine with different index cards.' }
            end
        else
          if @to.index_card_id.nil?
              @to.index_card_id = @from.index_card_id
              @to.ocr_text = @from.ocr_text
              @to.index_card_aspace = @from.index_card_aspace
          end
          if @from.index_card_id.nil?
            @from.index_card_id = @to.index_card_id
            @from.ocr_text = @to.ocr_text
            @from.index_card_aspace = @to.index_card_aspace
          end
          if @to.index_card_files.nil?
            @to.index_card_files = @from.index_card_files
          end
          if @from.index_card_files.nil?
            @from.index_card_files = @to.index_card_files
          end
        end
      end
      
      if @from.big_card
        @to.big_card = true
      end
      if @to.big_card
        @from.big_card = true
      end
      if @to.big_card_id != @from.big_card_id
          unless @to.big_card_id.nil? || @from.big_card_id.nil?
              respond_to do |format|
                  @error_switch = true
                  format.html { redirect_to '/dedupe?state=' + @state, notice: 'ERROR: cannot combine with different big cards.' }
              end
          else
            if @to.big_card_id.nil?
                @to.big_card_id = @from.big_big_card_id
                @to.big_ocr = @from.big_ocr
                @to.big_card_aspace = @from.big_card_aspace
            end
            if @from.big_card_id.nil?
              @from.big_card_id = @to.big_card_id
              @from.big_ocr = @to.big_ocr
              @from.big_card_aspace = @to.big_card_aspace
            end
            if @to.big_card_files.nil?
              @to.big_card_files = @from.big_card_files
            end
            if @from.big_card_files.nil?
              @from.big_card_files = @to.big_card_files
            end
          end
      end
      
      if @from.reference_material
        @to.reference_material = true
      end
      if @to.reference_material
        @from.reference_material = true
      end
      from_ref_files = @from.reference_material_files.split("; ")
      to_ref_files = @to.reference_material_files.split("; ")
      from_ref_files.each do |ref|
          unless to_ref_files.include? ref.strip
            to_ref_files << ref.strip
          end
      end
      to_ref_files.each do |ref|
        unless from_ref_files.include? ref.strip
          from_ref_files << ref.strip
        end
      end
      @from.reference_material_files = from_ref_files.join("; ")
      @to.reference_material_files = to_ref_files.join("; ")

      from_ref_aspace = @from.reference_material_aspace.split("; ")
      to_ref_aspace = @to.reference_material_aspace.split("; ")
      from_ref_aspace.each do |ref|
        unless to_ref_aspace.include? ref.strip
          to_ref_aspace << ref.strip
        end
      end
      to_ref_aspace.each do |ref|
        unless from_ref_aspace.include? ref.strip
          from_ref_aspace << ref.strip
        end
      end
      @from.reference_material_aspace = from_ref_aspace.join("; ")
      @to.reference_material_aspace = to_ref_aspace.join("; ")

      from_ref_id = @from.reference_material_id.split("; ")
      to_ref_id = @to.reference_material_id.split("; ")
      from_ref_id.each do |ref|
        unless to_ref_id.include? ref.strip
          to_ref_id << ref.strip
        end
      end
      to_ref_id.each do |ref|
        unless from_ref_id.include? ref.strip
          from_ref_id << ref.strip
        end
      end
      @from.reference_material_id = from_ref_id.join("; ")
      @to.reference_material_id = to_ref_id.join("; ")

      if @from.icpsr_record
        @to.icpsr_record = true
      end
      if @to.icpsr_record
        @from.icpsr_record = true
      end
      if @to.icpsr_id != @from.icpsr_id
          unless @to.icpsr_id.nil? || @from.icpsr_id.nil?
              respond_to do |format|
                  @error_switch = true
                  format.html { redirect_to '/dedupe?state=' + @state, notice: 'ERROR: cannot combine with different ICPSR IDs.' }
              end
          else
            if @to.icpsr_id.nil?
              @to.icpsr_id = @from.icpsr_id
            end
            if @from.icpsr_id.nil?
              @from.icpsr_id = @to.icpsr_id
            end
          end
      end

      unless @error_switch
        @to.save
        @from.save
        respond_to do |format|
            format.html { redirect_to '/dedupe?state=' + @state, success: 'Records were successfully combined, be sure to review the changes.' }
        end
      end
    end
    
  end
  
  def mergecard
    @state = params[:state]
    @card = IndexCard.find(params[:card].to_s)
    @espy_record = EspyRecord.where(icpsr_record_id: params[:merge].to_s)[0]
    @merge = IndexCard.find(@espy_record.index_card_id)    
    
    @merge.file_group = @merge.file_group + "; " + @card.file_group
    unless @card.ocr_text.nil?
        if @merge.ocr_text.nil?
            @merge.ocr_text = @card.ocr_text
        else
            @merge.ocr_text = @merge.ocr_text + " " + @card.ocr_text
        end
    end
    @merge.save
    
    @card.used_check = true
    @card.save
    
    respond_to do |format|
        format.html { redirect_to "/espy_records/" + @espy_record.id.to_s + "/edit", notice: 'Check record with additional index card.' }
        #format.html { redirect_to :action => 'make', :state => @state, :card => @card.to_i + 1 }
    end
    
  end

  # GET /check_dupe
  # GET /check_dupe.json
  def check_dupe
    @id = params[:id]
    
    @espy_record = EspyRecord.find(params[:id])
    @espy_record.dupe_check = true
    @espy_record.save

    @state = @espy_record.state_abbreviation
    respond_to do |format|
      format.html { redirect_to '/dedupe?state=' + @state, success: 'Duplicate marked as checked.' }
      format.json { render :show, status: :ok, location: @espy_record }
    end
  end

  # PATCH/PUT /espy_records/1
  # PATCH/PUT /espy_records/1.json
  def update
    respond_to do |format|
      if @espy_record.update(espy_record_params)
        if @espy_record.icpsr_id.blank?
          @espy_record.update_attribute :icpsr_record, false
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
      if params[:dupe_check]
        format.html { redirect_to "/dedupe?state=" + @espy_record.state_abbreviation, notice: 'Espy record was successfully destroyed.' }
        format.json { head :no_content }
      else
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
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_espy_record
      @espy_record = EspyRecord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def espy_record_params
      params.require(:espy_record).permit(:uuid, :record_type, :icpsr_record, :icpsr_record_id, :index_card, :index_card_id, :index_card_files, :index_card_aspace, :big_card, :big_card_id, :big_card_files, :big_card_aspace, :reference_material, :reference_material_id, :reference_material_files, :reference_material_aspace, :ocr_text, :ocr_fixed, :icpsr_id, :first_name, :last_name, :date_crime, :circa_date_crime, :date_execution, :circa_date_execution, :age, :race, :sex, :occupation, :crime, :execution_method, :location_execution, :jurisdiction, :state, :state_abbreviation, :county_code, :county_name, :note, :compensation_case, :icpsr_state, :date_crime_source_icpsr, :date_crime_source_index, :date_crime_source_big,:date_crime_source_ref,:date_execution_source_icpsr,:date_execution_source_index,:date_execution_source_big,:date_execution_source_ref,:age_source_icpsr,:age_source_index,:age_source_big,:age_source_ref,:race_source_icpsr,:race_source_index,:race_source_big,:race_source_ref,:sex_source_icpsr,:sex_source_index,:sex_source_big,:sex_source_ref,:crime_source_icpsr,:crime_source_index,:crime_source_big,:crime_source_ref,:execution_method_source_icpsr,:execution_method_source_index,:execution_method_source_big,:execution_method_source_ref,:county_source_icpsr,:county_source_index,:county_source_big,:county_source_ref, :big_ocr, :big_ocr_check, :name_source_icpsr,:name_source_index,:name_source_big,:name_source_ref, :jurisdiction_source_icpsr, :jurisdiction_source_index, :jurisdiction_source_big, :jurisdiction_source_ref, :slave, :comp_source_icpsr, :comp_source_index, :comp_source_big, :comp_source_ref, :slave_source_icpsr,
:slave_source_index, :slave_source_big, :slave_source_ref, :owner_name, :owner_source_icpsr, :owner_source_index, :owner_source_big, :owner_source_ref, :dupe_check)
    end
end
