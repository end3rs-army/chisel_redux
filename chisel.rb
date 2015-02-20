class Chisel

	attr_reader :doc, :sentances, :lines

	def initialize(doc)
		@lines = {}
		@sentances = []
		@doc = doc
		@number_bullet = false
	end

	def split
		#Splits each line of document into an array
		@sentances = @doc.split("\n")
	end

	def doc_hash
		#Adds each line of the document to a hash with key equal to line number
		@sentances.each_with_index {|words,index| @lines[index] = words}
		#Splits each hash value into parts (words, characters, etc.)
		(0..@sentances.size-1).map {|x| @lines[x] = @lines[x].scan(/\S+|\n+|\t+| |/)}
	end

	def head_format
		(0..@sentances.size-1).each do |key|
			number = @lines[key][0].length
			@lines[key][0].include?("#") ? @lines[key][0] = "<h#{number}>" : ()
			@lines[key][0].include?("<h") ? @lines[key] << "</h#{number}>" : ()
		end
	end

	def para_collect
		(1..@sentances.size-1).each do |key|
			unless @lines[key][0].include?("<h") || @lines[key][0].include?("<l>") || @lines[key][0] == ""
				@lines[key-1].unshift "<p>" if @lines[key-1][0] == ""
				@lines[key+1].unshift "</p>" if @lines[key+1][0] == "" && @lines[key][0] != "</p>" && key <@sentances.size 
			end
		end
	end

	def strong_format
		#puts @lines[0]
		(0..@sentances.size-1).each do |key|
			@lines[key] = @lines[key].map {|words| words.start_with?("**") ? words.sub("**","<strong>") : (words)}
			@lines[key] = @lines[key].map {|words| words.end_with?("**") ? words.sub("**","</strong>") : (words)}
		end
	end

	def em_format
		(0..@sentances.size-1).each do |key|
			@lines[key] = @lines[key].map {|words| words.start_with?("*") ? words.sub("*","<em>") : (words)}
			@lines[key] = @lines[key].map {|words| words.end_with?("*") ? words.sub("*","</em>") : (words)}	
		end
	end

	def bullet_format
		(0..@sentances.size-1).each do |key|
			@lines[key][0].include?("*") ? @lines[key][0] = "<l>" : ()
			@lines[key][0].include?("<l>") ? @lines[key] << "</l>" : ()
		end
	end

	def number_bullet_format
		(0..@sentances.size-1).each do |key|
			@number_bullet = false
			number_cruncher(@lines[key][0])
			@number_bullet ? @lines[key][0] = "<l>" : ()
			@number_bullet ? @lines[key] << "</l>" : ()
		end
	end

	def number_cruncher(numcheck)
		(0..1000).each do |n|
			numcheck == n.to_s + "." ? @number_bullet = true : ()
		end  
	end

	def tidy_up
		(0..@sentances.size-1).each do |key|
			@lines[key][0].include?("<h") || @lines[key][0].include?("<l>") ? @lines[key].delete_at(1) : ()
		end
	end

	def parse
		split
		doc_hash
		head_format
		strong_format
		bullet_format
		number_bullet_format
		para_collect
		em_format
		tidy_up
		print
	end

	def print
		(0..@sentances.size-1).each do |key| 
			unless @lines[key][0].include?("<h") || @lines[key][0].include?("</h") || @lines[key][0].include?("<p>") || @lines[key][0].include?("</p>")
				puts "\t#{@lines[key].join("")}"
			else
				puts @lines[key].join("")
			end
		end
	end
end

chi = Chisel.new('# My Life in Desserts

## Chapter 1: The Beginning

"You just *have* to try the cheesecake," he said. "Ever since it appeared in
**Food & Wine** this place has been packed every night."


My favorite cuisines are:

1. Sushi
2. Barbeque
3. Mexican

This is because

* They are awesome
* I like hot stuff

##### This is a NEW HEADING
')

chi.parse


