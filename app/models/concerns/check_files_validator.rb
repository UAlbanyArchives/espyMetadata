class CheckFilesValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
  	if value.include? "; "
  		value.split('; ').each_with_index do |file, index|
		  	unless File.file?(Rails.root.join("public", "images", "smallCards", file))
		  		fileIndex = index + 1
				record.errors.add(attribute, " file " + fileIndex.to_s + " is not present")
			end
		end
	else
		unless File.file?(Rails.root.join("public", "images", "smallCards", value))
	    	record.errors.add(attribute, " is not present")
	    end
	end
  end
end