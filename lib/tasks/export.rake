require "csv"
require 'httparty'

namespace :export do

  task pace: :environment do

    CSV.open("/data/espyMetadataPace.tsv", "ab", col_sep: "\t") do |csv|
        row = []
        row << Time.now.strftime("%Y-%m-%d %H:%M")
        row << EspyRecord.count.to_s
        csv << row
    end
    
  end
  
  
  task :data, [:arg1] => :environment do |t, args|
  
    puts "Exporting " + args[:arg1].to_s + "..."
    fields = [
    "id",
    "uuid",
    "record_type",
    "icpsr_record",
    "icpsr_id",
    "state",
    "state_abbreviation",
    "first_name",
    "last_name",
    "name_source_icpsr",
    "name_source_index",
    "name_source_big",
    "name_source_ref",
    "owner_name",
    "owner_source_icpsr",
    "owner_source_index",
    "owner_source_big",
    "owner_source_ref",
    "circa_date_execution",
    "date_execution",
    "date_execution_source_icpsr",
    "date_execution_source_index",
    "date_execution_source_big",
    "date_execution_source_ref",
    "circa_date_crime",
    "date_crime",
    "date_crime_source_icpsr",
    "date_crime_source_index",
    "date_crime_source_big",
    "date_crime_source_ref",
    "age",
    "age_source_icpsr",
    "age_source_index",
    "age_source_big",
    "age_source_ref",
    "gender_assigned",
    "gender_source_icpsr",
    "gender_source_index",
    "gender_source_big",
    "gender_source_ref",
    "race",
    "race_source_icpsr",
    "race_source_index",
    "race_source_big",
    "race_source_ref",
    "crime_convicted_of",
    "crime_source_icpsr",
    "crime_source_index",
    "crime_source_big",
    "crime_source_ref",
    "enslaved",
    "enslaved_source_icpsr",
    "enslaved_source_index",
    "enslaved_source_big",
    "enslaved_source_ref",
    "compensation_case",
    "comp_source_icpsr",
    "comp_source_index",
    "comp_source_big",
    "comp_source_ref",
    "execution_method",
    "execution_method_source_icpsr",
    "execution_method_source_index",
    "execution_method_source_big",
    "execution_method_source_ref",
    "jurisdiction",
    "jurisdiction_source_icpsr",
    "jurisdiction_source_index",
    "jurisdiction_source_big",
    "jurisdiction_source_ref",
    "county_name",
    "county_source_icpsr",
    "county_source_index",
    "county_source_big",
    "county_source_ref",
    "county_code",
    "notes",
    "icpsr_record_id",
    "index_card",
    "index_card_id",
    "ocr_text",
    "index_card_files",
    "index_card_uri",
    "index_card_download",
    "big_card",
    "big_card_id",
    "big_ocr",
    "big_card_files",
    "big_card_uri",
    "big_card_download",
    "reference_material",
    "reference_material_id",
    "reference_material_files",
    "reference_material_uri",
    "reference_material_download",
    "created_at",
    "updated_at",
    "index_card_aspace",
    "big_card_aspace",
    "reference_material_aspace"
    ]
        
    #puts fields
    
    #EspyRecord.where("state_abbreviation": args[:arg1].to_s).each do |record|
    
    record = EspyRecord.find(110)
    change_list = {
    "gender_assigned" => "sex",
    "gender_source_icpsr" => "sex_source_icpsr",
    "gender_source_index" => "sex_source_index",
    "gender_source_big" => "sex_source_big",
    "gender_source_ref" => "sex_source_ref",
    "crime_convicted_of" => "crime",
    "enslaved" => "slave",
    "enslaved_source_icpsr" => "slave_source_icpsr",
    "enslaved_source_index" => "slave_source_icpsr",
    "enslaved_source_big" => "slave_source_icpsr",
    "enslaved_source_ref" => "slave_source_icpsr",
    "notes" => "note"
    }
    
    pass_list = ["index_card_download", "big_card_download", "reference_material_download"]
    
    fields.each do |field|
        puts field
        if change_list.key?(field)
            value = record.send(change_list[field]).to_s
        elsif pass_list.include? field
        
        elsif field == "index_card_uri"
            if record.index_card
                url = %Q[https://archives.albany.edu/catalog?utf8=✓&search_field=all_fields&search_field=all_fields&format=json&q="#{record.index_card_files.to_s}"]
                response = HTTParty.get(URI.escape(url), :verify => false)
                index_id = response.parsed_response["response"]["docs"][0]["id"].to_s
                value = "https://archives.albany.edu/concern/daos/" + index_id
                url2 = value + "?format=jsonld"
                response = HTTParty.get(URI.escape(url2), :verify => false, format: :json)
                response.parsed_response["@graph"].each do |part|
                    if part.key? "ebucore:hasRelatedImage"
                        index_download_id = part["ebucore:hasRelatedImage"]["@id"].split("/catalog/")[1]
                        index_download = "https://archives.albany.edu/downloads/" + index_download_id
                        puts index_download
                    end
                end
            end
        elsif field == "big_card_uri"
        
        elsif field == "reference_material_uri"
        
        else
            value = record.send(field).to_s
        end
    end
    #end
    
  end 
  
  task :raw, [:arg1] => :environment do |t, args|
  
    puts "Exporting " + args[:arg1].to_s + "..."

    CSV.open("/home/gw234478/espy" + args[:arg1].to_s + ".csv", "wb") do |csv|
        csv << EspyRecord.attribute_names
        EspyRecord.where("state_abbreviation": args[:arg1].to_s).each do |record|

            csv << record.attributes.values
            puts record.id
        end
    end
    
    puts "finished export to espy" + args[:arg1].to_s + ".csv"
    
  end
  
  task hyrax: :environment do

    CSV.open("/home/gw234478/references.csv", "wb") do |csv|
        headers = ["Type", "URIs", "File Paths", "Accession", "Collecting Area", "Collection Number", "Collection", "ArchivesSpace ID", "Record Parents", "Title", "Description", "Date Created", "Resource Type", "License", "Rights Statement", "Subjects", "Whole/Part", "Processing Activity", "Extent", "Language"]
        csv << headers
        Reference.all.each do |record|
            parents = ""
            parentDate = ""
            title = ""
            desc = ""
            count = 0
            record.icpsr_records.each do |ref|
                count = count + 1
                if count == 1
                    title = "Documemention for the execution of " + ref.name
                    parentDate = ref.date_execution.to_s        
                elsif count > 5
                    title << "..."
                    desc << "\n"
                else
                    title << ", " + ref.name
                    desc << "\n"
                end
                desc << ref.name + " executed on " + ref.date_execution + " in " + ref.state + "|" + ref.state_abbreviation
            end
            if count == 0
                title = "Documemention of execution(s)"
                parentDate = "Undated"
                desc = ""
            end
            line = ["DAO", "", record.filename, "", "New York State Modern Political Archive", "apap301", "M. Watt Espy Papers", record.aspace, parents, title, desc, parentDate, "Document", "http://creativecommons.org/licenses/by-nc-nd/4.0/", "", "", "part", "", "", ""]
            csv << line
            puts record.id.to_s + " " + title
        end
    end
    
  end
  
  task big_cards: :environment do

    CSV.open("/home/gw234478/big_cards.csv", "wb") do |csv|
        headers = ["Type", "URIs", "File Paths", "Accession", "Collecting Area", "Collection Number", "Collection", "ArchivesSpace ID", "Record Parents", "Title", "Description", "Date Created", "Resource Type", "License", "Rights Statement", "Subjects", "Whole/Part", "Processing Activity", "Extent", "Language"]
        csv << headers
        BigCard.all.each do |record|
            parents = ""
            parentDate = ""
            title = ""
            desc = ""
            count = 0
            IcpsrRecord.where("big_id": record.id).each do |ref|
                count = count + 1
                if count == 1
                    title = "Summary of the execution of " + ref.name
                    parentDate = ref.date_execution.to_s        
                else
                    title << ", " + ref.name
                    desc << "\n"
                end
                desc << ref.name + " executed on " + ref.date_execution + " in " + ref.state + "|" + ref.state_abbreviation
            end
            if count == 0
                title = "Execution Summary Card"
                parentDate = "Undated"
                desc = ""
            end
            line = ["DAO", "", record.file_group, "", "New York State Modern Political Archive", "apap301", "M. Watt Espy Papers", record.aspace, parents, title, desc, parentDate, "Document", "http://creativecommons.org/licenses/by-nc-nd/4.0/", "", "", "part", "", "", ""]
            csv << line
            puts record.id.to_s + " " + title
        end
    end
    
  end
  task index_cards: :environment do

    CSV.open("/home/gw234478/index_cards.csv", "wb") do |csv|
        headers = ["Type", "URIs", "File Paths", "Accession", "Collecting Area", "Collection Number", "Collection", "ArchivesSpace ID", "Record Parents", "Title", "Description", "Date Created", "Resource Type", "License", "Rights Statement", "Subjects", "Whole/Part", "Processing Activity", "Extent", "Language"]
        csv << headers
        IndexCard.all.each do |record|
            parents = ""
            parentDate = "Undated"
            title = "Index Card Summary of Execution(s)"
            desc = ""
            line = ["DAO", "", record.file_group, "", "New York State Modern Political Archive", "apap301", "M. Watt Espy Papers", record.aspace, parents, title, desc, parentDate, "Document", "http://creativecommons.org/licenses/by-nc-nd/4.0/", "", "", "part", "", "", ""]
            csv << line
            puts record.id.to_s + " " + title
        end
    end
    
  end
end