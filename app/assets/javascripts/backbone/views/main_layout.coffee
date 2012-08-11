class Views.MainLayout extends BasicView
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
    if App.auth.loggedIn()
      groupList = this.addSubview("group-list", Views.GroupListView, {currentGroup: @currentGroup})
      groupList.render()
      createGroup = this.addSubview("group-form", Views.GroupFormView)
      createGroup.render()

  signOut: (ev) =>
    ev.preventDefault()
    App.auth.logout()
    App.nav.navigate("/goodbye")
    alert = new Views.AlertView(el: this.alertContainer())
    alert.addNotice("You are signed out")
    alert.render()

  context: =>
    ret = {}
    if App.auth.loggedIn()
      ret.currentPerson = App.auth.person.toJSON().person
    ret.loggedIn = App.auth.loggedIn()
    ret.groups = _.map(App.groups.toJSON(), (group) =>
      group)
    ret

  alertContainer: =>
    container = $(".alert-container", this.$el)
    if container.length == 0
      container = $(".alert-container")
    container
