class Views.Welcome extends Backbone.View
  template: JST['backbone/templates/welcome']

  el: "#content"

  render: =>
    this.$el.html(this.template())
