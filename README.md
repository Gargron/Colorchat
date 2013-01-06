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

### Examples

The `public/` directory contains two examples in PHP. One is a simple authentication script that creates a user session with any given credentials (name, email, etc) that expires in 6 hours; And the other one is a client application using basic JavaScript without any libraries.

To run those examples, you will need to point your HTTP server of choice (nginx, Apache, etc) to the `public/` directory. You must have PHP handlers configured to run PHP scripts, naturally; and for authentication, you will need Redis installed on the machine and the PHPRedis extension loaded in PHP.

### To-do

* ~~Add methods for authentication and changing of user attributes using commands~~
* Consider EventMachine defers to optimize responsiveness
* ~~Add endpoints to switch rooms~~
* ~~Add enter/leave/switch announcements~~
* Let unused rooms expire
* Add Comet handler

### In-chat commands

#### ping

Returns `pong`.

#### auth [identifier]

Authenticates user based on session identifier.

#### mute [user ID] [duration]

Mutes a user for a period of time in seconds.

#### unmute [user ID]

Removes a mute on a user.

#### list

Retrieves the list of online users in JSON format.

#### rooms

Retrieves the existing chat rooms in JSON format.

#### me [words] ...

Broadcasts an action in third-person.

#### enter [identifier]

Switch to a different chatroom. Use `.` as separator between chat room names to enter nested rooms. All rooms are nested inside `main`.

#### help

List available commands.

### License

Colorchat is released under the [MIT license](http://www.opensource.org/licenses/MIT).
