namespace :remaining do
  desc "TODO"
  task folders: :environment do
  
    folders = {}
    count = 0
    Reference.all.uniq{|x| x.folder_name}.each do |folder|
        folders[folder.folder_name] = 0
    end
    
    Reference.all.each do |item|
        if item.used_check
            folders[item.folder_name] += 1
        else
            folders[item.folder_name] -= 1
        end           
    end
    #puts folders
    
    folders.each do |key, array|
        if key.exclude? "International"
            if folders[key] < 0
                left_count = Reference.where("folder_name like ?", key).where(used_check: false).count
                puts key + "|" + left_count.to_s
                count = count + left_count
            end
        end
    end
    
    puts count
  
  end
  
  task items: :environment do
  
    folders = {}
    Reference.all.uniq{|x| x.folder_name}.each do |folder|
        folders[folder.folder_name] = 0
    end
    
    Reference.all.each do |item|
        if item.used_check
            folders[item.folder_name] += 1
        else
            folders[item.folder_name] -= 1
        end           
    end
    #puts folders
    
    folderList = []
    folders.each do |key, array|
        if folders[key] < 0
            folderList << key
        end
    end
    count = 0
    Reference.all.each do |item|
        if folderList.include? item.folder_name
            count += 1                   
        end    
    end
    puts count
  
  end
  
  task challenge_items: :environment do
  
    folders = {}
    Reference.all.uniq{|x| x.folder_name}.each do |folder|
        folders[folder.folder_name] = 0
    end
    
    Reference.all.each do |item|
        if item.used_check
            folders[item.folder_name] += 1
        else
            folders[item.folder_name] -= 1
        end           
    end
    #puts folders
    
    folderList = []
    folders.each do |key, array|
        if folders[key] < 0
            folderList << key
        end
    end
    count = 0
    challengeCount = 0
    Reference.all.each do |item|
        if folderList.include? item.folder_name
            if item.folder_name.length > 28
                challengeCount += 1
            else
                count += 1
            end
        end    
    end
    puts count
    puts challengeCount
  end

end
