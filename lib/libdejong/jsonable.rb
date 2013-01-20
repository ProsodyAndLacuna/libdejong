require 'json'

module LibDeJong

  class JSONable
    def to_json(*a)
      hash = {}
      self.instance_variables.each do |var|
        hash[var] = self.instance_variable_get var
      end
      hash.to_json *a
    end

    def from_json! string
      JSON.load(string).each do |var, val|
        self.instance_variable_set var, val
      end
    end
  end
end
