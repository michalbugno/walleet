window.App = {}
window.App.auth = new Auth()
window.App.nav = new Navigation()
window.App.groups = new Collections.GroupCollection

person = new Models.Person
person.bind("change", App.auth.login)
person.fetch({async: false})

window.Router = new Routers.Walleet(window.App)
Backbone.history.start({pushState: true})

if !App.auth.loggedIn()
  path = window.location.pathname
  if path.match /welcome|person\/sign_in|person\/sign_up|person\/reset_password/
    App.nav.navigate(path)
  else
    App.nav.navigate("/person/sign_in")

$('a').live 'click', (e) ->
  if $(this).attr('href') == '#'
    e.preventDefault()
    return
  host  = window.location.host + '/'
  regex = new RegExp(window.location.host)
  if regex.test(this.href)
    path = this.href.split(host).pop()
    path = path.replace(/^\//, '')
    App.nav.navigate(path)
    e.preventDefault()
