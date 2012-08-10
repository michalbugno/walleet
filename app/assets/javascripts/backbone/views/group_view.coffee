class Views.GroupView extends Backbone.View
  template: JST['backbone/templates/group']

  events:
    "submit #add-debt": "addDebt"
    "click #remove-group": "removeGroup"
    "input #amount": "updateAddDebtButton"
    "change #group-members": "updateAddDebtButton"
    "mouseover .member": "showRemoveMembershipLink"
    "mouseout .member": "hideRemoveMembershipLink"
    "click .remove-membership-link": "removeMembership"

  initialize: (options) ->
    @group = options.group
    @group.bind("change", this.render)

  render: =>
    this.$el.html(this.template(this.templateContext()))
    @feedView = new Views.FeedView(el: "#group-feed", group: @group)
    @addMemberView = new Views.AddMemberView(el: "#side-content", group: @group)
    @addMemberView.render()

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
        new Views.Undo(text: "Group removed", undoId: response.id)
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
