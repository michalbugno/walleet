class Views.Welcome extends BasicView
  template: JST['backbone/templates/welcome']

  render: =>
    this.$el.html(this.template())
