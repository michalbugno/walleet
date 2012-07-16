#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.Models = {}
window.Collections = {}
window.Routers = {}
window.Views = {}
window.Layouts = {}

class Auth
  loggedIn: =>
    !!@person

  login: (person) =>
    @person = person

  logout: =>
    @person = null

window.Auth = new Auth()
