class Routers.Walleet extends Backbone.Router
  routes: {
    "": "mainPage"
    "welcome": "welcome"
    "goodbye": "goodbye"
    "groups/:id": "groupShow"
    "person/sign_in": "signIn"
    "person/sign_up": "signUp"
    "person/reset_password/:token": "resetPassword"
    "*anything": "notFound"
  }

  welcome: =>
    layout = new Layouts.Main()
    layout.render()
    new Views.Welcome(el: layout.container("content")).render()

  goodbye: =>
    layout = new Layouts.Main()
    layout.render()
    new Views.Goodbye(el: layout.container("content")).render()

  mainPage: =>
    if !Auth.loggedIn()
      App.navigate("welcome")
    else
      layout = new Layouts.Main()
      layout.render()
      new Views.FeedView(el: layout.container("content"))

  groupShow: (groupId) =>
    @group = new Models.Group({id: groupId})
    layout = new Layouts.Main(currentGroup: @group)
    layout.render()

    new Views.GroupView({group: @group, el: layout.container("content")})

    @group.fetch()

  signIn: =>
    layout = new Layouts.Main()
    layout.render()
    new Views.Login(el: layout.container("content")).render()

  signUp: =>
    layout = new Layouts.Main()
    layout.render()
    new Views.Signup(el: layout.container("content")).render()

  notFound: (path) =>
    layout = new Layouts.Main()
    layout.render()
    new Views.NotFoundView(el: layout.container("content"), path: path).render()

  resetPassword: (token) =>
    layout = new Layouts.Main()
    layout.render()
    new Views.ResetPassword(el: layout.container("content"), token: token).render()
