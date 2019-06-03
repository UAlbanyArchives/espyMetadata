require "csv"
namespace :export do
  task sheet: :environment do

    CSV.open("/home/gw234478/espyOregon.csv", "wb") do |csv|
        csv << EspyRecord.attribute_names
        EspyRecord.where("state_abbreviation": "OR").each do |record|

            csv << record.attributes.values
            puts record.id
        end
    end
    
  end
end