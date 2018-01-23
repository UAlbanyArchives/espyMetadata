class ReferencesController < ApplicationController
  before_action :set_reference, only: [:show, :edit, :update, :destroy]

  # GET /references
  # GET /references.json
  def index
    @references = Reference.all
    if params[:folder]
      if params[:folder] == "*"
        @references = Reference.all
      else
        limiter = "folder_name = '" + params[:folder] + "'"
        @references = Reference.all.where(limiter)
      end
    else
      @references = Reference.none
    end
  end

  # GET /references/1
  # GET /references/1.json
  def show
  end

  # GET /big_cards/link
  def link
    if params[:folder]
      @references = Reference.all.where(folder_name: params[:folder])
    else
      @references = Reference.all
    end
  end

  # GET /references/new
  def new
    @reference = Reference.new
  end

  # GET /references/1/edit
  def edit
  end

  def rotate
    
    @image = Reference.find(params[:item])

    #raise @cmd
    @cmd = 'convert -rotate 90 ~/espyMetadata/public/images/reference/' + @image.filename + ' ~/espyMetadata/public/images/reference/' + @image.filename
    #rotate image 90
    system(@cmd)
    
    @image.increment(:rotation, by = 1)
    @image.save

    if params[:folder]
      redirect_to "/link_pdfs?folder=" + params[:folder] + "&item=" + params[:item]
    else
      redirect_to "/references/" + params[:item]
    end
  end

  def add_file
    @item = Reference.find(params[:item].to_i)
    @forwardItem = 1 + params[:item].to_i
    if not Reference.where(folder_name: @item.folder_name, id: @forwardItem.to_s).exists?
      @forwardItem = params[:item].to_i
    end
    if @item.active == true
      respond_to do |format|
        @folder = @item.folder_name
        format.html { redirect_to "/link_pdfs?folder=" + @folder + "&item=" + @forwardItem.to_s, alert: 'This item has already been added.' }
      end
    else
      @item.active = true
      @item.save
      respond_to do |format|
        @folder = @item.folder_name
        format.html { redirect_to "/link_pdfs?folder=" + @folder + "&item=" + @forwardItem.to_s }
      end
    end
  end

  def remove_file
    @item = Reference.find(params[:item].to_i)
    @item.active = false
    @item.save
    respond_to do |format|
      @reload = Reference.find(params[:reload].to_i)
      format.html { redirect_to "/link_pdfs?folder=" + @reload.folder_name + "&item=" + params[:reload] }
    end
  end

  # POST /references
  # POST /references.json
  def create
    @reference = Reference.new(reference_params)

    respond_to do |format|
      if @reference.save
        format.html { redirect_to @reference, notice: 'Reference was successfully created.' }
        format.json { render :show, status: :created, location: @reference }
      else
        format.html { render :new }
        format.json { render json: @reference.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /references/1
  # PATCH/PUT /references/1.json
  def update
    if reference_params[:first_name]
      @item = Reference.find(params[:id].to_i)
      @folder = @item.folder_name
      if Reference.where(folder_name: @item.folder_name).where(active: true).empty?
        respond_to do |format|
          @item = Reference.find(params[:id].to_i)
          @folder = @item.folder_name
          format.html { redirect_to "/link_pdfs?folder=" + @folder + "&item=" + params[:id].to_s, :flash => { :error => "<strong class='errorHead'>Oh No!</strong><br/>No reference material was selected." } }
        end
      else

        if reference_params[:icpsr].present?
            if reference_params[:icpsr].include? ";"
              reference_params[:icpsr].split(";").uniq.each do |icpsrRecordID|
                @icpsr = IcpsrRecord.find_by_icpsr_id(icpsrRecordID)
                @active = false
                Reference.where(folder_name: @item.folder_name).where(active: true).each do |active|
                  @active = true
                  @icpsr.references << active
                end
              end
            else
              @icpsr = IcpsrRecord.find_by_icpsr_id(reference_params[:icpsr])
              @active = false
              Reference.where(folder_name: @item.folder_name).where(active: true).each do |active|
                @active = true
                @icpsr.references << active
              end
            end
            Reference.where(folder_name: @item.folder_name).where(active: true).each do |active|
              active.used_check = true
              active.active = false
              active.save
            end           
            respond_to do |format|
              if reference_params[:icpsr].include? ";"
                @icpsrRecord = ""
                reference_params[:icpsr].split(";").uniq.each do |icpsrRecordID|
                  @icpsr = IcpsrRecord.find_by_icpsr_id(icpsrRecordID)
                  if @icpsr.name.present?
                    @icpsrRecord = @icpsrRecord + ", " + @icpsr.name
                  else
                    @icpsrRecord = @icpsrRecord + ", (" + @icpsr.date_execution + ")"
                  end
                end
              else
                if @icpsr.name.present?
                  @icpsrRecord = @icpsr.name
                elsif @icpsr.date_execution.present?
                  @icpsrRecord = "Icpsr record " + @icpsr.id.to_s + " (" + @icpsr.date_execution + ")"
                end
              end
              @forwardItem = 1 + params[:id].to_i
              if not Reference.where(folder_name: @folder, id: @forwardItem.to_s).exists?
                @forwardItem = params[:id].to_i
              end
              format.html { redirect_to "/link_pdfs?folder=" + @folder + "&item=" + @forwardItem.to_s, notice: 'Reference material was added to the record for: ' + @icpsrRecord + '.' }
            end
        else

          if reference_params[:last_name].present?
            if reference_params[:first_name].present?
              @newName = reference_params[:last_name].to_s + " " + reference_params[:first_name].to_s
            else
              @newName = reference_params[:last_name].to_s
            end
          elsif reference_params[:first_name].present?
            @newName = reference_params[:first_name].to_s
          end
          @icpsr = IcpsrRecord.create(name: @newName, date_execution: reference_params[:date_execution], race: reference_params[:race], sex: reference_params[:sex], state: reference_params[:state], state_abbreviation: reference_params[:state_abbreviation], county_name: reference_params[:county_name])
          if @icpsr.valid?
            Reference.where(folder_name: @item.folder_name).where(active: true).each do |active|
              @icpsr.references << active
              active.used_check = true
              active.active = false
              active.save
            end
            respond_to do |format|
              @forwardItem = 1 + params[:id].to_i
              if not Reference.where(folder_name: @folder, id: @forwardItem.to_s).exists?
                @forwardItem = params[:id].to_i
              end
              if @newName.nil?
                format.html { redirect_to "/link_pdfs?folder=" + @folder + "&item=" + @forwardItem.to_s, notice: 'Reference material was added to an Unnamed record.' }
              else
                format.html { redirect_to "/link_pdfs?folder=" + @folder + "&item=" + @forwardItem.to_s, notice: 'Reference material was added to the record for: ' + @newName + '.' }
              end
            end
          else
            @errorMsg = "<strong class='errorHead'>Oh No!</strong><br/>You tried to make a new record, but it was invalid!<ul>"
            @icpsr.errors.full_messages.each do |msg|
              @errorMsg = @errorMsg + "<li>" + msg.to_s + "</li>"
            end
            @errorMsg = @errorMsg + "</ul>"
            respond_to do |format|
              format.html { redirect_to "/link_pdfs?folder=" + @folder + "&item=" + params[:id].to_s, :flash => { :error => @errorMsg }}
            end
          end

        end
      end
    else
      respond_to do |format|
        if @reference.update(reference_params)
          format.html { redirect_to @reference, notice: 'Reference was successfully updated.' }
          format.json { render :show, status: :ok, location: @reference }
        else
          format.html { render :edit }
          format.json { render json: @reference.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /references/1
  # DELETE /references/1.json
  def destroy
    @reference.destroy
    respond_to do |format|
      format.html { redirect_to references_url, notice: 'Reference was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reference
      @reference = Reference.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reference_params
      params.require(:reference).permit(:filename, :folder_name, :used_check, :aspace, :folder, :item, :state, :icpsr, :first_name, :last_name, :date_execution, :sex, :race, :county_name, :state_abbreviation)
    end
end
