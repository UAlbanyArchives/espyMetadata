require "csv"
#require 'httparty'
#require 'http'

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
  
    fields = [
    "id",
    "uuid",
    "record_type",
    "icpsr_record",
    "icpsr_id",
    "state",
    "state_abbreviation",
    "name",
    "name_source_icpsr",
    "name_source_index",
    "name_source_big",
    "name_source_ref",
    "circa_date_execution",
    "date_execution",
    "year_execution",
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
    "owner_name",
    "owner_source_icpsr",
    "owner_source_index",
    "owner_source_big",
    "owner_source_ref",
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
    "ref_uuid",
    "created_at",
    "updated_at",
    "index_card_aspace",
    "big_card_aspace",
    "reference_material_aspace"
    ]
        
    #puts fields
    
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
    pass_list = ["year_execution", "index_card_download", "index_card_uuid", "big_card_download", "big_card_uuid", "reference_material_download", "ref_uuid"]
    
    count = 0
    total_count = EspyRecord.where("state_abbreviation": args[:arg1].to_s).count
    puts "Exporting " + total_count.to_s + " records from " + args[:arg1].to_s + "..."
    
    puts "Reading espyIDs.csv..."
    csv_text = File.read("/opt/lib/espyIDs.csv")
    espy_lookup = {}
    espy_ids = CSV.parse(csv_text, :headers => true)
    espy_ids.each do |row|
        espy_key = row[2].split("|").sort
        espy_lookup[espy_key.join("|")] = [row[0], row[1]]
    end
    
    headers = []
    fields.each do |field|
        if field == "id"
            headers << field
        else
            headers << field #+ "_tsi"
        end
    end
    
    ctx = OpenSSL::SSL::SSLContext.new
    ctx.verify_mode = OpenSSL::SSL::VERIFY_NONE
    
    CSV.open("/home/gw234478/exports/espySolr" + args[:arg1].to_s + ".csv", "wb") do |csv|
        csv << headers
        
        #record = EspyRecord.find(118)
        EspyRecord.where("state_abbreviation": args[:arg1].to_s).each do |record|
            count += 1
            count_string = "(" + count.to_s + "/" + total_count.to_s + ")"
            puts count_string + " Exporting " + record.first_name + " " + record.last_name + " " + record.date_execution + "..."
            record_attributes = []
            
            fields.each do |field|
                #puts field
                if change_list.key?(field)
                    value = record.send(change_list[field]).to_s
                    record_attributes << value
                elsif pass_list.include? field
                
                elsif field == "name"
                    unless record.last_name == '' and record.first_name == ''
                        if record.first_name.downcase.strip == "unknown" and record.last_name == ''
                            record_attributes << "Unknown Person"
                        elsif record.last_name.downcase.strip == "unknown" and record.first_name == ''
                            record_attributes << "Unknown Person"
                        elsif record.first_name == ''
                            record_attributes << record.last_name
                        elsif record.last_name == ''
                            record_attributes << record.first_name
                        else  
                            record_attributes << record.first_name + " " + record.last_name
                        end                    
                    else
                        record_attributes << "Unknown Person"
                    end
                
                elsif field.include? "aspace"
                    aspace_id = record.send(field).to_s
                    if aspace_id.length > 0
                        value = []
                        aspace_id.split("; ").each do |aspace|
                            value << "https://archives.albany.edu/description/catalog/apap301aspace_" + aspace
                        end
                        record_attributes << value.join("; ")
                    else
                        record_attributes << nil
                    end
                elsif field == "index_card_uri"
                    if record.index_card
                        #puts "looking for " + record.index_card_files.to_s
                        filenames = record.index_card_files.split("; ")
                        download = []
                        #puts filenames
                        #puts "\t" + filenames.sort.join("|")
                        daoID, fsID = espy_lookup[filenames.sort.join("|")]
                        if daoID.nil? || fsID.nil?
                            value = []
                            filenames.each do |filename|
                                #puts filename
                                #puts espy_lookup[filename]
                                daoID, fsID = espy_lookup[filename]
                                espy_ids.each do |row|
                                    if row[2].include? filename
                                        daoID = row[0]
                                        fsID = row[1]
                                    end
                                end
                                download << "https://archives.albany.edu/downloads/" + fsID
                                value << "https://archives.albany.edu/concern/daos/" + daoID
                            end
                            record_attributes << value.join("; ")
                            record_attributes << download.join("; ")
                        else
                            fsID.split("|").each do |fs|
                                download << "https://archives.albany.edu/downloads/" + fs
                            end
                            value = "https://archives.albany.edu/concern/daos/" + daoID
                            record_attributes << value
                            record_attributes << download.join("; ")
                        end
                    else
                        record_attributes << false
                        record_attributes << nil
                    end
                elsif field == "big_card_uri"
                    if record.big_card
                        #puts "looking for " + record.big_card_files.to_s
                        filenames = record.big_card_files.split("; ")
                        download = []
                        daoID, fsID = espy_lookup[filenames.sort.join("|")]
                        fsID.split("|").each do |fs|
                            download << "https://archives.albany.edu/downloads/" + fs
                        end
                        value = "https://archives.albany.edu/concern/daos/" + daoID
                        record_attributes << value
                        record_attributes << download.join("; ")
                    else
                        record_attributes << false
                        record_attributes << nil
                    end
                elsif field == "reference_material_uri"
                    if record.reference_material
                        #puts record.reference_material_files
                        value = []
                        download = []
                        uuids = []
                        record.reference_material_files.split("; ").each do |filename|
                            #puts "\tlooking for " + filename
                            daoID, fsID = espy_lookup[filename]
                            if fsID.nil? and daoID.nil?
                                #not sure why, but a tiny few are actually tifs
                                daoID, fsID = espy_lookup[filename.split(".")[0] + ".tif"]
                            end
                            download << "https://archives.albany.edu/downloads/" + fsID
                            value << "https://archives.albany.edu/concern/daos/" + daoID
                            #puts "\t" + daoID
                            response = HTTP.get("https://archives.albany.edu/concern/daos/" + daoID + "/manifest", :ssl_context => ctx).body
                            uuid = JSON.parse(response)["sequences"][0]["canvases"][0]["images"][0]["resource"]["@id"]
                            #puts uuid.split("%2Ffiles%2F")[1].split("/full")[0]
                            uuids << uuid.split("%2Ffiles%2F")[1].split("/full")[0]
                            
                        end
                        record_attributes << value.join("; ")
                        record_attributes << download.join("; ")
                        record_attributes << uuids.join("; ")
                    else
                        record_attributes << false
                        record_attributes << nil
                        record_attributes << nil
                    end
                elsif field == "date_execution"
                    value = record.send(field).to_s
                    record_attributes << value
                    if value.include? "-"
                        record_attributes << value.split("-")[0]
                    else
                        record_attributes << value
                    end
                else
                    value = record.send(field).to_s
                    record_attributes << value
                end
                #puts "\t" + value.to_s
            end
            
            csv << record_attributes
            
        end
    end
  end
  
  task :csv, [:arg1] => :environment do |t, args|
  
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
    "owner_name",
    "owner_source_icpsr",
    "owner_source_index",
    "owner_source_big",
    "owner_source_ref",
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
    pass_list = ["year_execution", "index_card_download", "index_card_uuid", "big_card_download", "big_card_uuid", "reference_material_download", "ref_uuid"]
    
    puts args[:arg1].to_s
    count = 0
    total_count = EspyRecord.where("state_abbreviation": args[:arg1].to_s.split("-")).count
    puts "Exporting " + total_count.to_s + " records from " + args[:arg1].to_s + "..."
    
    puts "Reading espyIDs.csv..."
    csv_text = File.read("/opt/lib/espyIDs.csv")
    espy_ids = CSV.parse(csv_text, :headers => true)
    
    headers = []
    fields.each do |field|
        if field == "id"
            headers << field
        else
            headers << field #+ "_tsi"
        end
    end
    
    ctx = OpenSSL::SSL::SSLContext.new
    ctx.verify_mode = OpenSSL::SSL::VERIFY_NONE
    
    full_list = []
    
    if args[:arg1].to_s.include? "-"
        csvOut = "espyAll.csv"
    else
        csvOut = "espy" + args[:arg1].to_s + ".csv"
    end
    
    CSV.open("/home/gw234478/exports/" + csvOut, "wb") do |csv|
        csv << headers
        
        #record = EspyRecord.find(118)
        EspyRecord.where("state_abbreviation": args[:arg1].to_s.split("-")).each do |record|
            count += 1
            count_string = "(" + count.to_s + "/" + total_count.to_s + ")"
            puts count_string + " Exporting " + record.first_name + " " + record.last_name + " " + record.date_execution + "..."
            record_attributes = []
            
            fields.each do |field|
                #puts field
                if change_list.key?(field)
                    value = record.send(change_list[field]).to_s
                    record_attributes << value
                elsif pass_list.include? field
                
                
                elsif field.include? "aspace"
                    aspace_id = record.send(field).to_s
                    if aspace_id.length > 0
                        value = []
                        aspace_id.split("; ").each do |aspace|
                            value << "https://archives.albany.edu/description/catalog/apap301aspace_" + aspace
                        end
                        record_attributes << value.join("; ")
                    else
                        record_attributes << nil
                    end
                elsif field == "index_card_uri"
                    if record.index_card
                        #puts "looking for " + record.index_card_files.to_s
                        filenames = record.index_card_files.split("; ")
                        download = []
                        espy_ids.each do |row|
                            if row[2].split("|").sort == filenames.sort
                                row[1].split("|").each do |fs|
                                    download << "https://archives.albany.edu/downloads/" + fs
                                end
                                value = "https://archives.albany.edu/concern/daos/" + row[0]
                            end
                        end
                        record_attributes << value
                        record_attributes << download.join("; ")
                    else
                        record_attributes << false
                        record_attributes << nil
                    end
                elsif field == "big_card_uri"
                    if record.big_card
                        #puts "looking for " + record.big_card_files.to_s
                        filenames = record.big_card_files.split("; ")
                        download = []
                        espy_ids.each do |row|
                            if row[2].split("|").sort == filenames.sort
                                row[1].split("|").each do |fs|
                                    download << "https://archives.albany.edu/downloads/" + fs
                                end
                                value = "https://archives.albany.edu/concern/daos/" + row[0]
                            end
                        end
                        record_attributes << value
                        record_attributes << download.join("; ")
                    else
                        record_attributes << false
                        record_attributes << nil
                    end
                elsif field == "reference_material_uri"
                    if record.reference_material
                        #puts record.reference_material_files
                        value = []
                        download = []
                        record_attributes << value.join("; ")
                        record_attributes << download.join("; ")
                    else
                        record_attributes << false
                        record_attributes << nil
                    end
                else
                    value = record.send(field).to_s
                    record_attributes << value
                end
                #puts "\t" + value.to_s
            end
            
            csv << record_attributes
            
        end
    end
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