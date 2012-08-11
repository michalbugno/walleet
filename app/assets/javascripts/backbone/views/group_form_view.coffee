class Views.GroupFormView extends BasicView
  template: JST["backbone/templates/group_form"]

  events:
    "submit form": "createGroup"

  initialize: (options) ->
    @collection = App.groups
    this.render()

  render: =>
    this.$el.html(this.template())
    @groupName = this.$('#group-name')

  createGroup: (event) =>
    event.preventDefault()
    group = new Models.Group({name: @groupName.val()})
    group.save({}, {
      success: =>
        App.nav.navigate("group:show", group.get("id"))
    })
