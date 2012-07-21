class Views.Goodbye extends Backbone.View
  template: JST['backbone/templates/goodbye']

  el: "#content"

  render: =>
    this.$el.html(this.template())
