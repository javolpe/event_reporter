module Help

  def base_help(contents)
    headers = contents[0].headers[1..-1].map{|header| header.to_s} 
    puts "find <attribute> <criteria>' (ie: find first_name john)"
    puts "Available attributes for this file are:"
    puts "\n"
    puts headers
    puts "\nQueue commands:" 
    puts "queue count, queue clear, queue print, queue print by <attribute>, queue save to <filename.csv>, queue export html <filename.csv>"
    puts "Enter 'quit' to exit."
  end

  def extended_help(execute, contents)
    if execute[1] == "find"
      help_find(contents)
    elsif execute[1] == "queue" && execute.length == 3
      help_queue_count_clear_or_print(execute)
    elsif execute[1] == "queue" && execute.length == 4
      help_queue_print_by_save_to(execute)
    end
  end

  def help_queue_print_by_save_to(execute)
    if (execute[2]+execute[3]) == "printby"
      help_print_by
    elsif (execute[2]+execute[3]) == "saveto"
      help_save_to
    elsif (execute[2]+execute[3]) == "exporthtml"  
      help_export_html
    else 
      puts "INVALID HELP COMMAND"
    end
  end

  def help_export_html
    puts "Use the command 'queue export html <filename.csv>' to save the queue as a valid HTML file that will display as a table."
    puts "Problem is that I didn't actually build out this functionality so this shit don't work at all."
  end

  def help_save_to
    puts "Use the command 'save to <filename.csv> to save the queue to a new file of a name of your choosing."
    puts "The file will be saved into the directory/folder that the original csv files are located in."
  end

  def help_print_by
    puts "Use the command 'print by <attribute>' to print out the filtered queue in ascending order of the attribute you enter along with the command."
    puts "For instance if you put in 'print by zipcode' the computer will output a table of everyone in the queue sorted by zipcode, lowest to highest."
  end

  def help_find(contents)
    headers = contents[0].headers[1..-1].map{|header| header.to_s} 
    puts "find <attribute> <criteria>' (ie: find first_name john)"
    puts "Available attributes for this file are:"
    puts headers
    puts "Enter something like 'find last_name johnson' but without the quotes, you can do it, I believe in you!!"
  end

  def help_queue_count_clear_or_print(execute)
    if execute.last == "clear"
      help_queue_clear
    elsif execute.last == "print"
      help_queue_print
    elsif execute.last == "count"
      help_queue_count
    else 
      puts "INVALID HELP ENTRY"
    end
  end

  def help_queue_clear
    puts "By inputing queue clear you are clearing the queue back to empty.  There will be NOTHING in the queue."
    puts "You will NOT be resetting the original file you chose to start the program.  Only way to do that is to quit the program and restart it"
  end

  def help_queue_print
    puts "By inputing queue clear you are printing the queue to the screen in a table format.  The rows are not organized in any discernible way."
    puts "Becuase you chose to print and not print by the rows are simply being outputed to the screen in the order they were created in the original CSV file."
  end

  def help_queue_count
    puts "This just outputting the number of records that were found after you used the find command.  Did you really need an explanation for this?"
  end

end