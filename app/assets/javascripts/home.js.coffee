$ ->
  @groups = new Walleet.Collections.GroupCollection()
  new Walleet.Views.GroupBarView(el: $("#secondary-bar"), collection: @groups)
  new Walleet.Views.GroupFormView(el: $("#group-form"), collection: @groups)

