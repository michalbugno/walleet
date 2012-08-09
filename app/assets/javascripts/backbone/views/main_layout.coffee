class Layouts.Main extends Layout
  template: JST["backbone/templates/layouts/main"]

  el: "#body"

  events:
    "click #sign-out": "signOut"

  initialize: (options) =>
    options ||= {}
    @currentGroup = options.currentGroup

  render: =>
    super()
    context = this.context()
    this.$el.html(this.template(context))
    if Auth.loggedIn()
      groupList = new Views.GroupListView(el: this.container("group-list"), currentGroup: @currentGroup)
      groupList.render()
      createGroup = new Views.GroupFormView(el: this.container("group-form"))
      createGroup.render()

  signOut: (ev) =>
    ev.preventDefault()
    Auth.logout()
    Backbone.history.navigate("/goodbye", true)
    alert = new Views.AlertView(el: this.alertContainer())
    alert.addNotice("You are signed out")
    alert.render()

  context: =>
    ret = {}
    if Auth.loggedIn()
      ret.currentPerson = Auth.person.toJSON().person
    ret.loggedIn = Auth.loggedIn()
    ret.groups = _.map(App.groups.toJSON(), (group) =>
      group.url = "/groups/" + group.id
      group)
    ret

  alertContainer: =>
    container = $(".alert-container", this.$el)
    if container.length == 0
      container = $(".alert-container")
    container
