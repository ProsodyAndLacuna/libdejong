#!/usr/bin/env ruby

require 'chunky_png'

base_dir = File.expand_path(File.dirname(__FILE__))

require File.join( base_dir, '/lib/libdejong' )

ARGF.each_line do |line|
  p line.strip
  f = LibDeJong::FrameWriter.read_raw(line.strip)
  p f.to_filename_part
  c = ChunkyPNG::Color::TRANSPARENT
  fg = 255
  o = "/Users/marshall/tmp/dejong-deleteme"

  LibDeJong::FrameWriter.write f, o, c, fg
end

