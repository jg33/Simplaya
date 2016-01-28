## Simple OMX Player ##
## by Jesse Garriosn ##
## finds USB drive, loops all movie files onboard ##

# Requires #
omx = require('omxdirector')
prompter = require('single-prompt')
fs = require('fs')
baseDir = "/media/pi/"

omx.enableNativeLoop()

files = []
# Functions #
findDrive = ()->
  console.log("Finding Media...")
  fs.readdir(baseDir, (err,dirFiles)->
    if err then throw err

    for f in dirFiles
      if fs.lstatSync(baseDir+f).isDirectory()
        console.log("Removable Media Found: "+f)
        files = []
        omx.setVideoDir(baseDir+f)

        fs.readdir(baseDir+f, (mediaFilesErr, mediaFiles)-> #populate file list
          for mediaFile in mediaFiles
            if mediaFile.indexOf(".mov")>-1 || mediaFile.indexOf(".mp4")>-1
              console.log("found movie: ",mediaFile)
              files.push(mediaFile)

          if files.length>0 then play() #wait until populated....
        )


 )


play = () ->
  console.log("playing...", files)
  prompt()
  omx.play(files,{loop:true})

sendCmd = (key) ->
  switch key
    when ' '
      if omx.isPlaying() then omx.pause()
      if !omx.isPlaying() && omx.isLoaded() then omx.play()
    when 'q' then omx.stop()
  prompt()


prompt = ()->
  prompter.prompt("omxCmd:", [' ','q']).then((choice)->sendCmd(choice))


# Do it. #
findDrive()
