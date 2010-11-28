begin
	require 'fastercsv'
	CSV = FasterCSV
rescue
	require 'csv'
end

require 'enumerator'

module Paypal
end

class Paypal::CSV

	include Enumerable

	def initialize(filename)
		rows = {}
		data = ::CSV.read(filename, {:headers => true})
		(data.length - 1).downto(0) do |n|
			row = data[n]
			next if row[" Status"] != "Completed" and row[" Status"] != "Reversed"
			p row
			case row[" Type"]
			when /Update to (.*)/
				puts "Updating Txn " << row[" Reference Txn ID"]
				old = rows[row[" Reference Txn ID"]]
				if !old
					puts "Unknown row to update"
				end
				row.each do |k, v|
					if k != " Type" and k != " Name"
						old[k] = row[k]
					end
				end
			when "Cash Back Bonus"
				rows[row[" Transaction ID"]] = row
			when "Debit Card Purchase"
				rows[row[" Transaction ID"]] = row
			when "Payment Received"
				rows[row[" Transaction ID"]] = row
			else
				rows[row[" Transaction ID"]] = row
				puts "Unknown type: " << row[" Type"]
			end
		end

		@data = rows
	end

	attr_reader :data

	def each
		if block_given?
			@data.each do |e| yield e end
		else
			return Enumerable::Enumerator.new(self, :each)
		end
	end
end
