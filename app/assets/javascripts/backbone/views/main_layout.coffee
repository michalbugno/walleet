class Views.MainLayout extends BasicView
  template: JST["backbone/templates/layouts/main"]

  el: "#body"

  initialize: =>
    App.auth.bind("login", this.render)
    App.auth.bind("logout", this.render)

  events:
    "click #sign-out": "signOut"

  render: =>
    this.$el.html(this.template(this.templateContext()))
    if App.auth.loggedIn()
      createGroup = this.addSubview("group-form", Views.GroupFormView)
      createGroup.render()

  signOut: (ev) =>
    ev.preventDefault()
    App.auth.logout()
    App.nav.navigate("")

  templateContext: =>
    ret = {}
    if App.auth.loggedIn()
      ret.currentPerson = App.auth.person.toJSON().person
    ret.loggedIn = App.auth.loggedIn()
    ret.groups = _.map(App.groups.toJSON(), (group) =>
      group)
    ret
