class Views.AddMemberView extends Backbone.View
  template: JST['backbone/templates/add_member']

  events:
    'submit form': 'addMember'

  el: "#body"

  initialize: (options) ->
    super(options)

    @group = options.group
    @group.bind "reset", this.render

  render: =>
    $(this.el).html(this.template(group: @group))

  addMember: (event) =>
    event.preventDefault()
    @person = this.$("#person-name").val()
    console.log(@person, @group)

    member = new Models.Member(group: @group, person: @person)
    member.save()
