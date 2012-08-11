class Views.NotFoundView extends BasicView
  template: JST['backbone/templates/not_found']

  initialize: (options) ->
    @path = options.path

  render: =>
    this.$el.html(this.template(path: @path))
