class Views.GroupListView extends BasicView
  template: JST['backbone/templates/group_list']

  initialize: (options) ->
    App.groups.bind("reset", this.render)
    App.groups.fetch()
    @currentGroup = options.currentGroup

  render: =>
    this.$el.html(this.template(this.templateContext()))

  templateContext: =>
    groups: _.map(App.groups.toJSON(), (group) =>
      group.url = "/groups/" + group.id
      if @currentGroup && parseInt(@currentGroup.get("id")) == group.id
        group.activeClass = "active"
      else
        group.activeClass = null
      group)
