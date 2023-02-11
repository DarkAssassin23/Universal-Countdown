# Universal Countdown

## Table of Contents
* [About](#about)
* [Using Docker](#building-and-deploying-the-server-with-docker)
* [Configuration](#config-files)
* [Building from source](#building-from-source)
    * [Clients](#clients)
    * [Server](#server)

## About
This is a multi-threaded TCP server, written in C, along with clients
for Windows, macOS, and Linux. (iOS coming soon) 

This server listens for connections then reply's back with how much
time is left based on the date provided in its config file.

**NOTE:** The server is only designed to run on unix based machines. It will
not work on Windows, unless you run it with docker.

________________
## Building And Deploying The Server With Docker
You can build and deploy this server with docker. To build the docker image
use the provided <code>Dockerfile</code>.
```bash
docker build -t time-remaining .
```

Once you build the docker image you can run it with the following command
```bash
docker run -d -p 8989:8989 time-remaining
```

Or, preferably, run it with docker-compose
```bash
docker-compose up -d
```
________________
## Config Files
Provided in the <code>configs/</code> directory are example configs for the 
client's and the server. In the case of the client, the config file tells the
client where to connect to the server and what the reason for the count down is
for. The server config has the date and time the event occuring will occur.

**NOTE:** The hours in the server's config must be 24hr based, not 12hr.

________________
## Building from Source
You have the ability to build both the client's and the server from 
source with the provided make file

### Clients
To build your respective client from source, simply run the follwing
command:
```bash
make client
```
This will build either the Windows or Unix client based on your OS

**NOTE:** For Windows users, the provided makefile is designed for 
Windows operating systems with MSYS2 installed and configured. A guide 
on how to do that can be found on their website 
<a href="https://www.msys2.org" target="new">here</a>

### Server
As mentioned in the [about](#about) section, this server is only made for
Unix based operating systems, **NOT** Windows. If you try to build the 
server on Windows via the makefile, it will not work. For Unix systems,
you can build the server via the following command:
```bash
make
```
