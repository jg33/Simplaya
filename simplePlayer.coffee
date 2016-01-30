## Simple OMX Player ##
## by Jesse Garriosn ##
## finds USB drive, loops all movie files onboard ##

# Requires #
omx = require('omxdirector')
prompter = require('single-prompt')
exec = require('child_process').exec
fs = require('fs')
baseDir = "/mnt/"

omx.enableNativeLoop()

files = []


# Functions #

mountDrive = ()->
  console.log("Mounting drive to: ", baseDir)
  exec("sudo mount /dev/sda1 /mnt/usbdrive",(err, stdout, stderr)->
    if(err||stderr)
      console.log(err||stderr)
    else findDrive()
  )


findDrive = ()->
  console.log("Finding Media...")
  fs.readdir(baseDir, (err,dirFiles)->
    if err
      throw err
      process.exit(1)

    for f in dirFiles
      if fs.lstatSync(baseDir+f).isDirectory()
        console.log("Removable Media Found: "+f)
        files = []
        omx.setVideoDir(baseDir+f)

        fs.readdir(baseDir+f, (mediaFilesErr, mediaFiles)-> #populate file list
          if mediaFiles #if there are files,
            for mediaFile in mediaFiles

              if mediaFile.indexOf(".mov")>-1 || mediaFile.indexOf(".mp4")>-1
                if(mediaFile.indexOf("._")==-1 )
                  console.log("found movie: ",mediaFile)
                  files.push(mediaFile)

            if files.length>0 then play() #wait until populated....
        )


 )


play = () ->
  console.log("playing...", files)
  #bLoopState = true
  #if files.length>1 then bLoopState = false else bLoopState = true
  omx.play(files,{loop:true, osd:false})
  prompt()

sendCmd = (key) ->
  switch key
    when ' '
      if omx.isPlaying() then omx.pause()
      if !omx.isPlaying() && omx.isLoaded() then omx.play()
    when 'q'
      omx.stop()
      console.log('Quitting...')
      exec("sudo umount /dev/sda1")
      process.exit()

  prompt()


prompt = ()->
  prompter.prompt("omxCmd:", [' ','q']).then((choice)->sendCmd(choice))


# Do it. #
console.log("Starting Piper...")
mountDrive()
#findDrive()
