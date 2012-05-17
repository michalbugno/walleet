class Walleet.Views.GroupBarView extends Backbone.View
  template: JST['backbone/templates/group_bar']

  initialize: (options) ->
    super(options)

    @collection = options.collection
    @collection.bind "reset", => @render()
    @collection.fetch()

  render: ->
    $(@el).html @template(groups: @collection.models)
