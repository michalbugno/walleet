class Views.AddMemberView extends Backbone.View
  template: JST['backbone/templates/add_member']

  events:
    'submit form': 'addMember'

  initialize: (options) ->
    super(options)

    @group = options.group
    @group.bind "reset", this.render

  render: =>
    this.$el.html(this.template(group: @group))

  addMember: (event) =>
    event.preventDefault()
    @person = this.$("#person-name").val()

    member = new Models.Member(group: @group, person: @person)
    member.save()
