module FileLoader

  def self.load_csv(csv_path)
    contents = CSV.open csv_path, headers: true, header_converters: :symbol
    end

end
