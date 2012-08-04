class Routers.Walleet extends Backbone.Router
  routes: {
    "": "mainPage"
    "welcome": "welcome"
    "goodbye": "goodbye"
    "groups/:id": "groupShow"
    "person/sign_in": "signIn"
    "*anything": "notFound"
  }

  welcome: =>
    this.clear()
    new Layouts.Main().render()
    new Views.Welcome().render()

  goodbye: =>
    this.clear()
    new Layouts.Main().render()
    new Views.Goodbye().render()

  mainPage: =>
    this.clear()
    if !Auth.loggedIn()
      Router.navigate("welcome", {trigger: true})
    else
      layout = new Layouts.Main()
      layout.render()
      new Views.FeedView(el: layout.container("content"))

  groupShow: (groupId) =>
    this.clear()
    new Layouts.Main().render()

    @group = new Models.Group({id: groupId})
    layout = new Layouts.Main(currentGroup: @group)
    layout.render()

    new Views.GroupView({group: @group, el: layout.container("content")})

    @group.fetch()

  signIn: =>
    this.clear()
    new Layouts.Main().render()
    new Views.Login().render()

  notFound: (path) =>
    this.clear()
    new Layouts.Main().render()
    new Views.NotFoundView(el: layout.container("content"), path: path).render()

  clear: =>
    $("#body").html("")
