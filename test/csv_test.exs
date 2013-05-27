Code.require_file "test_helper.exs", __DIR__

defmodule CsvTest do
	use ExUnit.Case

  	test "csv" do
  		assert(CSV.parse("\"FB\",\"Facebook, Inc.\"") == [["FB", "Facebook, Inc."]])
  	end
end
