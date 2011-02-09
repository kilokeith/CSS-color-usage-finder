class Swatch 
	
	@@colors = Hash.new
	
	def initialize(c=nil)
		unless c.nil?
			c.downcase!
			if @@colors[c].nil?
				@@colors[c] = 1
			else
				@@colors[c] += 1
			end
		end
	end
	
	def print_all
		colors = @@colors.sort{|x,y| y[1] <=> x[1]}
		colors.each do |colour, num|
			puts "#{colour}:  #{num}"
		end
	end

end


#match 3 or 6 hex colors
def match_hex(line)
	line.scan(/\w\:[\s\w]*(#[a-f0-9]{6}|#[a-f0-9]{3})+/i)
end
#match rgba values
def match_rgba(line)
	line.scan(/\w\:[\s\w]*((?:rgb|hsl)(?:a)?\((?:(?:\s*[\d\.%\-]+)(?:,)?)+\))/i)
end
#match LESS or SASS variables (*color or *backgorund)
def match_variable(line)
	line.scan(/[color|background]\:[\s\w]*([@!][a-z0-9\-_]+)/i)
end


#takes first command arg as the file to search
f = File.new(ARGV[0], "r")
#read file  line by line
while line = f.gets
	colors = Array.new
	#find hex
	hex = match_hex(line)
	colors += hex unless hex.size <= 0
	#find rgb/hsl
	rgba = match_rgba(line)
	colors += rgba unless rgba.size <= 0
	#find vars
	sass_less = match_variable(line)
	colors += sass_less unless sass_less.size <= 0
	
	#make a new swatch for each
	colors.each do |c|
		color = Swatch.new(c.first.to_s)
	end
end

all_colors = Swatch.new
all_colors.print_all