require 'strscan'
require 'time'

class SQLConverter
  def initialize(path)
    @path = path
  end

  def parse
    lines = File.readlines(@path).map(&:chomp)
    valid_lines = lines.reject { |e| e == "" || e =~ /^--/ }
    inserts = []
    valid_lines.each do |line|
      if line =~ /^INSERT/
        inserts << line
      else
        inserts[-1] = inserts[-1] + "\n" + line
      end
    end

    inserts.map! do |insert|
      match = insert.match(/^INSERT INTO ([a-z_]+) VALUES \((.+)\);$/m)
      table_name = match[1]
      values = parse_values(match[2])
      [table_name, values]
    end

    @inserts = inserts
  end

  def grouped_by_table
    grouped = {}
    @inserts.each do |table_name, values|
      grouped[table_name] ||= []
      grouped[table_name] << values
    end
    grouped
  end

  def parse_values(values)
    scanner = StringScanner.new(values)
    parsed = []
    while !scanner.eos?
      if value = scanner.scan(/NULL/)
        parsed << nil
      elsif value = scanner.scan(/true/)
        parsed << true
      elsif value = scanner.scan(/false/)
        parsed << false
      elsif value = scanner.scan(/-?[0-9]+/)
        parsed << value.to_i
      elsif value = scanner.scan(/'\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{1,6}'/)
        parsed << Time.parse(value[1 .. -2])
      elsif value = scanner.scan(/'.+?'/)
        parsed << value[1 .. -2]
      else
        scanner.scan(/.+/m)
      end
      scanner.scan(/, /)
    end
    parsed
  end
end

converter = SQLConverter.new(ARGV[0])
parsed = converter.parse
grouped = converter.grouped_by_table


puts "Found entries:"
grouped.each do |table_name, values|
  puts "#{table_name.rjust(20)} #{values.size}"
end
puts "\n\n"

p grouped
