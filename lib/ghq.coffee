GhqView = require './ghq-view'

module.exports =
  view: null

  activate: (state) ->
    @view = new GhqView(state.ghqViewState)
    atom.workspaceView.command "ghq:toggle", => @view.toggle()

  deactivate: ->
    @view.destroy()

  serialize: ->
    ghqViewState: @view.serialize()
