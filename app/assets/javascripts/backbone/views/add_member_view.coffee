class Views.AddMemberView extends BasicView
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

    data = {
      group_id: @group.get('id')
      name: if !this.isEmail() then @name.val()
      email: if this.isEmail() then @name.val()
    }

    member = new Models.Membership(data)
    member.save()
    @group.fetch()

  isEmail: =>
    @name.val().match("@")

  updateAddMemberButton: (event) =>
    if this.isEmail()
      @addMemberButton.find('.content').html("Invite member")
    else
      @addMemberButton.find('.content').html("Add member")

    if @name.val() != ""
      @addMemberButton.removeAttr("disabled")
    else
      @addMemberButton.attr("disabled", true)
