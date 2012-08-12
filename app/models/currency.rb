class Currency < ActiveRecord::Base
  attr_accessible :symbol, :decimal_precision, :decimal_separator,
    :thousands_separator

  def self.for_group(group)
    currency = group.currency
    return currency if currency
    default
  end

  ##
  # Generates currency based on last used one
  def self.smart_build(person)
    last_group = person.groups.order("created_at DESC").first
    return default unless last_group

    currency = for_group(last_group)
    currency.dup
  end

  def format_raw(amount)
    ("%f" % [amount / 100.0]).to_f
  end

  def self.default
    Currency.new({
      :symbol => "&curren;",
      :decimal_precision => 2,
      :decimal_separator => ".",
      :thousands_separator => " ",
    })
  end
end
