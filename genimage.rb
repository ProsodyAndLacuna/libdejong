require 'yaml'
require './lib/libdejong'

#f = LibDeJong::FrameWriter.read_raw('/Users/marshall/tmp/dejong-640-12-610.json')
f = LibDeJong::FrameWriter.read_raw('dejong-1024-0009-0000.json')


puts f.image_size
puts f.start
puts f.current

LibDeJong::FrameWriter.write f
