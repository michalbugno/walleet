class Views.GroupView extends BasicView
  template: JST['backbone/templates/group']

  meta:
    name: "Views.GroupView"

  events:
    "submit #add-debt": "addDebt"
    "click #remove-group": "removeGroup"
    "input #amount": "updateAddDebtButton"
    "change #group-members": "updateAddDebtButton"
    "mouseover .member": "showRemoveMembershipLink"
    "mouseout .member": "hideRemoveMembershipLink"
    "click .remove-membership-link": "removeMembership"

  initialize: (options) ->
    super(options)
    @group = options.group
    @group.bind("change", this.render)

  render: =>
    this.$el.html(this.template(this.templateContext()))
    this.addSubview("group-feed", Views.FeedView, {group: @group})
    this.addSubview("side-content", Views.AddMemberView, {group: @group}).render()

    @amount = $("#amount", this.$el)
    @addDebtButton = $("#add-debt-button", this.$el)

    this.updateAddDebtButton()

  addDebt: (event) =>
    event.preventDefault()
    target = $(event.target)
    groupId = @group.get("id")
    giverId = this.$("#giver-id :selected").val()
    joinedIds = this.takerIds().join(",")
    debt = new Models.Debt(group_id: groupId, taker_ids: joinedIds, amount: @amount.val(), giver_id: giverId)
    debt.save()
    @group.fetch()

  removeGroup: (event) =>
    event.preventDefault()
    @group.destroy({
      success: (model, response) =>
        App.groups.fetch()
        App.nav.navigate("root")
        App.layout.addSubview("undo", Views.Undo, {
          text: "Group " + @group.get("name") + " removed!",
          undoId: response.id,
          callback: =>
            App.groups.fetch()
            App.nav.navigate("group:show", @group.get("id"))
        })
      error: =>
        # pass
    })

  templateContext: =>
    group = @group.toJSON()
    _.each(group.members, (member) =>
      badgeClass = ["badge"]
      if member.amount > 0
        badgeClass.push("badge-success")
      else if member.amount == 0
        badgeClass.push("badge-info")
      else
        badgeClass.push("badge-important")
      member.badgeClass = badgeClass.join(" ")
      member.formattedAmount = Helpers.formatAmount(member.amount)
    )
    group: group

  takerIds: =>
    _.map($("#group-members :checked"), (input) => $(input).val())

  updateAddDebtButton: (event) =>
    amount = Number(@amount.val())
    enableButton = this.takerIds().length > 0 && Math.abs(amount) >= 0.01
    if enableButton
      @addDebtButton.removeAttr("disabled")
    else
      @addDebtButton.attr("disabled", true)

  showRemoveMembershipLink: (event) =>
    target = $(event.currentTarget, this.$el)
    link = target.find(".remove-membership-link")
    link.show()

  hideRemoveMembershipLink: (event) =>
    target = $(event.currentTarget, this.$el)
    link = target.find(".remove-membership-link")
    link.hide()

  removeMembership: (event) =>
    event.preventDefault()
    target = $(event.currentTarget, this.$el)
    membershipId = target.data("membership-id")
    membership = new Models.Membership(id: membershipId)
    membership.destroy()
    @group.fetch()

  attached: (parentView) =>
    App.groups.setCurrentId(@group.get("id"))

  detach: =>
    App.groups.setCurrentId(null)
    super()
