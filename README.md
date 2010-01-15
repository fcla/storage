DAITSS Storage Service
======================

This is a dumb simple http app that will be replaced by the DAITSS Super Storage Server.

RESTful interface
-----------------

    GET /
returns a list of all objects stored in the server

    DELETE /
deletes all resources in the server

    GET /foo
returns the bytes of the resource named foo

    PUT /foo
sets the bytes of the resource named foo

    DELETE /foo
deletes the resource named foo
