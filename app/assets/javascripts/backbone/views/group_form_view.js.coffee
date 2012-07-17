class Views.GroupFormView extends Backbone.View
  template: JST["backbone/templates/group_form"]

  events:
    "submit form": "createGroup"

  initialize: (options) ->
    super(options)

    @collection = options.collection

    this.render()

  render: =>
    $(@el).html @template()
    @groupName = @$('#group-name')

  createGroup: (event) =>
    event.preventDefault()
    group = new Models.Group({name: @groupName.val()})
    group.save({}, {
      success: =>
        Router.navigate("group/" + group.get("id"), {trigger: true})
        @groupName.val('')
    })
