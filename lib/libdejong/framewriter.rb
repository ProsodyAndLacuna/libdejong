require 'chunky_png'
require 'json'
#require 'yajl'

module LibDeJong

  class FrameWriter
    def self.write(frame, basedir="images", background=ChunkyPNG::Color::WHITE)

      png = ChunkyPNG::Image.new(frame.image_size, frame.image_size, background)

      0.upto(frame.image_size-1) do |i|
        0.upto(frame.image_size-1) do |j|
          c = frame.pixels[i][j]
          c = 255 if c > 255
          #invert if the background is white
          c = 255 - c if background == ChunkyPNG::Color::WHITE
          #puts "x: #{i}, y: #{j}, c: #{c}"
          png[i,j] = ChunkyPNG::Color.rgb(c,c,c)
        end
      end

      filename = File.join(basedir, "#{frame.to_filename_part}.png")
      png.save(filename, :interlace => true)

    end

    def self.write_raw(frame, basedir="data")
      filename = File.join(basedir, "#{frame.to_filename_part}.json")
      File.open( filename, 'w') { |f| f.write( frame.to_json ) }
    end

    def self.read_raw(file, basedir="data")

      json = File.read( File.join( basedir, file ) )
      #parser = Yajl::Parser.new
      LibDeJong::Frame.json_create JSON.parse json
    end
  end

end
