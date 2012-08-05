class Views.AlertView extends Backbone.View
  template: JST['backbone/templates/alert']

  initialize: (options) =>
    @errors = []

  addError: (error, options) =>
    options ||= {}
    if options.noHide
      hidable = false
    else
      hideable = true
    @errors.push({message: error, hideable: hideable})

  render: =>
    this.$el.html(this.template(this.templateContext()))
    $(".close", this.$el).click (event) =>
      event.preventDefault()
      target = $(event.currentTarget)
      target.closest(".alert").fadeOut(300)

  templateContext: =>
    errors: @errors
