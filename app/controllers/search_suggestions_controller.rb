class SearchSuggestionsController < ApplicationController
  def index
  	if params.has_key?(:name)
  		render json: IcpsrRecord.find_by_name(params[:name].split.map(&:capitalize).join(' '))
  	else
    	render json: SearchSuggestion.terms_for(params[:term])
	end
  end
end
