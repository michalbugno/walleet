Helpers.formatAmount = (amount) =>
  str = amount.toString()
  if amount > 0
    "+" + str
  else
    str
