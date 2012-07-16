class Layouts.Main extends Backbone.View
  template: JST["backbone/templates/layouts/main"]

  el: "#body"

  events:
    "click #sign-out": "signOut"

  render: =>
    context = this.context()
    $(this.el).html(this.template(context))

  signOut: (ev) =>
    Auth.logout()
    Router.navigate("#welcome", {trigger: true})

  context: =>
    loggedIn: Auth.loggedIn()
