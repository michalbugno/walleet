class Views.Goodbye extends BasicView
  template: JST['backbone/templates/goodbye']

  render: =>
    this.$el.html(this.template())
