class BigCardsController < ApplicationController
  before_action :set_big_card, only: [:show, :edit, :update, :destroy]

  # GET /big_cards
  # GET /big_cards.json
  def index
    if params[:state]
      if params[:state] == "*"
        @big_cards = BigCard.all
      else
        limiter = "state_abbreviation = '" + params[:state].upcase + "'"
        @big_cards = BigCard.all.where(limiter)
      end
    else
      @big_cards = BigCard.none
    end
  end

  # GET /big_cards/1
  # GET /big_cards/1.json
  def show
  end

  # GET /big_cards/link
  def link
    @big_card = BigCard.all
  end

  # GET /big_cards/1/edit
  def edit
  end

  # POST /big_cards
  # POST /big_cards.json
  def create
    @big_card = BigCard.new(big_card_params)

    respond_to do |format|
      if @big_card.save
        format.html { redirect_to @big_card, notice: 'Big card was successfully created.' }
        format.json { render :show, status: :created, location: @big_card }
      else
        format.html { render :new }
        format.json { render json: @big_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /big_cards/1
  # PATCH/PUT /big_cards/1.json
  def update
    respond_to do |format|
      if big_card_params[:state]
        @error = false
        @big_card.update_attribute :used_check, big_card_params[:used_check]
        @big_card.update_attribute :ocr_text, big_card_params[:ocr_text]
        if big_card_params[:icpsr].present?
          @icpsr = IcpsrRecord.find_by_icpsr_id(big_card_params[:icpsr])
          @icpsr.update_attribute :big_id, params[:id].to_i
        else
          if big_card_params[:first_name].present?
            @icpsr = IcpsrRecord.new
            @icpsr.update_attribute :name, big_card_params[:first_name].to_s + " " + big_card_params[:last_name].to_s
            @icpsr.update_attribute :state_abbreviation, big_card_params[:state].to_s
            @icpsr.update_attribute :big_id, params[:id].to_i
          else
            @big_card.update_attribute :used_check, false
            @error = true
          end
        end
        if @error == true
          if big_card_params[:card]
            format.html { redirect_to "/link_big_cards?state=" + big_card_params[:state] + "&card=" + big_card_params[:card], notice: "Not enough information!"}
          else
            format.html { redirect_to "/link_big_cards?state=" + big_card_params[:state]}
          end
        else
          if big_card_params[:card]
            format.html { redirect_to "/link_big_cards?state=" + big_card_params[:state] + "&card=" + big_card_params[:card], notice: 'Not enough information!'}
          else
            format.html { redirect_to "/link_big_cards?state=" + big_card_params[:state]}
          end
        end
      else
        if @big_card.update(big_card_params)
          format.html { redirect_to @big_card, notice: 'Big card was successfully updated.' }
          format.json { render :show, status: :ok, location: @big_card }
        else
          format.html { render :edit }
          format.json { render json: @big_card.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /big_cards/1
  # DELETE /big_cards/1.json
  def destroy
    @big_card.destroy
    respond_to do |format|
      format.html { redirect_to big_cards_url, notice: 'Big card was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_big_card
      @big_card = BigCard.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def big_card_params
      params.require(:big_card).permit(:state_abbreviation, :root_filename, :file_group, :ocr_text, :ocr_check, :used_check, :aspace, :state, :icpsr, :first_name, :last_name, :card)
    end
end
