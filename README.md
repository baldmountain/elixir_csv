# elixir_csv

** TODO: Add more description **

This si a very basic csv parser. It needs a lot more work to be a real CSV
parser, but it is all I need.

Call:

CSV.parse(string, separator // ",", quote_char // "\"")

where string is a binary. CSV.parse/1 will return an array of rows for the CSV
in string where separator is used ans the field separator and quote_char is the
quote char. Each row is a list of strings in each field.
