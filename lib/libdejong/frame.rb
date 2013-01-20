
module LibDeJong

  class Frame #< JSONable
    attr_accessor :pixels, :start, :current, :sensitivity, :image_size

    def initialize(image_size, point, initial_value=0)
      @image_size = image_size
      @pixels = Array.new(@image_size) { Array.new(@image_size) { initial_value }}
      @sensitivity = 0.017
      @start = point
    end

    def compute_frame(start, iterations)
      @current = LibDeJong::Point.new start.x, start.y
      r = Random.new

      maxdensity = 0
      plotted = 0

      # compute the center
      x = @image_size / 2.0
      y = @image_size / 2.0

      a = @start.x.map_space( 0.0, @image_size, -1.0, 1.0) * sensitivity
      b = @start.y.map_space( 0.0, @image_size, -1.0, 1.0) * sensitivity
      c = @start.x.map_space( 0.0, @image_size, 1.0, -1.0) * sensitivity
      d = @start.y.map_space( 0.0, @image_size, 1.0, -1.0) * sensitivity

      0.upto(iterations) do
        newx = ((Math.sin(a * y) - Math.cos(b * x)) * @image_size * 0.2) + @image_size / 2
        newy = ((Math.sin(c * x) - Math.cos(d * y)) * @image_size * 0.2) + @image_size / 2

        newx += r.rand(-1...1)
        newy += r.rand(-1...1)

        x = newx
        y = newy

        newx = newx.to_i
        newy = newy.to_i
        current.x = newx
        current.y = newy

        #puts "x: #{newx}, y: #{newy}"
        if (0...@image_size) === newx && (0...@image_size) === newy
          plotted += 1
          @pixels[newx][newy] += 1
          maxdensity = @pixels[newx][newy] if @pixels[newx][newy] > maxdensity
        end
      end
      puts "Plotted #{plotted}, Max Densitity = #{maxdensity} from a total of #{iterations} iterations"

      self
    end

    def to_json(*a)
      {
        "klass" => { "name" => self.class.name, "version" => "1.0" },
        "start" => @start.to_json,
        "current" => @current.to_json,
        "sensitivity" => @sensitivity,
        "image_size" => @image_size,
        "pixels" => @pixels
      }.to_json(*a)
    end

    def self.json_create(o)
      image_size = o["image_size"]
      p = LibDeJong::Point.json_create JSON.parse o["start"]
      f = LibDeJong::Frame.new(image_size, p)
      f.pixels = o["pixels"]
      f.current = LibDeJong::Point.json_create JSON.parse o["current"]
      f.sensitivity = o["sensitivity"]

      f
    end

    def to_filename_part
      "dejong-#{@image_size}-#{@start.to_filename_part}"
    end

    def self.raw_filename(image_size, point)
      "dejong-#{image_size}-#{point.to_filename_part}.json"
    end
  end
end
