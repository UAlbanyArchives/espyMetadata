namespace :search_suggestions do

  desc 'Generate search suggestions'
  task index: :environment do
    SearchSuggestion.seed
    
  end

  task add: :environment do
    SearchSuggestion.add
    
  end

end
