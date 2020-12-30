require 'csv'
require 'pry'

class Reporter
  
  def initialize()
     @queue = []
  end

  def load_file
    puts ""
    puts "Welcome to Event Reporter! This program is intended to help you search the list of attendees to find specific individuals."
    puts "Enter the file you want to load by typing in the file name exactly."
    puts "Hit enter for full event attendees list."
    
      root = Dir.entries(".") 
      files = root.select do |file|
                file.to_s[-3..-1] == "csv"
              end
      puts "#{files}"
      puts "load>"
      file = gets.chomp
  
      if files.include?(file)
        file  
      elsif file ==""
        file = "full_event_attendees.csv"
      else
        puts "****************************************"
        puts "Improper entry.  Spelling MUST be exact"
        puts "****************************************"
        sleep(1)
        load_file
      end
  end

  def data_query
    holder = []
    CSV.foreach("#{load_file}", headers: true, header_converters: :symbol){|row| holder << row}
    
    contents = clean_initial_data(holder)
    
    puts "******************************************"
    puts "queue count #{@queue.length}"
    puts "******************************************"
    puts "  This program works by the user entering commands and the program will then narrow down the list of attendees based on user input."
    puts "  To start narrowing down from the full attendees list enter 'find <attribute> <criteria>' (ie find first_name john)"
    puts "  Your queue"
    
    # query = @find.find_method(contents)
    # query = @queue.start(query)
    binding.pry
  end


  def clean_initial_data(contents)
    contents.each do |row|
      row[:first_name]    = row[:first_name].to_s.downcase.rjust(1," ")
      row[:last_name]     = row[:last_name].to_s.downcase.rjust(1," ")
      row[:email_address] = row[:email_address].to_s.downcase.rjust(1," ")
      row[:homephone]     = row[:homephone].to_s.rjust(1," ").delete('^0-9')
      row[:street]        = row[:street].to_s.downcase.rjust(1," ")
      row[:city]          = row[:city].to_s.downcase.rjust(1," ")
      row[:state]         = row[:state].to_s.downcase.rjust(1," ")
      row[:zipcode]       = row[:zipcode].to_s.rjust(5,"0")[0..4]
    end 
  end

end

cat = Reporter.new
cat.data_query