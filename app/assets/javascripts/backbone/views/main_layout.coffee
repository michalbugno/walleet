class Layouts.Main extends Backbone.View
  template: JST["backbone/templates/layouts/main"]

  el: "#body"

  events:
    "click #sign-out": "signOut"

  render: =>
    context = this.context()
    this.$el.html(this.template(context))

  signOut: (ev) =>
    ev.preventDefault()
    Auth.logout()
    Router.navigate("goodbye", {trigger: true})

  context: =>
    loggedIn: Auth.loggedIn()
    groups: _.map(App.groups.toJSON(), (group) =>
      group.url = "#groups/" + group.id
      group)
