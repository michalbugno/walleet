class Walleet.Views.GroupBarView extends Backbone.View
  template: JST['backbone/templates/group_bar_item']

  initialize: (options) ->
    super(options)

    @groupView = options.groupView

    @collection = options.collection
    @collection.bind "reset", => @render()
    @collection.fetch()

  render: ->
    $(@el).html('')

    for group in @collection.models
      do (group) =>
        node = $(@template(group: group))
        node.find('a').on 'click', =>
          @$('.active').removeClass('active')
          node.addClass('active')

          @groupView.showGroup(group)

        $(@el).append(node)
