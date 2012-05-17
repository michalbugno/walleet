$ ->
  @groups = new Walleet.Collections.GroupCollection()

  groupView = new Walleet.Views.GroupView(group: @groups.first())
  new Walleet.Views.GroupBarView(el: $("#group-bar"), collection: @groups, groupView: groupView)
  new Walleet.Views.GroupFormView(el: $("#group-form"), collection: @groups)

