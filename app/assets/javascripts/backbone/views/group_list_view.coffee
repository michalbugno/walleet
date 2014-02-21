class Views.GroupListView extends BasicView
  template: JST['backbone/templates/group_list']

  initialize: (options) ->
    @groups = new Collections.GroupCollection
    @groups.bind("sync", this.render)
    @groups.fetch()
    @currentGroup = options.currentGroup
    if @currentGroup
      @currentGroup.bind("change", this.render)

  render: =>
    this.$el.html(this.template(this.templateContext()))

  templateContext: =>
    groups: _.map(@groups.toJSON(), (group) =>
      group = group.group
      group.url = "/groups/" + group.id
      group.current = @currentGroup && @currentGroup.id == group.id
      group
    )
