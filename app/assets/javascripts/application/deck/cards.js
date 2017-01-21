$(document).on("ready page:load", function() {
    var recorder;
    var audio_context;

    function sendWaveToPost(blob) {
      var fd = new FormData();
      fd.append('file', blob);
      var deckId = window.location.pathname.match(/decks\/([0-9]*)/)[1];
      var urlString = "/decks/" + deckId + "/cards/speech_command"

      $.ajax({
        url: urlString,
        type: "POST",
        data: fd,
        processData: false,
        contentType : false,
        sucess: function(data) {
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

    var onFail = function(e) {
        console.log('Rejected!', e);
    };

    var onSuccess = function(s) {
        var context = new AudioContext();
        var mediaStreamSource = context.createMediaStreamSource(s);
        recorder = new Recorder(mediaStreamSource);
        recorder.record();
        setTimeout(stopRecording, TIMEOUT);
    }

    function startRecording() {
        if (navigator.getUserMedia) {
            navigator.getUserMedia({audio: true}, onSuccess, onFail);
        } else {
            console.log('navigator.getUserMedia not present');
        }
    }

    function stopRecording() {
        recorder.stop();
        recorder.exportWAV(function(s) {
            //CHANGE THIS : S IS A BLOB
            console.log(s);
            sendWaveToPost(s);
        });
    }
    startRecording();
    // $('#button').click(startRecording);
});    