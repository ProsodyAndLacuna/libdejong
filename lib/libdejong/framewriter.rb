require 'chunky_png'
require 'zipruby'
require 'json'
require 'zlib'
#require 'yajl'

module LibDeJong

  class FrameWriter
    def self.write(frame, basedir="images", background=ChunkyPNG::Color::BLACK, foreground=ChunkyPNG::Color::WHITE, outputfile=nil, overwrite=false)

      png = ChunkyPNG::Image.new(frame.image_size, frame.image_size, background)

      0.upto(frame.image_size-1) do |i|
        0.upto(frame.image_size-1) do |j|
          a = frame.pixels[i][j]
          a = 255 if a > 255

          png[i,j] = background if a == 0

          if a > 0
            #invert if the background is white
            #c = 255 - c unless background == ChunkyPNG::Color::BLACK
            #puts "x: #{i}, y: #{j}, c: #{c}"
            c2 = foreground
            if background == ChunkyPNG::Color::TRANSPARENT
              r = ChunkyPNG::Color.r foreground
              g = ChunkyPNG::Color.g foreground
              b = ChunkyPNG::Color.b foreground
              png[i,j] = ChunkyPNG::Color.rgba(r, g, b, a)
            else
              png[i,j] = ChunkyPNG::Color.rgb(a,a,a)
            end
          end
        end
      end

      outputfile = frame.to_filename_part if outputfile.nil?

      filename = File.join(basedir, "#{outputfile}")
      if !overwrite && File.exists?(filename)
        p "#{filename} exists, skipping"
        return
      end
      if background == ChunkyPNG::Color::TRANSPARENT
        png.save(filename, :interlace => true, :color_mode => ChunkyPNG::COLOR_TRUECOLOR_ALPHA )
      else
        png.save(filename, :interlace => true)
      end
    end

    def self.write_raw(frame, basedir="data")
      filename = File.join(basedir, "#{frame.to_filename_part}.json")
      File.open( filename, 'w') { |f| f.write( frame.to_json ) }
    end

    def self.write_zip(frame, basedir="data")
      zipname = File.join(basedir, "#{frame.to_filename_part}.json.zip")
      Zip::Archive.open( zipname, Zip::CREATE | Zip::TRUNC ) do |zf|
        zf.add_buffer("#{frame.to_filename_part}.json", frame.to_json)
      end
    end

    def self.read_raw(file, basedir="data")
      json = nil
      if file.end_with?("gz")
        Zlib::GzipReader.open(file) { |gz| json = gz.read }
      else
        json = File.read( file )
      end

      #json = File.read( File.join( basedir, file ) )
      #parser = Yajl::Parser.new
      LibDeJong::Frame.json_create JSON.parse json
    end

  end

end
