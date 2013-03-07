#!/usr/bin/env ruby

require 'chunky_png'
require './lib/libdejong'

ARGF.each_line do |line|
  p line.strip
  f = LibDeJong::FrameWriter.read_raw(line.strip)
  p f.to_filename_part
  c = ChunkyPNG::Color::BLACK
  fg = 255
  o = "/Users/marshall/tmp/dejong-transparent"

  LibDeJong::FrameWriter.write f, o, c, fg
end

