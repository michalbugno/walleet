Helpers.formatAmount = (amount, currency) =>
  amount = parseFloat(amount)
  if amount > 0
    value = amount.toString()
  else
    value = (-amount).toString()

  split = value.split(".")
  decimalPart = split[1] || ""
  thousandsPart = split[0]

  parts = Helpers.splitBy3(thousandsPart)
  thousandsSeparator = currency.thousands_separator
  value = parts.join(thousandsSeparator)
  symbol = currency.symbol

  if currency.decimal_precision < decimalPart.length
    decimalPart = decimalPart.substr(0, currency.decimal_precision)
  else
    while decimalPart.length < currency.decimal_precision
      decimalPart = decimalPart + "0"

  if currency.decimal_precision > 0
    decimalSeparator = currency.decimal_separator
    value = value + decimalSeparator + decimalPart

  value = value + '<span class="currency-symbol">' + symbol + "</span>"
  if amount > 0
    value = "+" + value
  else if amount < 0
    value = "-" + value
  value

Helpers.reverseString = (str) =>
  str.split("").reverse().join("")

Helpers.splitBy3 = (str) =>
  if str == ""
    return []

  reversed = Helpers.reverseString(str)
  parts = reversed.match(/.{1,3}/g)
  rev = (Helpers.reverseString(part) for part in parts)
  rev.reverse()
