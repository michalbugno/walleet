class Views.Undo extends BasicView
  template: JST['backbone/templates/undo']

  events:
    "click #undo-link": "performUndo"

  initialize: (options, callback) =>
    @callback = options.callback
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
        @callback(model, response)
        this.detach()
    })
