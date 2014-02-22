class Routers.Walleet extends Backbone.Router
  routes: {
    "": "mainPage"
    "welcome": "welcome"
    "groups": "groupList"
    "groups/:id": "groupShow"
    "groups/:id/edit": "groupEdit"
    "person/sign_in": "signIn"
    "person/sign_up": "signUp"
    "person/reset_password/:token": "resetPassword"
    "*anything": "notFound"
  }

  welcome: =>
    this.setLayout(Views.MainLayout)
    @layout.addSubview("content", Views.Welcome).render()

  goodbye: =>
    this.setLayout(Views.MainLayout)
    @layout.addSubview("content", Views.Goodbye).render()

  mainPage: =>
    if !App.auth.loggedIn()
      App.nav.navigate("person/sign_in")
    else
      App.nav.navigate("groups")

  groupList: =>
    this.setLayout(Views.MainLayout)
    @layout.addSubview("left", Views.GroupListView)

  groupShow: (groupId) =>
    groupId = parseInt(groupId)
    @group = new Models.Group({id: groupId})
    this.setLayout(Views.MainLayout)
    @layout.addSubview("left", Views.GroupListView, currentGroup: @group)
    @layout.addSubview("content", Views.GroupView, {group: @group})

    @group.fetch()

  groupEdit: (groupId) =>
    groupId = parseInt(groupId)
    @group = new Models.Group({id: groupId})
    this.setLayout(Views.MainLayout, {currentGroup: @group})

    @layout.addSubview("content", Views.GroupEditView, {group: @group})

    @group.fetch()

  signIn: =>
    if App.auth.loggedIn()
      App.nav.navigate("root")
    else
      this.setLayout(Views.LogLayout)
      @layout.addSubview("content", Views.Login).render()

  signUp: =>
    if App.auth.loggedIn()
      App.nav.navigate("root")
    else
      this.setLayout(Views.LogLayout)
      @layout.addSubview("content", Views.Signup).render()

  notFound: (path) =>
    this.setLayout(Views.MainLayout)
    @layout.addSubview("content", Views.NotFoundView, {path: path}).render()

  resetPassword: (token) =>
    this.setLayout(Views.MainLayout)
    @layout.addSubview("content", Views.ResetPassword, {token: token}).render()

  setLayout: (klass, options) =>
    if !@layout || klass.name != @layout.constructor.name
      @layout = new klass(options)
      @layout.render()
      App.layout = @layout
    @layout
