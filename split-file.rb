#!/usr/bin/env ruby

require 'optparse'
require 'csv'

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: split-file.rb --out [directory] --file [filename]"

  opts.on("--out [ARG]", "Output Directory") do |v|
    options[:output] = v
  end
  opts.on("--file [ARG]", "input file") do |v|
    options[:file] = v
  end
  opts.on("--trial", "trail run") do |v|
    options[:trial] = true
  end
end.parse!

file = options[:file]
seq = 0
fileindex = 0
currentfile = File.open( File.join( options[:output], "#{fileindex}-data.csv"), 'w') unless options[:trial]

CSV.foreach(file, :col_sep => ",") do |row|
  recorded = row[0].to_i
  x = row[1].to_i
  y = row[2].to_i

  if recorded == 1 && x == 1 && y == 1
    puts "File #{fileindex} has #{seq} lines" 
    seq = 0
    fileindex += 1
    unless options[:trial]
      currentfile.close
      currentfile = File.open( File.join( options[:output], "#{fileindex}-data.csv"), 'w')
    end
  elsif !options[:trial]
    currentfile.write("#{recorded},#{x},#{y}\n")
  end
  seq += 1
end

currentfile.close unless options[:trial]



