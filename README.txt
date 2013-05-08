All code from prototype for the Donations Box.

Arduino makes GET request passing values for idScreen (not currently used) and srcVideo.

Node Server upon receiving GET request parses the query string and emits event on ALL sockets.

Flash is listening on Socket, responds to the play event.

Improvements:

1) Change /play/ to /:event/ and emit any type of event.
2) Make flash check which idScreen it is currently set to and filter/ignore messages.
3) Make flash respond to more events.
