class Auth
  loggedIn: =>
    !!@person

  login: (person) =>
    @person = person

  logout: =>
    App.groups = new Collections.GroupCollection
    if @person
      @person.destroy()
      @person = null

window.Auth = new Auth()
window.App = {}
window.App.groups = new Collections.GroupCollection

person = new Models.Person
person.bind("change", window.Auth.login)
person.fetch({async: false})

window.Router = new Routers.Walleet()
Backbone.history.start()

if !window.Auth.loggedIn()
  if window.location.hash == "#welcome"
    Router.navigate("welcome", {trigger: true})
  else
    Router.navigate("person/sign_in", {trigger: true})
