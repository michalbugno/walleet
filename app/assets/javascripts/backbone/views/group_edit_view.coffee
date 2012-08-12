class Views.GroupEditView extends BasicView
  template: JST['backbone/templates/group_edit']

  initialize: (options) ->
    @group = options.group
    @group.bind("change", this.render)

  events:
    "change #currency-decimal-precision": "update"
    "change #currency-symbol": "update"
    "change #currency-decimal-separator": "update"
    "change #currency-thousands-separator": "update"

  render: =>
    this.$el.html(this.template(this.templateContext()))
    this.showCurrencyExample()

  attached: (view) =>
    super(view)
    App.groups.setCurrentId(@group.get("id"))

  detach: =>
    super()
    App.groups.setCurrentId(null)

  templateContext: =>
    decimalPrecisions: this.templateContextDecimalPrecisions()
    symbols: this.templateContextSymbols()
    decimalSeparators: this.templateContextDecimalSeparators()
    thousandsSeparator: this.templateContextThousandsSeparators()
    group: @group.toJSON()

  templateContextDecimalPrecisions: =>
    decimal = @group.get("currency").decimal_precision
    values = [0, 1, 2]
    _.map(values, (value) => {value: value, selected: value == decimal})

  templateContextDecimalSeparators: =>
    currentValue = @group.get("currency").decimal_separator
    values = [[" ", "space"], [".", "."], [",", ","]]
    _.map(values, (value) => {value: value[0], selected: value[0] == currentValue, description: value[1]})

  templateContextThousandsSeparators: =>
    currentValue = @group.get("currency").thousands_separator
    values = [[" ", "space"], [".", "."], [",", ","]]
    _.map(values, (value) => {value: value[0], selected: value[0] == currentValue, description: value[1]})

  templateContextSymbols: =>
    symbol = @group.get("currency").symbol
    values = [["", "none"], ["&amp;curren;", "&curren; (generic)"], ["zł", "zł"], ["$", "$"]]
    _.map(values, (value) => {value: value[0], selected: value[0].replace("&amp;", "&") == symbol, description: value[1]})

  update: (event) =>
    precision = this.$("#currency-decimal-precision :selected").val()
    symbol = this.$("#currency-symbol :selected").val()
    decimalSeparator = this.$("#currency-decimal-separator :selected").val()
    thousandsSeparator = this.$("#currency-thousands-separator :selected").val()
    @group.get("currency").decimal_precision = precision
    @group.get("currency").symbol = symbol
    @group.get("currency").decimal_separator = decimalSeparator
    @group.get("currency").thousands_separator = thousandsSeparator
    this.showCurrencyExample()
    @group.save()

  showCurrencyExample: =>
    this.$("#currency-example").html(@group.formatValue(-1234.56))
