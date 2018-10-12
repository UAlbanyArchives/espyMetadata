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
    if big_card_params[:state]
      
      @big_card.update_attribute :ocr_text, big_card_params[:ocr_text]
      if big_card_params[:dup_id].present?
        @icpsr = IcpsrRecord.find_by_id(big_card_params[:dup_id])
        @icpsr.update_attribute :big_id, params[:id].to_i
        @big_card.update_attribute :used_check, big_card_params[:used_check]
        respond_to do |format|
          format.html { redirect_to "/link_big_cards?state=" + big_card_params[:state_param]}
        end
      elsif big_card_params[:icpsr].present?
        @icpsr = IcpsrRecord.find_by_icpsr_id(big_card_params[:icpsr])
        @icpsr.update_attribute :big_id, params[:id].to_i
        @big_card.update_attribute :used_check, big_card_params[:used_check]
        respond_to do |format|
          format.html { redirect_to "/link_big_cards?state=" + big_card_params[:state_param]}
        end
      else
        if big_card_params[:first_name].present?
          @newName = big_card_params[:last_name].to_s + " " + big_card_params[:first_name].to_s
        else
          @newName = big_card_params[:last_name].to_s
        end

        @icpsr = IcpsrRecord.create(name: @newName, date_execution: big_card_params[:date_execution], race: big_card_params[:race], sex: big_card_params[:sex], state: big_card_params[:state], state_abbreviation: big_card_params[:state_abbreviation], county_name: big_card_params[:county_name], big_id: params[:id].to_i)
        if @icpsr.valid?
          @big_card.update_attribute :used_check, big_card_params[:used_check]
          respond_to do |format|
            format.html { redirect_to "/link_big_cards?state=" + big_card_params[:state_param], notice: 'Large Card was linked for: ' + @newName + '.' }
          end
        else
          @errorMsg = "<strong class='errorHead'>Oh No!</strong><br/>You tried to make a new record, but it was invalid!<ul>"
          @icpsr.errors.full_messages.each do |msg|
            @errorMsg = @errorMsg + "<li>" + msg.to_s + "</li>"
          end
          @errorMsg = @errorMsg + "</ul>"
          respond_to do |format|
            format.html { redirect_to "/link_big_cards?state=" + big_card_params[:state_param], :flash => { :error => @errorMsg }}
          end
        end
        
      end
    else
      if @big_card.update(big_card_params)
        @unlink = ""
        if @big_card.used_check == false
          IcpsrRecord.where(big_id: @big_card.id).each do |link|
            link.update_attribute :big_id, nil
            @unlink = @unlink + " Unlinked Icpsr " + link.icpsr_id.to_s
          end
        end
        if params[:state]
          respond_to do |format|
            if params[:card]
              @nextCard = params[:card].to_i + 1
              format.html { redirect_to "/link_big_cards?state=" + params[:state] + "&card=" + @nextCard.to_s}
            else
              format.html { redirect_to "/link_big_cards?state=" + params[:state]}
            end
          end
        else
          respond_to do |format|
            format.html { redirect_to @big_card, notice: 'Big card was successfully updated.' + @unlink }
            format.json { render :show, status: :ok, location: @big_card }
          end
        end
      else
        respond_to do |format|
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
      params.require(:big_card).permit(:state_abbreviation, :root_filename, :file_group, :ocr_text, :ocr_check, :used_check, :aspace, :state, :dup_id, :icpsr, :first_name, :last_name, :card, :date_execution, :sex, :race, :county_name, :state_param)
    end
end
