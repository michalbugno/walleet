class Views.AddMemberView extends Backbone.View
  template: JST['backbone/templates/add_member']

  events:
    'submit form': 'addMember'
    "input #person-name": "updateAddMemberButton"

  initialize: (options) ->
    @group = options.group
    @group.bind "reset", this.render

  render: =>
    this.$el.html(this.template(group: @group))
    @name = this.$("#person-name")
    @addMemberButton = this.$("#add-member-button")
    this.updateAddMemberButton()

  addMember: (event) =>
    event.preventDefault()

    member = new Models.Member(group: @group, name: @name.val())
    member.save()
    @group.fetch()

  updateAddMemberButton: (event) =>
    if @name.val() != ""
      @addMemberButton.removeAttr("disabled")
    else
      @addMemberButton.attr("disabled", true)
