Colorchat
=========

Ruby and EventMachine-based webchat application supporting WebSockets and a Comet fallback

### About

I was working on the webchat of theColorless.net for many years. Now I want to open-source it,
but drop legacy code and write it cleanly from scratch without having it stick too much
to a brand. Ideally, I want anyone with a VPS to be able to run a chat like this.

### Supposed advantages over other solutions

This chat is built to work with other authentication systems rather than contain one of its own.
So it should be easier to integrate with websites generally. It should also be robust and lightweight.

### Technologies used

EventMachine as the server framework with the EM-Websockets gem to handle WebSocket connections, and Redis for
persistent memory and sessions.

### To-do

* Add methods for authentication and changing of user attributes using commands
* Add some kind of HTTP handler to serve the HTML/JS/CSS
* Consider EventMachine defers to optimize responsiveness
