class window.Auth
  loggedIn: =>
    !!@person

  login: (person) =>
    @person = person

  logout: =>
    App.groups = new Collections.GroupCollection
    if @person
      @person.destroy()
      @person = null

