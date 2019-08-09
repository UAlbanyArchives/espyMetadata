namespace :check do
  desc "TODO"
  task references: :environment do
  
    EspyRecord.all.each do |espy|
        check = true
        files = []
        espy.reference_material_files.split("; ").each do |ref|
            files << ref
        end
        espy.reference_material_id.split("; ").each do |refID|
            record = Reference.find(refID)
            unless files.include?(record.filename)
                puts ("!!!")
                check = false
            end
        end
        if check == false
            puts espy.id
        end
    
    end
    
  end
  
  task icpsr: :environment do
  
    EspyRecord.where("icpsr_record": false).where("index_card": nil).each do |record|
    
        date = record.date_execution
        state = record.state_abbreviation
        find = IcpsrRecord.where("state_abbreviation": state).where("date_execution": date)
        if find.count == 0
            
        else
            if find.count > 1

                #puts find[0].name
                puts record.last_name + " " + record.first_name + " " + record.id.to_s
                find.each do |thing|
                    puts "\t" + thing.name + " " + thing.id.to_s
                end
                
                #nope
                #unless find[0].icpsr_id.nil?
                #record.icpsr_record = true
                #record.icpsr_record_id = find[0].id
                #record.save

                
            end
        end
        
    end
    
    puts EspyRecord.where("icpsr_record": false).where("index_card": nil).count
    
    
  end
    
  task :join, [:arg1] => :environment do |t, args|
    puts args[:arg1]
  end
  
  task uncheck: :environment do
  
  
    
  end


end
