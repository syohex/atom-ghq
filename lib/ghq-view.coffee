{BufferedProcess, SelectListView} = require 'atom'
path = require 'path'

module.exports =
class GhqView extends SelectListView
  initialize: (state) ->
    super
    @addClass('ghq overlay from-top')

  startProcess: ->
    command = 'ghq'
    args = ['list']
    repositories = []
    stdout = (output) ->
      repositories = output.split "\n"

    exit = (code) =>
      if code == 0
        @setItems(repositories)
        atom.workspaceView.append(this)
        @focusFilterEditor()

    new BufferedProcess({command, args, stdout, exit})

  viewForItem: (item) ->
    "<li>#{item}</li>"

  confirmed: (item) ->
    @cancel()
    command = 'git'
    args = ['config', 'ghq.root']
    root = ""
    stdout = (output) ->
      root = output.split("\n")[0]

    exit = (code) ->
      if code == 0
        if root.substr(0, 2) == "~/"
          home = (process.env.HOME || process.env.HOMEPATH)
          root = path.join(home, root.substr(1))
        projectRoot = path.join(root, item)
        atom.open({pathsToOpen: [projectRoot]})
        atom.focus()

    new BufferedProcess({command, args, stdout, exit})

  attach: ->
    @startProcess()

  toggle: ->
    if @hasParent()
      @detach()
    else
      @attach()
