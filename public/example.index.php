<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf8">
    <title>Example chat client</title>
  </head>

  <body>
    <label>Message: <input id="message" placeholder="Press ENTER to send"></label>

    <div id="messages"></div>

    <script type="text/javascript">
      window.onload = function () {
        const WS_URI = 'ws://' + window.location.host + ':8050';
        const AUTH   = '<?php echo array_key_exists("auth", $_COOKIE) ? $_COOKIE["auth"] : ""; ?>';

        var input = document.getElementById('message'),
          output  = document.getElementById('messages'),
          client  = new WebSocket(WS_URI),
          escapeHTML;

        if (typeof JSON === "undefined") {
          alert('JSON parsing not supported in browser, include json2.js or whatever in this example page');
          return;
        }

        input.onkeyup = function (evt) {
          // Send messages when ENTER is pressed inside the input field
          // but only if the connection is ready
          if (evt.keyCode === 13 && client.readyState === 1) {
            client.send(input.value);
            input.value = '';
          }
        };

        client.onopen = function (evt) {
          alert('Connected');

          // Defer authentication to let the browser finish
          // establishing connection
          window.setTimeout(function () {
            if (client.readyState === 1 && AUTH.length > 0) {
              client.send('/auth ' + AUTH);
            }
          }, 300);
        };

        client.onclose = function (evt) {
          alert('Disconnected');
        };

        client.onmessage = function (evt) {
          var data = JSON.parse(evt.data);
          output.innerHTML += '<div>' + (data.user === null ? 'System' : data.user.name) + ': ' + escapeHTML(data.text) + '</div>';
        };

        client.onerror = function (evt) {
          alert('Error');
        };

        escapeHTML = function (str) {
          var container = document.createElement('div');
          container.appendChild(document.createTextNode(str));

          return container.innerHTML;
        }
      };
    </script>
  </body>
</html>
