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

  def add_file
    @item = Reference.find(params[:item].to_i)
    if @item.active == true
      respond_to do |format|
        @folder = @item.folder_name
        format.html { redirect_to "/link_pdfs?folder=" + @folder + "&item=" + params[:item], alert: 'This item has already been added.' }
      end
    else
      @item.active = true
      @item.save
      respond_to do |format|
        @folder = @item.folder_name
        format.html { redirect_to "/link_pdfs?folder=" + @folder + "&item=" + params[:item] }
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
      if reference_params[:icpsr].present?
          @icpsr = IcpsrRecord.find_by_icpsr_id(reference_params[:icpsr])
          Reference.where(active: true).each do |active|
            @icpsr.references << active
            active.used_check = true
            active.active = false
            active.save
          end
          respond_to do |format|
            if @icpsr.name.present?
              @icpsrRecord = @icpsr.name
              format.html { redirect_to "/link_pdfs?folder=" + @folder + "&item=" + params[:id].to_s, notice: 'Reference material was added to the record for: ' + @icpsrRecord + '.' }
            elsif @icpsr.date_execution.present?
              @icpsrRecord = "Icpsr record " + @icpsr.id.to_s + " (" + @icpsr.date_execution + ")"
              format.html { redirect_to "/link_pdfs?folder=" + @folder + "&item=" + params[:id].to_s, notice: 'Reference material was added to the record for: ' + @icpsrRecord + '.' }
            end
          end
      else
          @checkValid = false
          if reference_params[:first_name].present? or reference_params[:last_name].present?
            @checkValid = true
          elsif reference_params[:date_execution].present?
            @checkValid = true
          end         

          if @checkValid == true
            @icpsr = IcpsrRecord.new
            if reference_params[:last_name].present?
              if reference_params[:first_name].present?
                @newName = reference_params[:last_name].to_s + " " + reference_params[:first_name].to_s
              else
                @newName = reference_params[:last_name].to_s
              end
            elsif reference_params[:first_name].present?
              @newName = reference_params[:first_name].to_s
            end
            @icpsr.update_attribute :name, @newName
            @icpsr.update_attribute :date_execution, reference_params[:date_execution]
            @icpsr.update_attribute :race, reference_params[:race]
            @icpsr.update_attribute :sex, reference_params[:sex]
            @icpsr.update_attribute :state, reference_params[:state]
            @icpsr.update_attribute :state_abbreviation, reference_params[:state_abbreviation]
            @icpsr.update_attribute :county_name, reference_params[:county_name]
            Reference.where(active: true).each do |active|
              @icpsr.references << active
              active.used_check = true
              active.active = false
              active.save
            end
            respond_to do |format|
              if @icpsr.name.present?
                @icpsrRecord = @icpsr.name
                format.html { redirect_to "/link_pdfs?folder=" + @folder + "&item=" + params[:id].to_s, notice: 'Reference material was added to the record for: ' + @icpsrRecord + '.' }
              elsif @icpsr.date_execution.present?
                @icpsrRecord = "Icpsr record " + @icpsr.id.to_s + " (" + @icpsr.date_execution + ")"
                format.html { redirect_to "/link_pdfs?folder=" + @folder + "&item=" + params[:id].to_s, notice: 'Reference material was added to the record for: ' + @icpsrRecord + '.' }
              else
                @icpsrRecord = "Icpsr record " + @icpsr.id.to_s
                format.html { redirect_to "/link_pdfs?folder=" + @folder + "&item=" + params[:id].to_s, :flash => { :error => "<strong class='errorHead'>Oh No!</strong><br/>You did not enter a name or date, so a blank record was created! <a href='/icpsr_records?state='>Click Here to see all the blank records.</a>" }}
              end
            end
          else
            respond_to do |format|
              format.html { redirect_to "/link_pdfs?folder=" + @folder + "&item=" + params[:id].to_s, :flash => { :error => "<strong class='errorHead'>Oh No!</strong><br/>You did not enter a name or an execution date. Please find or make a complete record and try again." }}
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
