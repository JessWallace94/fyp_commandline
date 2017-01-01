require_relative 'support/number_helper'
class Quote 
	include NumberHelper

	# class variable, so we do not need an instance for file path
	@@filepath = nil

	#class methods 

	def self.filepath=(path=nil)
		@@filepath = File.join(APP_ROOT, path)
	end

	attr_accessor :name, :make, :model, :registration, :argc, :location, :price

	def self.file_exists?
		# quote class should know if file exists or not 
		# check if filepath is true and if file exists in filepath
		if @@filepath && File.exists?(@@filepath)
			return true 
		else
			return false
		end
	end

	def self.file_usable? 
		return false unless @@filepath # (return false unless filepath is true)
		return false unless File.exists?(@@filepath) # (return false unless file exists)
		return false unless File.readable?(@@filepath) # (return false unless file is readable)
		return false unless File.writable?(@@filepath) # (return false unless file is writable)
		return true #(else return true)
	end

	def self.create_file
		# create quote file 
		File.open(@@filepath, 'w') unless file_exists?
		return file_usable?
	end

	def self.saved_quotes
		# read the quote file 
		quotes = []
		if file_usable? 
			file = File.new(@@filepath, 'r')
			file.each_line do |line | 
				quotes << Quote.new.import_line(line.chomp)
			end
		file.close
		end
		return quotes
		# return instances of the file
	end

	def self.build_using_questions 
		args = {}

		print "Customer Name: "
		args[:name] = gets.chomp.strip

		print "Vehicle Make: "
		args[:make] = gets.chomp.strip
		
		print "Vehicle Model: "
		args[:model] = gets.chomp.strip
		
		print "Vehicle Registration: "
		args[:registration] = gets.chomp.strip
		
		print "Argc Code: "
		args[:argc] = gets.chomp.strip
		
		print "Customer Location: "
		args[:location] = gets.chomp.strip
		
		print "Quoted Price: "
		args[:price] = gets.chomp.strip

		return self.new(args)
	end

	# instance methods 

	def initialize(args={})
		@name = args[:name] 				|| ""
		@make = args[:make] 				|| ""
		@model = args[:model] 				|| ""
		@registration = args[:registration] || ""
		@argc = args[:argc] 				|| ""
		@location = args[:location] 		|| ""
		@price = args[:price] 				|| ""
	end

	def import_line(line)
		line_array = line.split("\t")
		@name, @make, @model, @registration, @argc, @location, @price = line_array
		return self
	end


	def save 
		return false unless Quote.file_usable?
		File.open(@@filepath, 'a') do |file| 
			file.puts "#{[@name, @make, @model, @registration, @argc, @location, @price].join("\t")}\n"
		end
		return true
	end

	def formatted_price
		number_to_currency(@price)
	end

end 