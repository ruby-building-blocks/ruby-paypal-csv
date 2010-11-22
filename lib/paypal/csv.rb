begin
	require 'fastercsv'
	CSV = FasterCSV
rescue
	require 'csv'
end

module Paypal
	class CSV

		def initialize(filename)
			@data = ::CSV.read(filename, {:headers => true})
		end
	end
end
