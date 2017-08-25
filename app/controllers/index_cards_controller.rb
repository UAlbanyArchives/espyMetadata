class IndexCardsController < ApplicationController
  before_action :set_index_card, only: [:show, :edit, :update, :destroy]

  # GET /index_cards
  # GET /index_cards.json
  def index
    if params[:state]
      if params[:state] == "*"
        @index_cards = IndexCard.all
      else
        limiter = "state_abbreviation = '" + params[:state].upcase + "'"
        @index_cards = IndexCard.all.where(limiter)
      end
    else
      @index_cards = IndexCard.none
    end
  end

  # GET /index_cards/1
  # GET /index_cards/1.json
  def show
  end

  # GET /index_cards/new
  def new
    @index_card = IndexCard.new
  end

  # GET /index_cards/1/edit
  def edit
  end

  # POST /index_cards
  # POST /index_cards.json
  def create
    @index_card = IndexCard.new(index_card_params)

    respond_to do |format|
      if @index_card.save
        format.html { redirect_to @index_card, notice: 'Index card was successfully created.' }
        format.json { render :show, status: :created, location: @index_card }
      else
        format.html { render :new }
        format.json { render json: @index_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /index_cards/1
  # PATCH/PUT /index_cards/1.json
  def update
    respond_to do |format|
      if @index_card.update(index_card_params)
        format.html { redirect_to @index_card, notice: 'Index card was successfully updated.' }
        format.json { render :show, status: :ok, location: @index_card }
      else
        format.html { render :edit }
        format.json { render json: @index_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /index_cards/1
  # DELETE /index_cards/1.json
  def destroy
    @index_card.destroy
    respond_to do |format|
      format.html { redirect_to index_cards_url, notice: 'Index card was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_index_card
      @index_card = IndexCard.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def index_card_params
      params.require(:index_card).permit(:state_abbreviation, :root_filename, :file_group, :ocr_text, :used_check)
    end
end
