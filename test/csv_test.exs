Code.require_file "test_helper.exs", __DIR__

defmodule CsvTest do
	use ExUnit.Case

  	test "csv" do
  		assert(CSV.parse("\"FB\",\"Facebook, Inc.\"") == [["FB", "Facebook, Inc."]])
  		assert(CSV.parse("\"FB\",\"Facebook, Inc.\"\n\"FB\",\"Facebook, Inc.\"") == [["FB", "Facebook, Inc."],["FB", "Facebook, Inc."]])
  		long_csv = "one,two,,three,,,four\n,five,six,,,seven,eight\nnine,ten,eleven,twelve,thirteen,fourteen,fifteen\n,,,,,,"
  		assert(inspect CSV.parse(long_csv) == [["one","two","","three","","","four"],["","five","six","","","seven","eight"],["nine","ten","eleven","twelve","thirteen","fourteen","fifteen"],["","","","","","",""]])
  	end
end
