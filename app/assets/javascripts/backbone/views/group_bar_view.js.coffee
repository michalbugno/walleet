class Views.GroupBarView extends Backbone.View
  template: JST['backbone/templates/group_bar_item']

  initialize: (options) ->
    super(options)

    @collection = options.collection
    @currentId = options.currentId * 1
    @collection.bind "reset", this.render

  render: =>
    $(@el).html('')

    for group in @collection.models
      do (group) =>
        if group.get("id") == @currentId
          current = "active"
        else
          current = ""
        node = $(@template(group: group, current: current))
        $(@el).append(node)
