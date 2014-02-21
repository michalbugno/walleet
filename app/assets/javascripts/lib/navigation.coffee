class window.Navigation
  navigate: (name) =>
    path = this.path.apply(name, arguments) || name
    Backbone.history.navigate(path, {trigger: true})

  path: (name) =>
    switch name
      when 'root'
        "/"
      when 'root:welcome'
        "/welcome"
      when 'group:show'
        "/groups/" + arguments[1]
      when 'group:edit'
        "/groups/" + arguments[1] + "/edit"
      else
        null
