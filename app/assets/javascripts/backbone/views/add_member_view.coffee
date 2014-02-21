class Views.AddMemberView extends BasicView
  template: JST['backbone/templates/add_member']

  events:
    'submit form': 'addMember'
    "input .js-person-name": "updateAddMemberButton"

  initialize: (options) ->
    @group = options.group
    @group.bind "reset", this.render

  render: =>
    this.$el.html(this.template(group: @group))
    @addMemberButton = this.$(".js-add-button")
    this.updateAddMemberButton()

  addMember: (event) =>
    event.preventDefault()
    return if !@enabled

    event.preventDefault()

    data = {
      group_id: @group.get('id')
      name: if !this.isEmail() then this.enteredName()
      email: if this.isEmail() then this.enteredName()
    }

    member = new Models.Membership(data)
    member.save({}, {
      success: =>
        @group.fetch()
    })

  isEmail: =>
    this.enteredName().match("@")

  updateAddMemberButton: (event) =>
    if this.enteredName() != ""
      @enabled = true
      @addMemberButton.removeAttr("disabled")
    else
      @enabled = false
      @addMemberButton.attr("disabled", true)

  enteredName: =>
    this.$(".js-person-name").val()
