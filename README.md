foscam-streamer
===============

Script that listens on a port for a connection; when one is accepted, we start a streaming session and wait a few minutes to kill it. for foscam, i just hijack the ftp server store for our purpose. instead of storing anything in ftp, all it has to do is start the connection. by doing that, it kicks off the streaming session.
