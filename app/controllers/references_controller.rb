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
    @references = Reference.all
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
    @item.active = true
    @item.save
    respond_to do |format|
      @folder = @item.folder_name
      format.html { redirect_to "/link_pdfs?folder=" + @folder + "&item=" + params[:item] }
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
      params.require(:reference).permit(:filename, :folder_name, :used_check, :aspace, :folder, :item)
    end
end
