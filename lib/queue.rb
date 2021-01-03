require 'terminal-table'
require './lib/find'

module Queue_commands
  
  def queue_count_clear_or_print(execute, contents)
    if execute.last == "count"
      queue_count
    elsif execute.last == "clear"
      @queue = []
    elsif execute.last == "print"
      queue_print
    else 
      puts "Invalid queue command"
      second_message(contents)
    end
  end

  def queue_count
    puts "**************************************"
    puts "queue count #{@queue.length}"
    puts "**************************************"
  end

  def queue_print
    x = @queue.count
    print = []
    print = @queue.each{|row| print << row}
    i = 0
    print_table = Terminal::Table.new do 
      self.headings = ["LAST NAME", 'FIRST NAME', 'EMAIL', 'ZIPCODE', 'CITY', 'STATE', 'ADDRESS', 'PHONE']
        x.times do
          add_row([print[i][:last_name], print[i][:first_name], print[i][:email_address], print[i][:zipcode], print[i][:city], print[i][:state], print[i][:street], print[i][:homephone]])
          i +=1
        end 
    end
    puts print_table
  end

  def queue_print_by_attribute(attribute)
    attribute = attribute.last.to_sym
    x = @queue.count
    print = []
    print = @queue.each{|row| print << row}
    final = print.sort_by{|row| row[attribute]}
    i = 0
    print_table = Terminal::Table.new do 
      self.headings = ["LAST NAME", 'FIRST NAME', 'EMAIL', 'ZIPCODE', 'CITY', 'STATE', 'ADDRESS', 'PHONE']
        x.times do
          add_row([final[i][:last_name], final[i][:first_name], final[i][:email_address], final[i][:zipcode], final[i][:city], final[i][:state], final[i][:street], final[i][:homephone]])
          i +=1
        end 
    end
    puts print_table
  end

  def queue_clear 
    @queue = []
  end

  def check_inputed_attribute_is_valid_queue(execute, contents)
    attribute = execute.last.downcase
    all_attributes = contents[0].headers[1..-1].map{|attribute| attribute.to_s} 
    if all_attributes.any?{|word| word == attribute} == false
      puts "******************************************"
      puts "INVALID ATTRIBUTE ENTRY. CHECK SPELLING AND INCLUDE _ WHEN NEEDED"
      sleep(2)
      second_message(contents)      
    else 
      true
    end
  end

  def queue_print_by_save_to_or_export_html(execute, contents)
    if (execute[1]+execute[2]) == "printby"
      check_inputed_attribute_is_valid_queue(execute, contents)
      queue_print_by_attribute(execute)
    elsif (execute[1]+execute[2]) == "saveto"
      check_valid_formatting(execute, contents)
      queue_save_to(execute, contents)
    end

  end

  def queue_save_to(execute, contents)
    file_name = execute.last
    CSV.open(file_name, 'wb') do |csv|
      csv << contents[0].headers
      @queue.map do |row|
        csv << row
      end
    end
    puts "saved to file"
  end

  def queue_export_html(execute)
    puts "nahhhhhhh didn't do this one, next time though for sure"
  end

  def check_valid_formatting(execute, contents)
    file_name = execute.last[-4..-1]
    if file_name != ".csv"
      puts "IMPROPER FILE FORMAT, FILE NEEDS TO BE .CSV"
    end
  end

end

