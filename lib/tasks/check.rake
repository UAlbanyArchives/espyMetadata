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
  
    EspyRecord.where(reference_material: true).where(icpsr_record_id: nil).each do |record|
    
        date = record.date_execution
        state = record.state_abbreviation
        
        
        find = IcpsrRecord.where("state_abbreviation": state).where("date_execution": date).where("deleted": nil)
        if find.count == 0
        
            puts record.last_name + " " + record.first_name + " " + record.id.to_s + " " + record.date_execution + " " + record.state_abbreviation
            find.each do |thing|
                puts "\t" + thing.name + " " + thing.id.to_s + " " + record.date_execution + " " + record.state_abbreviation
            end
            
        elsif find.count == 1
            unless find[0].icpsr_id.nil?
                puts find[0].name
                #record.icpsr_record = true
                #record.icpsr_record_id = find[0].id
                #record.save
            end
        elsif find.count > 1

            #puts find[0].name
            puts record.last_name + " " + record.first_name + " " + record.id.to_s + " " + record.date_execution + " " + record.state_abbreviation
            find.each do |thing|
                puts "\t" + thing.name + " " + thing.id.to_s + " " + record.date_execution + " " + record.state_abbreviation
            end
            
            #nope
            #unless find[0].icpsr_id.nil?
            #record.icpsr_record = true
            #record.icpsr_record_id = find[0].id
            #record.save

            
        
        end
        
    end
    
    puts EspyRecord.where(reference_material: true).where(icpsr_record_id: nil).count
    
    
  end
    
  task :join, [:arg1, :arg2] => :environment do |t, args|
    puts args[:arg1]
    puts args[:arg2]
    espy = EspyRecord.find(args[:arg1])
    record = IcpsrRecord.find(args[:arg2])
    
    espy.icpsr_record = true
    espy.icpsr_record_id = record.id
    espy.save
  end
  
  


end
