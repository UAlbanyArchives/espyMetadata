class SearchSuggestionsController < ApplicationController
  def index
  	if params.has_key?(:name)
  		t = IcpsrRecord.arel_table
  		if params[:name].scan(/ - /).count == 1
        		@query = params[:name].split(' - ')[0]
        		@abbr = params[:name].split(' - ')[1]
  			render json: IcpsrRecord.where('lower(name) = ?', @query.downcase).where(state_abbreviation: @abbr)[0]
		else
        		@date = params[:name].split(' - ')[0]
			@query = params[:name].split(' - ')[1]
        		@abbr = params[:name].split(' - ')[2]
			render json: IcpsrRecord.where('lower(name) = ?', @query.downcase).where(state_abbreviation: @abbr).where(date_execution: @date)[0]

		end
  	else
    	render json: SearchSuggestion.terms_for(params[:term]).reverse
	end
  end
end
