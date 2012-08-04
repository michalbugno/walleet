#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers
#= require_tree ./helpers

window.Models = {}
window.Collections = {}
window.Routers = {}
window.Views = {}
window.Layouts = {}
window.Helpers = {}

class window.Layout extends Backbone.View
  container: (name) =>
    klass_name = this.constructor.name.toLowerCase()
    container = "#layout-" + klass_name + "-" + name + "-container"
    $(container, this.$el)
