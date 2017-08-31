class SearchSuggestionsController < ApplicationController
  def index
  	if params.has_key?(:name)
  		t = IcpsrRecord.arel_table
		render json: IcpsrRecord.find_by(t[:name].matches params[:name])
  	else
    	render json: SearchSuggestion.terms_for(params[:term])
	end
  end
end
