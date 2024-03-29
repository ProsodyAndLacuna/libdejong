module LibDeJong

  class Point #< JSONable
    attr_accessor :x, :y

    def initialize(x=0,y=0)
      @x = x.to_i
      @y = y.to_i
    end

    def to_json(*a)
      {
        "klass" => { "name" => self.class.name, "version" => "1.0" },
        "x" => @x,
        "y" => @y
        }.to_json(*a)
    end

    def self.json_create(o)
      LibDeJong::Point.new( o["x"].to_i, o["y"].to_i)
    end

    def to_filename_part
     "#{@x.to_s.rjust(4, '0')}-#{@y.to_s.rjust(4, '0')}"
    end

    def to_s
      "x: #{x}, y: #{y}"
    end

  end
end
