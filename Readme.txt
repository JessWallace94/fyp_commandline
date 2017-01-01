:name, :make, :model, :reg_number, :argc, :repair_loc, :location, :price, :date_requested

puts "\n Listing quotes \n\n".upcase
		quotes = Quote.saved_quotes
		quotes.each do |quot| 
			puts quot.name + " | " + quot.make + " | " + quot.model + " | " + quot.registration + " | " + quot.argc + " | " + quot.location + " | " + quot.price 
		end

		output_action_header("Listing quotes")

		output_quote_table(quotes)
    	puts "Sort using: 'list cuisine or 'list by cuisine' \n\n"