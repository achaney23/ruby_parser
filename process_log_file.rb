#!/usr/bin/env ruby

def convert_to_boolean value
	change_value = false
	return_value = value
	case value
	when 'yes', 'on', 'true'
		return_value = true
		change_value = true
	end
	
	case value
	when 'no', 'off', 'false'
		return_value = false
		change_value = true
	end
	
  return return_value, change_value
end

def convert_to_non_string value
	change_value = false
	return_value = value

	if value.numeric?
		change_value = true
		return_value = value.to_f
		if value.to_s == return_value.to_s
			return return_value, change_value
		end
		return_value = value.to_i
		return return_value, change_value
	end

	return return_value, change_value
end

def show_output type, value
	puts "type: #{type}, value: #{value}, Value Class: #{value.class}" 
end

class String
  def numeric?
    return true if self =~ /^\d+$/
    true if Float(self) rescue false
  end
end  

def main input_file
	File.open(input_file, 'r') do |f1|  
		while line = f1.gets 
			next if line.chars.first == "#" 
			log_line = line.split( /= */ )
			type = log_line[0].strip
			value = log_line[1].strip
			value, change_value = convert_to_boolean value
			if change_value
				show_output type, value
				next
			end
			value, change_value = convert_to_non_string value
			if change_value
				show_output type, value
				next
			end
			show_output type, value
		end
	end
end

input_file = ARGV[0] ? ARGV[0] : "data.txt" 
if File.exist?(input_file)
	main input_file
else
	puts "Error: File does not exist"
end
