require "csv"
namespace :export do

  task pace: :environment do

    CSV.open("/data/espyMetadataPace.tsv", "ab", col_sep: "\t") do |csv|
        row = []
        row << Time.now.strftime("%Y-%m-%d %H:%M")
        row << EspyRecord.count.to_s
        csv << row
    end
    
  end
  
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