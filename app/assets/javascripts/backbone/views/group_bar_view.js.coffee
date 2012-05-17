class Walleet.Views.GroupBarView extends Backbone.View
  template: JST['backbone/templates/group_bar']

  collection: new Walleet.Collections.GroupCollection

  initialize: (options) ->
    super(options)

    @collection.bind "reset", => @render()
    @collection.fetch()

  render: ->
    $(@el).html @template(groups: @collection.models)
