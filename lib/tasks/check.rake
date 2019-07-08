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


end
