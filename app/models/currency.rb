class Currency < ActiveRecord::Base
  attr_accessible :symbol, :decimal_precision, :decimal_separator,
    :thousands_separator

  def self.for_group(group)
    currency = group.currency
    return currency if currency

    currency = Currency.new({
      :symbol => "&#164;",
      :decimal_precision => 2,
      :decimal_separator => ".",
      :thousands_separator => " ",
    })
  end
end
