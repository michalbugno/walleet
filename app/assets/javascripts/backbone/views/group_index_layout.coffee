class Walleet.Layouts.GroupIndex extends Backbone.View
  template: JST['backbone/templates/layouts/group_index']

  render: ->
    $("#body").html(this.template())
