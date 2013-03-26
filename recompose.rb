#!/usr/bin/env ruby

require 'optparse'
require 'fileutils'
#require 'chunky_png'
require 'oily_png'

options = {
  :output_x => 2560,
  :output_y => 1600,
  :original_x => 1024,
  :original_y => 1024,
  :scale => 1.0
}

class Float
  def map_space(start1, stop1, start2, stop2)
    start2 + (stop2 - start2) * ((self - start1) / (stop1 - start1))
  end
end

OptionParser.new do |opts|
  opts.banner = "Usage: recompose.rb --data [directory] --key [key] --out [directory]"

  opts.on("--data [ARG]", "Input Data") do |v|
    options[:data] = v
  end
  opts.on("--out [ARG]", "Output Directory") do |v|
    options[:output] = v
  end
  opts.on("--key [ARG]", "File key") do |v|
    options[:key] = v
  end
end.parse!

def tokenize(file)
  File.basename(file, ".png").split('-')
end

def tokenstofile(t)
  "#{t[0]}-#{t[1]}-#{t[2]}-#{t[3]}.png"
end

def compute_new_xy(x, y, options)
  { 
    :x => x.map_space(0.0, options[:original_x].to_f, 0, options[:output_x].to_f - options[:original_x].to_f).to_i,
    :y => y.map_space(0.0, options[:original_y].to_f, 0, options[:output_y].to_f - options[:original_y].to_f).to_i
  }
end

def status(xy, f, seq, length, start, actual)
  pc = (seq / length) * 100.0
  s1 = seq + 1
  elapsed = Time.now - start
  avg = elapsed / actual
  remaining = length - seq
  left = ((remaining * avg) / 60.0).round(2)
  puts "#{xy} => #{f} \n\t(#{s1.to_i}/#{length.to_i} #{pc.round(2)}% done [#{left} min remaining] #{avg.round(2)} sec per frame)"
end

files = Dir.glob("#{options[:data]}/#{options[:key]}-*.png")
seq = 0
actual = 1
puts "Processing #{files.length} files"
start = Time.now

files.each do |f|
  tokens = tokenize f
  newfile = File.join( options[:output], tokenstofile(tokens) )
  
  if !File.exists? newfile
    of = ChunkyPNG::Image.from_file f
    nf = ChunkyPNG::Image.new options[:output_x], options[:output_y], ChunkyPNG::Color::TRANSPARENT
    xy = compute_new_xy tokens[2].to_f, tokens[3].to_f, options
    status xy, File.basename(f), seq.to_f, files.length.to_f, start, actual
    nf.replace! of, xy[:x], xy[:y]
    nf.save newfile
    actual += 1
  else
    puts "skipping #{File.basename(f)}"
  end
  seq += 1
end



