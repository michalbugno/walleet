Helpers.formatAmount = (amount, currency) =>
  amount = parseInt(amount)
  precision = currency.decimal_precision
  if amount > 0
    value = amount.toString()
  else
    value = (-amount).toString()
  if value.length > precision
    thousandsPart = value.substring(0, value.length - precision)
    decimalPart = value.substring(value.length - precision, value.length)
  else
    thousandsPart = "0"
    decimalPart = (parseInt(value) / Math.pow(10, precision)).toFixed(precision)
    decimalPart = decimalPart.substr(2, decimalPart.length)

  parts = Helpers.splitBy3(thousandsPart)
  thousandsSeparator = currency.thousands_separator
  value = parts.join(thousandsSeparator)
  symbol = currency.symbol

  if precision > 0
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
