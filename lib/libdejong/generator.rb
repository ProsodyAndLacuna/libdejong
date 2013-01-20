
module LibDeJong
  class Generator
    DEFAULT_ITERATIONS = 128 * 26 * 1000

    attr_reader :image_size

    def initialize(image_size=640)
      @image_size = image_size
    end

    def generate_frame(point, iterations=DEFAULT_ITERATIONS)
      LibDeJong::Frame.new(@image_size,point).compute_frame(point,iterations)
    end

    def frame_exists?(point, basedir="data", iterations=DEFAULT_ITERATIONS)
      #KLUDGE: this gem needs a better way of outputting /
      #        computing filenames
      File.exists?(frame_filename(point))
    end

    def frame_filename(point, basedir="data", iterations=DEFAULT_ITERATIONS)
      #KLUDGE: this gem needs a better way of outputting /
      #        computing filenames
      filename = LibDeJong::Frame.raw_filename(@image_size, point)
      File.join( basedir, filename )
    end

  end
end

