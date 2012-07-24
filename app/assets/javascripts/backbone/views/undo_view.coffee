class Views.Undo extends Backbone.View
  template: JST['backbone/templates/undo']

  el: "#undo"

  events:
    "click #undo-link": "performUndo"

  initialize: (options) =>
    @text = options.text
    @undo = new Models.Undo(id: options.undoId)
    this.render()

  render: =>
    this.$el.html(this.template(this.templateContext()))

  templateContext: =>
    text: @text

  performUndo: (event) =>
    event.preventDefault()
    @undo.destroy({
      success: (model, response) =>
        # pass
      error: (model, response) =>
        Router.navigate(response.responseText, trigger: true)
    })
