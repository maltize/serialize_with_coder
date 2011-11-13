module SerializeWithCoder

  class CSVCoder
    def load(data)
      data.to_s.split(',')
    end

    def dump(obj)
      obj.to_a.join(',')
    end
  end

end
