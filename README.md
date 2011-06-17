# Benchmark scripts

## Frameworks

* Django (Fast CGI)
* Web2Py (Fast CGI)
* Ruby Rails (Mod Passenger)

## Langages

* PHP (Fast CGI)
* Web.py (Fast CGI)
* Node.js (Raw)

## Environment

* HTTP Server : NGINX or None (Node)
* System : Ubuntu Server
* Virtualization system : Proxmox

## Benchmark Protocols

1. Printing Hello World
2. Getting data from database and return it in plain text in JSON format
3. Sending commands (addition, commands execution...) in JSON and retrieve the result
4. Opening lot of persistent connection (session burning)

## Notes

* Bundled development server of each framework are not used, I use Nginx
* Render engine are not used, only raw text is manipulated
* Only builtins functions are used

