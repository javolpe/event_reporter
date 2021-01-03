module Find

  def filter_for_data(command, contents)
    execute = command.split(" ", 3) 
    query = []
    category = execute[1]
    category = :"#{category}"
    criteria = execute.last.strip
  
    contents.map do |row| 
      if row[category].downcase == criteria
        query << row
      end
    end
    query
  end

  def check_inputed_attribute_is_valid(execute, contents)
    attribute = execute[1]
    all_attributes = contents[0].headers[1..-1].map{|attribute| attribute.to_s} 
    if all_attributes.any?{|word| word == attribute} == false
      puts "******************************************"
      puts "INVALID HEADER ENTRY. CHECK SPELLING AND INCLUDE _ WHEN NEEDED"
      sleep(2)
      second_message(contents)      
    else 
      true
    end
  end

end