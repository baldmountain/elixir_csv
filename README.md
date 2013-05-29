# elixir_csv

This is a very basic csv parser. It needs a lot more work to be a real CSV
parser, but it is all I need.

Call:

CSV.parse(string, separator // ",", quote_char // "\"", skip_lines // 0)

where string is a binary. CSV.parse/1 will return an array of rows for the CSV
in string where separator is used ans the field separator and quote_char is the
quote char. Each row is a list of strings in each field. skip_lines is the
number of lines to skip before adding rows to the results. Use this to skip
headers.

CSV.parse_file(filename, separator // ",", quote_char // "\"", skip_lines // 0)

reads the file named filename and then parses the contents of the file using
parse.

This code only handles UNIX or MS-DOS newlines. It will fail on old MacOS
'\r' newlines.
