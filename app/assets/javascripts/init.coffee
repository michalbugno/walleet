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
  hash = window.location.hash
  if _.include(["#welcome", "#person/sign_in", "#person/sign_up"], hash)
    Router.navigate(hash, {trigger: true})
  else
    Router.navigate("person/sign_in", {trigger: true})
