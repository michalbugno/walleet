class window.BasicView extends Backbone.View
  meta:
    name: "BasicView"

  container: (name) =>
    klassName = this.constructor.name.toLowerCase()
    container = "#container-" + klassName + "-" + name
    this.$(container)

  addSubview: (containerName, klass, options) =>
    el = this.container(containerName)
    if el.length == 0
      throw "Container '" + containerName + "' not found"
    options ||= {}
    options.el = el
    view = new klass(options)
    view.parentView = this
    @childrenViews ||= []
    @childrenViews.push(view)
    view

  removeSubview: (view) =>
    @childrenViews = _.without(@childrenViews, view)

  detach: =>
    parent = this.parentView
    if parent
      parent.removeSubview(this)
    _.each(@childrenViews, (view) => view.detach())
    this.remove()
    @childrenViews = []
    this
