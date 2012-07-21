class Views.GroupView extends Backbone.View
  template: JST['backbone/templates/group']

  events:
    "submit #add-debt": "addDebt"
    "click #remove-group": "removeGroup"

  initialize: (options) ->
    @group = options.group
    @group.bind("change", this.render)

  render: =>
    this.$el.html(this.template(this.templateContext()))
    @addMemberView = new Views.AddMemberView(el: "#side-content", group: @group)
    @addMemberView.render()

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
    @group.fetch()

  removeGroup: (event) =>
    event.preventDefault()
    @group.destroy()
    Router.navigate("", {trigger: true})

  templateContext: =>
    group: @group.toJSON()
