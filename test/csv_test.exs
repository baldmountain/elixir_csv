Code.require_file "test_helper.exs", __DIR__

defmodule CsvTest do
  use ExUnit.Case

    test "csv" do
      assert(CSV.parse("\"FB\",\"Facebook, Inc.\"") == [["FB", "Facebook, Inc."]])
      assert(CSV.parse("\"FB\",\"Facebook, Inc.\"\n\"FB\",\"Facebook, Inc.\"") == [["FB", "Facebook, Inc."],["FB", "Facebook, Inc."]])
      long_csv = "one,two,,three,,,four\n,five,six,,,seven,eight\nnine,ten,eleven,twelve,thirteen,fourteen,fifteen\n,,,,,,"
      assert(inspect CSV.parse(long_csv) == [["one","two","","three","","","four"],["","five","six","","","seven","eight"],["nine","ten","eleven","twelve","thirteen","fourteen","fifteen"],["","","","","","",""]])

      assert CSV.parse_file("foo.csv") == []

      result = CSV.parse_file("LicenseImportSample.csv")
      assert Enum.at(result, 0) == ["SRM_SaaS_ES","TLSMLICES","AddChange","EN"]
      last = Enum.at(result, Enum.count(result)-1)
      assert last != [""]
      assert last == ["3.0","2.0","5","INSTINST","","DHL","DAILY","","","2010-07-20T00:00:00-04:00","Sample License","6200-323-000","0","TLSM License 1 Sample","TLSMLICENSE1","ENTERPRISE","EXECUTED","GENERIC","","EAGLENA","DISTRIBUTED","","","","","","2010-07-20T00:00:00-04:00","DRAFT","","","","","","","","","","","","","","","1.0","","","John Wayne Jr.","","USER","John Wayne"]
      assert Enum.at(CSV.parse_file("LicenseImportSample.csv"), 2) == ["3.0","2.0","5","INSTINST","","DHL","DAILY","","","2010-07-20T00:00:00-04:00","Sample License","6200-323-000","0","TLSM License 1 Sample","TLSMLICENSE1","ENTERPRISE","EXECUTED","GENERIC","","EAGLENA","DISTRIBUTED","","","","","","2010-07-20T00:00:00-04:00","DRAFT","","","Microsoft Corporation","3D Pinball 5","","5.1.2600.0","2","","","","","","","","","","","","","",""]
    end
end
