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
      if big_card_params[:icpsr].present?
        @icpsr = IcpsrRecord.find_by_icpsr_id(big_card_params[:icpsr])
        @icpsr.update_attribute :big_id, params[:id].to_i
        @big_card.update_attribute :used_check, big_card_params[:used_check]
        respond_to do |format|
          format.html { redirect_to "/link_big_cards?state=" + big_card_params[:state_param]}
        end
      else
        @checkValid = false
        if big_card_params[:first_name].present? or big_card_params[:last_name].present?
          @checkValid = true
        elsif big_card_params[:date_execution].present?
          @checkValid = true
        end         
        
        if @checkValid == true
          @icpsr = IcpsrRecord.new
          if big_card_params[:last_name].present?
            if big_card_params[:first_name].present?
              @newName = big_card_params[:last_name].to_s + " " + big_card_params[:first_name].to_s
            else
              @newName = big_card_params[:last_name].to_s
            end
            @icpsr.update_attribute :name, @newName
          elsif big_card_params[:first_name].present?
            @newName = big_card_params[:first_name].to_s
            @icpsr.update_attribute :name, @newName
          end
          
          @icpsr.update_attribute :date_execution, big_card_params[:date_execution]
          @icpsr.update_attribute :race, big_card_params[:race]
          @icpsr.update_attribute :sex, big_card_params[:sex]
          @icpsr.update_attribute :state, big_card_params[:state]
          @icpsr.update_attribute :state_abbreviation, big_card_params[:state_abbreviation]
          @icpsr.update_attribute :county_name, big_card_params[:county_name]
          @icpsr.update_attribute :big_id, params[:id].to_i
          @big_card.update_attribute :used_check, big_card_params[:used_check]

          respond_to do |format|
            format.html { redirect_to "/link_big_cards?state=" + big_card_params[:state_param]}
          end
        else
          respond_to do |format|
            if big_card_params[:card]
              format.html { redirect_to "/link_big_cards?state=" + big_card_params[:state_param] + "&card=" + big_card_params[:card], :flash => { :error => "<strong class='errorHead'>Oh No!</strong><br/>You did not enter a name or an execution date. Please find or make a complete record and try again." }}
            else
              format.html { redirect_to "/link_big_cards?state=" + big_card_params[:state_param], :flash => { :error => "<strong class='errorHead'>Oh No!</strong><br/>You did not enter a name or an execution date. Please find or make a complete record and try again." }}
            end
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
      params.require(:big_card).permit(:state_abbreviation, :root_filename, :file_group, :ocr_text, :ocr_check, :used_check, :aspace, :state, :icpsr, :first_name, :last_name, :card, :date_execution, :sex, :race, :county_name, :state_param)
    end
end
