class Views.GroupFormView extends Backbone.View
  template: JST["backbone/templates/group_form"]

  events:
    "submit form": "createGroup"

  initialize: (options) ->
    super(options)

    @collection = options.collection

    this.render()

  render: =>
    this.$el.html(this.template())
    @groupName = this.$('#group-name')

  createGroup: (event) =>
    event.preventDefault()
    group = new Models.Group({name: @groupName.val()})
    group.save({}, {
      success: =>
        Router.navigate("groups/" + group.get("id"), {trigger: true})
        @collection.fetch()
        @groupName.val('')
    })
