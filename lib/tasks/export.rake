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