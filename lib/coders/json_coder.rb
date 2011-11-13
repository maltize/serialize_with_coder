require 'json'

module SerializeWithCoder

  class JSONCoder
    def load(data)
      JSON.parse(data) rescue nil
    end

    def dump(obj)
      obj.to_json rescue nil
    end
  end

end
