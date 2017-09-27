# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

=begin
index_cards = File.read(Rails.root.join('lib', 'seeds', 'indexCardsAspace.csv'))
indexData = CSV.parse(index_cards, :headers => true, :encoding => 'ISO-8859-1', :col_sep => "|")
indexData.each do |row|
  t = IndexCard.new
  t.state_abbreviation = row['state_abbreviation']
  t.root_filename = row['root_filename']
  t.file_group = row['file_group']
  t.ocr_text = row['ocr_text']
  t.used_check = false
  t.aspace = row['aspace']
  t.save
  puts t.errors.full_messages
  puts "#{t.state_abbreviation} - #{t.root_filename} saved"

end

puts "There are now #{IndexCard.count} rows in the table"


icpsr_records = File.read(Rails.root.join('lib', 'seeds', 'IcpsrRecords.csv'))
icpsrData = CSV.parse(icpsr_records, :headers => true, :encoding => 'ISO-8859-1', :col_sep => "|")
icpsrData.each do |row|

  def true?(obj)
    obj.to_s == "true"
  end

  begin
	  dateString = row['date_execution']
	  if dateString.length == 4
	    parsedDate = Date.strptime(row['date_execution'], "%Y")
	  elsif dateString.length == 7
	    parsedDate = Date.strptime(row['date_execution'], "%Y-%m")
	  else
	    parsedDate = Date.strptime(row['date_execution'], "%Y-%m-%d")
	  end
	  finalDate = row['date_execution']
  rescue
  	finalDate = row['date_execution'] + " (DATE ERROR!)"
  end

  
  t = IcpsrRecord.new
  t.used_check = false
  t.icpsr_id = row['icpsr_id']
  t.name = row['name']
  t.date_execution = finalDate
  t.age = row['age']
  t.race = row['race']
  t.sex = row['sex']
  t.occupation = row['occupation']
  t.crime = row['crime']
  t.execution_method = row['execution_method']
  t.location_execution = row['location_execution']
  t.jurisdiction = row[' jurisdiction']
  t.state = row['state']
  t.state_abbreviation = row['state_abbreviation']
  t.county_code = row['county_code']
  t.county_name = row['county_name']
  if row['compensation_case'] == "True"
    t.compensation_case = true
  else
    t.compensation_case = false
  end
  t.icpsr_state = row['icpsr_state']
  t.save
  puts t.errors.full_messages
  puts "#{t.state_abbreviation} - #{t.name} saved"

end
puts "There are now #{IcpsrRecord.count} rows in the table"

big_cards = File.read(Rails.root.join('lib', 'seeds', 'bigCards.csv'))
bigData = CSV.parse(big_cards, :headers => true, :encoding => 'ISO-8859-1', :col_sep => "|")
bigData.each do |row|
  t = BigCard.new
  t.state_abbreviation = row['state_abbreviation']
  t.root_filename = row['root_filename']
  t.file_group = row['file_group']
  t.ocr_text = row['ocr_text']
  t.used_check = false
  t.aspace = row['aspace']
  t.save
  puts t.errors.full_messages
  puts "#{t.state_abbreviation} - #{t.root_filename} saved"

end

puts "There are now #{BigCard.count} rows in the table"


reference_data = File.read(Rails.root.join('lib', 'seeds', 'reference.csv'))
reference = CSV.parse(reference_data, :headers => true, :encoding => 'ISO-8859-1', :col_sep => "|")
reference.each do |row|
  t = Reference.new
  t.filename = row['filename']
  t.used_check = false
  t.aspace = row['aspace']
  t.folder_name = row['folder_name']
  t.active = false
  t.save
  puts t.errors.full_messages
  puts "#{t.filename} saved"

end
=end