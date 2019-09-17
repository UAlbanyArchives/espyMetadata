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
        puts record.first_name + " " + record.last_name
        puts "\t" + record.id.to_s
        puts "\t" + date
        puts "\t" + state
        
        unless record.icpsr_id.nil?
        
            match = IcpsrRecord.where("icpsr_id": record.icpsr_id)
            puts "Exact Match: " + match.name
        
        else
        
            find = IcpsrRecord.where("state_abbreviation": state).where("date_execution": date).where("deleted": nil)
            
            if find.count == 0
            
                #puts record.last_name + " " + record.first_name + " " + record.id.to_s + " " + record.date_execution + " " + record.state_abbreviation
                #find.each do |thing|
                #    puts "\t" + thing.name + " " + thing.id.to_s + " " + record.date_execution + " " + record.state_abbreviation
                #end
                
            elsif find.count == 1

                puts "\tFound: " + find[0].name
                #puts record.first_name + " " + record.last_name
                #record.icpsr_record = false
                #record.icpsr_record_id = find[0].id
                #puts "\tsaving with " + find[0].id.to_s
                #record.save
            elsif find.count > 1

                #puts find[0].name
                #puts record.last_name + " " + record.first_name + " " + record.id.to_s + " " + record.date_execution + " " + record.state_abbreviation
                #find.each do |thing|
                #    puts "\t" + thing.name + " " + thing.id.to_s + " " + record.date_execution + " " + record.state_abbreviation
                #end
                
                #nope
                #unless find[0].icpsr_id.nil?
                #record.icpsr_record = false
                #record.icpsr_record_id = find[0].id
                #record.save
                
                

            end
            
            nameMatch = []
            IcpsrRecord.where("state_abbreviation": state).where("deleted": nil).each do |icpsr|
                if icpsr.name.length > 1
                    if icpsr.name.start_with? record.last_name + " " + record.first_name
                         nameMatch << icpsr        
                    end                    
                end                    
            end
            if nameMatch.length == 1
                #puts record.first_name + " " + record.last_name
                #puts "\t" + date
                #puts "\t" + state
                puts "\tfound " + nameMatch[0].name
                #puts "\t" + nameMatch[0].date_execution
                #record.icpsr_record = false
                #record.icpsr_record_id = nameMatch[0].id
                #puts "\tsaving with " + nameMatch[0].id.to_s
                #record.save
            else
                #if date match too

            end
        end
        
        
        
    end
        
    puts EspyRecord.where(reference_material: true).where(icpsr_record_id: nil).count
    
    fixes = [[000, 00000],
        [000, 00000],
        [000, 00000],
        [000, 00000],
        [000, 00000],
        [000, 00000]]
        
        #fixes.each do |set|
        #    record = EspyRecord.find(set[0])
        #    puts "fixing " + record.first_name + " " + record.last_name + " " + record.date_execution
        #    refRec = IcpsrRecord.find(set[1])
        #    puts "\t" + refRec.name
        #    puts "\t" + refRec.date_execution
        #    
        #    record.icpsr_record = false
        #    record.icpsr_record_id = refRec.id
        #    record.save
        #end
        
        #make used if used
    
    
    
  end
  
  task index_fix: :environment do
  
    EspyRecord.all.each do |record|
        unless record.icpsr_record_id.nil?
            icpsr_record = IcpsrRecord.find(record.icpsr_record_id)
            if icpsr_record.used_check == false
                puts icpsr_record.name
                icpsr_record.used_check = true
                icpsr_record.save
            end
        end
        
    
    end
    
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
