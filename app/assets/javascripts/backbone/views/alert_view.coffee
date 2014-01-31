class Views.AlertView extends BasicView
  template: JST['backbone/templates/alert']

  initialize: (options) =>
    @errors = []
    @notices = []

  addError: (error, options) =>
    options = this.convertOptions(options)
    @errors.push({message: error, hideable: options.hideable, isArray: _.isArray(error)})

  addNotice: (notice, options) =>
    options = this.convertOptions(options)
    @notices.push({message: notice, hideable: options.hideable})

  render: =>
    this.$el.css(opacity: 0.0)
    this.$el.html(this.template(this.templateContext()))
    this.$el.animate(opacity: 1.0, 400, 'swing', =>
    )
    $(".close", this.$el).click (event) =>
      event.preventDefault()
      target = $(event.currentTarget)
      target.closest(".alert").fadeOut(300)

  templateContext: =>
    errors: @errors
    notices: @notices

  convertOptions: (opts) =>
    opts ||= {}
    if opts.noHide
      opts.hideable = false
    else
      opts.hideable = true
    opts
