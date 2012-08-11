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
    oldView = _.find(@childrenViews, (view) => view.$el[0].id == el[0].id)
    oldView.detach() if oldView
    @childrenViews.push(view)
    view.attached(this)
    view

  attached: (view) =>
    true

  removeSubview: (view) =>
    @childrenViews = _.without(@childrenViews, view)

  detach: =>
    parent = this.parentView
    if parent
      parent.removeSubview(this)
    _.each(@childrenViews, (view) => view.detach())
    this.$el.html("")
    this.undelegateEvents()
    @childrenViews = []
    this
