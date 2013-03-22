#!/usr/bin/env ruby

require 'optparse'
require 'csv'
require './lib/libdejong'
require 'fileutils'

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: convert_wii.rb --data [directory] --out [directory] --tag [tag] --file [filename]"

  opts.on("--data [ARG]", "Input Data") do |v|
    options[:data] = v
  end
  opts.on("--out [ARG]", "Output Directory") do |v|
    options[:output] = v
  end
  opts.on("--file [ARG]", "input file") do |v|
    options[:file] = v
  end
  opts.on("--tag [ARG]", "output file tag") do |v|
    options[:tag] = v
  end

end.parse!


file = options[:file] 
seq = 0


CSV.foreach(file, :col_sep => ",") do |row|
  recorded = row[0].to_i
  x = row[1].to_i
  y = row[2].to_i
  p = LibDeJong::Point.new x, y
  fname = File.join( options[:data], "dejong-1024-#{p.to_filename_part}.json.gz" )
  background = ChunkyPNG::Color::TRANSPARENT
  color = ChunkyPNG::Color.rgb(0,0,0)

  if File.exists? fname 
    imagename = "dejong-1024-#{p.to_filename_part}-#{ChunkyPNG::Color.to_hex(color, false)}.png"
    imagenamedir = File.join( options[:output], imagename )

    seqname = "#{options[:tag]}-#{seq.to_s.rjust(10, '0')}-#{p.to_filename_part}-#{recorded}.png"
    seqnamedir = File.join( options[:output], seqname )

    if File.exists? seqnamedir
      puts "File #{seqname} exists, skipping"
    else
      if !File.exists? imagenamedir
        frame = LibDeJong::FrameWriter.read_raw( fname )
        LibDeJong::FrameWriter.write frame, options[:output], background, 255, imagename
        puts "wrote #{imagename}"
      end

      if File.exists? imagenamedir
        #copy imagename to seqname
        FileUtils.cp imagenamedir, seqnamedir
      else
        puts "ERROR: #{imagename} does not exist!"
      end
    end
  else
    p "#{fname} doesnt exist, unable to create frame #{seq}"
  end
  seq += 1
end


