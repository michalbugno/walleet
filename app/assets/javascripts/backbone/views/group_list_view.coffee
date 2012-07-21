class Views.GroupListView extends Backbone.View
  template: JST['backbone/templates/group_list']

  initialize: (options) ->
    App.groups.bind("reset", this.render)
    App.groups.fetch()

  render: =>
    this.$el.html(this.template(this.templateContext()))

  templateContext: =>
    groups: _.map(App.groups.toJSON(), (group) =>
      group.url = "#groups/" + group.id
      group)
