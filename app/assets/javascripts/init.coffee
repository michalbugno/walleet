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
window.App.navigate = (path) =>
  Backbone.history.navigate(path, true)

person = new Models.Person
person.bind("change", window.Auth.login)
person.fetch({async: false})

window.Router = new Routers.Walleet()
Backbone.history.start({pushState: true})

if !window.Auth.loggedIn()
  path = window.location.pathname
  if path.match /welcome|person\/sign_in|person\/sign_up|person\/reset_password/
    App.navigate(path)
  else
    App.navigate("/person/sign_in")

$('a').live 'click', (e) ->
  if $(this).attr('href') == '#'
    e.preventDefault()
    return
  host  = window.location.host + '/'
  regex = new RegExp(window.location.host)
  if regex.test(this.href)
    path = this.href.split(host).pop()
    path = path.replace(/^\//, '')
    App.navigate(path)
    e.preventDefault()
