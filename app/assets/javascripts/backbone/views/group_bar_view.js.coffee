class Walleet.Views.GroupBarView extends Backbone.View
  template: Handlebars.compile $("#group-bar-template").html()

  collection: new Walleet.Collections.GroupCollection

  initialize: (options) ->
    super(options)

    this.render()

  render: ->
    $(@el).html @template(groups: @collection.all)
