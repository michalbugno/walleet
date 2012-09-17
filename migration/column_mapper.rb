require 'ostruct'

class ColumnMapper
  def initialize(values, columns)
    destination_size = columns.size
    source_size = values[0].size
    columns = columns[0 .. source_size]
    destination_size = columns.size
    init = "a"
    (source_size - destination_size).times do
      columns.push(init.to_sym)
      init = init.succ
    end
    @values = values
    @columns = columns
  end

  def map
    struct = Struct.new(*@columns)
    @values.map do |value_list|
      begin
        struct.new(*value_list)
      rescue ArgumentError
        p struct
        p value_list
        p @columns
        raise
      end
    end
  end
end
