require_relative 'quote'
require_relative 'support/string_extender'
class Guide 
	class Config 
		@@actions = ['list', 'find', 'add', 'quit']
		def self.actions; @@actions; end
	end

	def initialize(path=nil)
    # locate the quote text file at path
    	Quote.filepath = path
		    if Quote.file_usable?
		      puts "Found quote file."
		    # or create a new file
		    elsif Quote.create_file
		      puts "Created quote file."
		    # exit if create fails
		    else
		      puts "Exiting.\n\n"
		      exit!
		    end
  	end

	def launch! 
		introduction 
		# action loop
		result = nil 
		until result == :quit 
			# what do you want to do (list,find,add,quit)
			action, args = get_action
			# do that action 
			result = do_action(action, args)
		end
		conclusion
	end

	def get_action
		action = nil
		# keep asking for user input until we gert a valid action
		until Guide::Config.actions.include?(action)
			puts "Actions: " +Guide::Config.actions.join(", ") if action
			print "> "
			user_response = gets.chomp
			args = user_response.downcase.strip.split(" ")
			action = args.shift
		end
		return action, args
	end

	def do_action(action,args=[])
		case action 
		when 'list'
			list
		when 'find'
			keyword = args.shift
			find(keyword)
		when 'add'
			add
		when 'quit'
			return :quit
		else
			puts "\n I don't understand that command \n\n"
		end
	end

	# action classes 

	def list(args=[])
	  	sort_order = args.shift 
	  	sort_order = args.shift if sort_order == 'by'
	  	sort_order = "name" unless ['name', 'make', 'model', 'registration', 'argc', 'location', 'price'].include?(sort_order)

	    output_action_header("Listing quotes")

	    quotes = Quote.saved_quotes
	    quotes.sort! do |q1,q2|
	    	case sort_order
			when 'name'
				q1.name.downcase <=> q2.name.downcase
			when 'make'
				q1.make.downcase <=> q2.make.downcase
			when 'model'
				q1.model.downcase <=> q2.model.downcase
			when 'registration'
				q1.registration.downcase <=> q2.registration.downcase
			when 'argc'
				q1.argc.downcase <=> q2.argc.downcase
			when 'location'
				q1.location.downcase <=> q2.location.downcase
			when 'price'
				q1.price.to_i <=> q2.price.to_i
			end
	    end
	    output_quote_table(quotes)
	    puts "Sort using: 'list registration or 'list by argc code' \n\n"
  	end

	def find(keyword="") 
  		output_action_header("Find a quote")
  		if keyword 
	  		quotes = Quote.saved_quotes
	  		found = quotes.select do |quot|
		  		quot.name.downcase.include?(keyword.downcase) ||
		  		quot.make.downcase.include?(keyword.downcase) ||
		  		quot.model.downcase.include?(keyword.downcase) ||
		  		quot.registration.downcase.include?(keyword.downcase) ||
		  		quot.argc.downcase.include?(keyword.downcase) ||
		  		quot.location.downcase.include?(keyword.downcase) ||
		  		quot.price.to_i <= keyword.to_i
		  	end
	  	output_quote_table(found)
  		else 
  		puts "Find using a key phrase to search the quote list."
  		puts "Examples: 'find ford', 'find polo', 'find fast food'\n\n"
  		end
	end

	def add 
		output_action_header("\n Add a quote \n\n")
		quote = Quote.build_using_questions
		if quote.save
			puts "\nQuote saved!\n\n"
		else
			puts "\nError saving quote. Please try again later!\n\n"
		end
	end

	def introduction
		puts "\n <<< Welcome to Screen-Tec Windscreens Quote Management Application >>> \n\n"
	end

	def conclusion 
		puts "\n <<< We hope you found everything you were looking for! Goodbye. >>> \n\n"
	end

	def output_action_header(text)
		puts "\n#{text.upcase.center(100)}\n\n"
 	end

	def output_quote_table(quotes=[])
		print " " + "Name".ljust(20)
		print " " + "Make".ljust(10)
		print " " + "Model".ljust(10)
		print " " + "Registration".ljust(15)
		print " " + "Argc".ljust(10)
		print " " + "Location".ljust(20)
		print " " + "Price".rjust(4) + "\n"
		puts "-" * 100
		quotes.each do |quot|
			line = " " << quot.name.titleize.ljust(20)
			line << " " + quot.make.titleize.ljust(10)
			line << " " + quot.model.titleize.ljust(10)
			line << " " + quot.registration.capitalize.ljust(15)
			line << " " + quot.argc.titleize.ljust(10)
			line << " " + quot.location.capitalize.ljust(20)
			line << " " + quot.formatted_price.rjust(4)
			puts line
		end
		puts "No listings found" if quotes.empty?
		puts "-" * 100
  	end
end 