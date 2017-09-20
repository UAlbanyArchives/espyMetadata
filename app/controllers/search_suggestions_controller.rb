class SearchSuggestionsController < ApplicationController
  def index
  	if params.has_key?(:name)
  		t = IcpsrRecord.arel_table
  		type = params[:name].count(' - ')
  		if type == 1
  			render json: IcpsrRecord.find_by(t[:name].matches params[:name].split(' - ')[0])
  		else
			render json: IcpsrRecord.find_by(t[:name].matches params[:name].split(' - ')[1])
		end
  	else
    	render json: SearchSuggestion.terms_for(params[:term]).reverse
	end
  end
end
