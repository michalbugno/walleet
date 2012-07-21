class Views.AddMemberView extends Backbone.View
  template: JST['backbone/templates/add_member']

  events:
    'submit form': 'addMember'

  initialize: (options) ->
    @group = options.group
    @group.bind "reset", this.render

  render: =>
    this.$el.html(this.template(group: @group))

  addMember: (event) =>
    event.preventDefault()
    @person_id = this.$("#person-id")
    @name = this.$("#person-name")

    member = new Models.Member(group: @group, person_id: @person_id.val(), name: @name.val())
    member.save()
    @group.fetch()
