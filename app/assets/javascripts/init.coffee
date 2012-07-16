class Auth
  loggedIn: =>
    !!this.person

  login: (person) =>
    @person = person

  logout: =>
    if @person
      @person.destroy()
      @person = null

window.Auth = new Auth()
person = new Models.Person
person.bind("change", window.Auth.login)
person.fetch({async: false})

window.Router = new Routers.Walleet()
Backbone.history.start()
