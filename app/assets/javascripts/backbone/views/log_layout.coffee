class Views.LogLayout extends BasicView
  template: JST["backbone/templates/layouts/login"]

  el: "#body"

  initialize: =>
    App.auth.bind("login", this.render)
    App.auth.bind("logout", this.render)

  render: =>
    this.$el.html(this.template(this.templateContext()))

  templateContext: =>
    {}
