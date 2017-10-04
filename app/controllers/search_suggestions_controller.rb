class SearchSuggestionsController < ApplicationController
  def index
  	if params.has_key?(:name)
  		t = IcpsrRecord.arel_table
  		if params[:name].scan(/ - /).count == 1
        @query = params[:name].split(' - ')[0]
        @abbr = params[:name].split(' - ')[1]
  		else
        @query = params[:name].split(' - ')[1]
        @abbr = params[:name].split(' - ')[2]
		  end
      render json: IcpsrRecord.where('lower(name) = ?', @query.downcase).where(state_abbreviation: @abbr)[0]
  	else
    	render json: SearchSuggestion.terms_for(params[:term]).reverse
	end
  end
end
