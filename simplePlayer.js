// Generated by CoffeeScript 1.10.0
var baseDir, exec, files, findDrive, fs, mountDrive, omx, play, prompt, prompter, sendCmd;

omx = require('omxdirector');

prompter = require('single-prompt');

exec = require('child_process').exec;

fs = require('fs');

baseDir = "/mnt/";

omx.enableNativeLoop();

files = [];

mountDrive = function() {
  console.log("Mounting drive to: ", baseDir);
  return exec("sudo mount /dev/sda1 /mnt/usbdrive", function(err, stdout, stderr) {
    if (err || stderr) {
      return console.log(err || stderr);
    } else {
      return findDrive();
    }
  });
};

findDrive = function() {
  console.log("Finding Media...");
  return fs.readdir(baseDir, function(err, dirFiles) {
    var f, i, len, results;
    if (err) {
      throw err;
      process.exit(1);
    }
    results = [];
    for (i = 0, len = dirFiles.length; i < len; i++) {
      f = dirFiles[i];
      if (fs.lstatSync(baseDir + f).isDirectory()) {
        console.log("Removable Media Found: " + f);
        files = [];
        omx.setVideoDir(baseDir + f);
        results.push(fs.readdir(baseDir + f, function(mediaFilesErr, mediaFiles) {
          var j, len1, mediaFile;
          if (mediaFiles) {
            for (j = 0, len1 = mediaFiles.length; j < len1; j++) {
              mediaFile = mediaFiles[j];
              if (mediaFile.indexOf(".mov") > -1 || mediaFile.indexOf(".mp4") > -1) {
                if (mediaFile.indexOf("._") === -1) {
                  console.log("found movie: ", mediaFile);
                  files.push(mediaFile);
                }
              }
            }
            if (files.length > 0) {
              return play();
            }
          }
        }));
      } else {
        results.push(void 0);
      }
    }
    return results;
  });
};

play = function() {
  console.log("playing...", files);
  omx.play(files, {
    loop: true,
    osd: false
  });
  return prompt();
};

sendCmd = function(key) {
  switch (key) {
    case ' ':
      if (omx.isPlaying()) {
        omx.pause();
      }
      if (!omx.isPlaying() && omx.isLoaded()) {
        omx.play();
      }
      break;
    case 'q':
      omx.stop();
      console.log('Quitting...');
      exec("sudo umount /dev/sda1");
      process.exit();
  }
  return prompt();
};

prompt = function() {
  return prompter.prompt("omxCmd:", [' ', 'q']).then(function(choice) {
    return sendCmd(choice);
  });
};

console.log("Starting Piper...");

mountDrive();

//# sourceMappingURL=simplePlayer.js.map
