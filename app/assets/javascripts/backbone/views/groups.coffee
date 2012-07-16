class Views.Groups extends Backbone.View
  template: JST['backbone/templates/groups']

  render: ->
    this.$el.html(this.template())
