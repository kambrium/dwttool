// A simple web server

module dwttool.server;

import dwttool.messages;

import handy_httpd;
import handy_httpd.handlers.file_resolving_handler;
import std.stdio;

void serveProject(ushort port)
{
    writeln(startingServerMsg);
    ServerConfig cfg = ServerConfig.defaultValues();
    cfg.port = port;
    auto handler = new FileResolvingHandler(".");
    new HttpServer(handler, cfg).start();
}