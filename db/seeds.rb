require "csv"

# Iterate through all files in the seeds/ directory and create missing records
#
# The first column is the identifier
Pathname.new(Rails.root + "db/seeds").each_child do |csv_pathname|

  extname = csv_pathname.extname
  model = csv_pathname.basename.to_s.gsub(extname, '').singularize.classify.constantize

  # Check if we should update records for this class
  update_records = (ENV["UPDATE_RECORDS_FOR_CLASS"] =~ /#{model}/) ? true : false

  case extname
  when ".csv"
    csv = CSV.new csv_pathname.read, headers: true, return_headers: true, col_sep: ";"
    table = csv.read
    unique_identifier = table.headers.first

    table.each_entry do |entry|
      next if entry.header_row?

      # find the record from the unique_identifier column (case insensitive)
      record = model.where(
        model
          .arel_table[unique_identifier]
          .matches(entry[unique_identifier])
      ).first

      # Initialize a new record if an existing one could not be found
      record ||= model.new unique_identifier => entry[unique_identifier]

      # stop processing this record here unless we allow record updates or this
      # is a new record
      next unless (update_records || record.new_record?)

      # set the record attributes from the CSV rom
      record.attributes = entry.to_hash

      # Try to save the record
      #
      # if save! fails, print the unique identifier and raise the record errors
      begin
        record.save!
        print "Seeded #{model} record".colorize(:green)
        puts " '#{entry[unique_identifier]}'"
      rescue ActiveRecord::RecordInvalid => e
        print "Error seeding #{model} record".colorize(:red)
        puts " '#{entry[unique_identifier]}'"
        puts e.to_s.colorize(:red)
      rescue ActiveRecord::RecordNotUnique => e
        print "Error seeding #{model} record".colorize(:red)
        puts " '#{entry[unique_identifier]}'"
        puts e.to_s.colorize(:red)
      end
    end
  end

end
