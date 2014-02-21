class Views.MainLayout extends BasicView
  template: JST["backbone/templates/layouts/main"]

  el: "#body"

  events:
    "click #sign-out": "signOut"

  render: =>
    this.$el.html(this.template(this.templateContext()))

  signOut: (ev) =>
    ev.preventDefault()
    App.auth.logout()
    App.nav.navigate("person/sign_in")

  templateContext: =>
    ret = {}
    if App.auth.loggedIn()
      ret.currentPerson = App.auth.person.toJSON().person
    ret.loggedIn = App.auth.loggedIn()
    ret
