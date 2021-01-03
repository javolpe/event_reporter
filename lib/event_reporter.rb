require 'csv'
require 'terminal-table'
require 'pry'
require './lib/find'
require './lib/queue'
require './lib/help'

class Reporter
  include Queue_commands, Find, Help

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
    holder = []
    CSV.foreach(file, headers: true, header_converters: :symbol){|row| holder << row}
    welcome_message(holder)
  end

  def welcome_message(holder)
    
    contents = clean_initial_data(holder)
    headers = contents[0].headers[1..-1].map{|header| header.to_s} 
    puts "*********************************************************************\n"
    puts "This program works by the user entering commands and the program will then narrow down the list of attendees based on user input."
    puts "To start narrowing down from the full attendees list enter 'find <attribute> <criteria>' (ie: find first_name john).  Attributes are:"
    p     headers
    puts ""
    puts "After that a queue will be created of everyone who matches that specific criteria."  
    puts "If you run 'find <attribute> <criteria>' more than one it will include everyone who matches ALL sets of criteria"
    puts ""
    puts "Queue commands:" 
    puts "queue count, queue clear, queue print, queue print by <attribute>, queue save to <filename.csv>, queue export html <filename.csv>"
    puts "At any time you can enter 'help' to see this list again or 'help <command>' (ie: help queue print) for an explanation of commands."
    puts "Enter 'quit' to exit."
    puts "Please enter your command below >>>"
    command = gets.chomp
    command = command.downcase.strip
    run_command(command, contents)
  end

  def second_message(contents)
    puts "\nEnter Command >>"
    command = gets.chomp
    command = command.downcase
    run_command(command, contents)
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

  def run_command(command, contents)
    execute = command.split
    
    if execute.first == "find" && check_inputed_attribute_is_valid(execute, contents)
      query = filter_for_data(command, contents)
      add_to_queue(query)
      second_message(contents)
    elsif command.strip == "quit" 
        puts "Goodbye"
    elsif execute.first == "queue" && execute.length == 2
      queue_count_clear_or_print(execute, contents)
      second_message(contents)
    elsif execute.first == "queue" && execute.length == 4 
      queue_print_by_save_to_or_export_html(execute, contents)
      second_message(contents)
    elsif execute.first == "help" && execute.length > 1
      extended_help(execute, contents)
      second_message(contents)
    elsif execute.first == "help"
      base_help(contents)
      second_message(contents)
    else 
      puts "INVALID COMMAND"
      second_message(contents)
    end
    
  end

  

  def add_to_queue(query)
    query.map do |row|
      @queue << row
    end
  end


end

cat = Reporter.new
cat.load_file