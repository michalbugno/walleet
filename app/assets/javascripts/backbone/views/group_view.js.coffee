class Views.GroupView extends Backbone.View
  sidebarTemplate: JST['backbone/templates/group_sidebar']

  el: $("#group-sidebar")

  events:
    "submit form": "addDebt"

  initialize: (options) ->
    super(options)

    @group = options.group
    @group.bind "change", this.render

  render: =>
    if @group
      $(this.el).html(this.sidebarTemplate(group: @group))
    else
      $(this.el).html('')

  addDebt: (event) =>
    event.preventDefault()
    target = $(event.target)
    amount = $("#amount", target).val() * 1
    groupId = @group.get("id")
    giverId = this.$("#giver-id :selected").val()
    takerIds = _.map($("#group-members :checked"), (input) => $(input).val())
    joinedIds = takerIds.join(",")
    debt = new Models.Debt(group_id: groupId, taker_ids: takerIds, amount: amount, giver_id: giverId)
    debt.save()
