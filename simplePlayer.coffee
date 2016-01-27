## Simple OMX Player ##
## by Jesse Garriosn ##
## finds USB drive, loops all movie files onboard ##

# Requires #
omx = require('omxdirector')
prompt = require('single-prompt')
fs = require('fs')
baseDir = "../"

omx.enableNativeLoop()

files = []
# Functions #
findDrive = ()->
  console.log("Finding Media...")
  fs.readdir(baseDir, (err,files)->
    if err then throw err

    for f in files
      fs.stat(baseDir+f,(err,stats)->
        if err then throw err
        if stats.isDirectory() then console.log(f)
      )



    play()
 )





play = () ->
  console.log("playing...")


# Do it. #
findDrive()