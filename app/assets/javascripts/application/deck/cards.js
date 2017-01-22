$(document).on("ready turbolinks:load", function() {
  console.log("starting");
    var recorder;
    var audio_context;

    function sendWaveToPost(blob) {
      var fd = new FormData();
      fd.append('file', blob);
      var deckId = window.location.pathname.match(/decks\/([0-9]*)/)[1];
      var cardId = window.location.pathname.match(/cards\/([0-9]*)/)[1];
      var urlString = "/decks/" + deckId + "/cards/" + cardId + "/speech_command"

      $.ajax({
        url: urlString,
        type: "POST",
        data: fd,
        processData: false,
        contentType : false,
        success: function(data) {
            console.log("Successfully posted wav");
        },
        error: function(e) {
            console.log("Error posting wav");
            console.log(e);
        }
      });
    }

    window.URL = window.URL || window.webkitURL;
    navigator.getUserMedia  = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia;

    var recorder;
    var audio = document.querySelector('audio');
    var TIMEOUT = 5000; //milliseconds
    var context = new AudioContext();

    var onFail = function(e) {
        console.log('Rejected!', e);
    };

    var onSuccess = function(s) {
        var mediaStreamSource = context.createMediaStreamSource(s);
        recorder = new Recorder(mediaStreamSource, {
            bufferLen: 4096,
            numChannels: 1,
            mimeType: 'audio/wav'
        });
        recorder.record();
        setTimeout(stopRecording, TIMEOUT);
    }

    function startRecording() {
        var match = window.location.pathname.match(/decks\/([0-9]*)/);
        if (navigator.getUserMedia && match) {
            console.log("Recording");
            navigator.getUserMedia({audio: true}, onSuccess, onFail);
        } else {
            console.log('not recording');
        }
    }

    function stopRecording() {
        recorder.stop();
        recorder.exportWAV(function(s) {
            //CHANGE THIS : S IS A BLOB
            console.log(s);
            sendWaveToPost(s);
        });
        context.close();
    }
    startRecording();
    // $('#button').click(startRecording);
});
