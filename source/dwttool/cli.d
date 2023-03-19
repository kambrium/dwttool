// Command line interface handling

module dwttool.cli;

import dwttool.core;
import dwttool.messages;
import dwttool.server;
import dwttool.utilities;
import dwttool.values;

import core.exception;
import std.conv;
import std.format;
import std.stdio;

void handleCli(string[] args)
{
    try
    {
        switch (args[1])
        {
            case "create":
                switch (args[2])
                {
                    case "page":
                        if (args.length == 5)
                        {
                            createPage(args[3], args[4]);
                            break;
                        }
                        else
                        {
                            writeln(invalidAmountErr);
                            break;
                        }
                    case "project":
                        if (args.length == 4)
                        {
                            createProject(args[3]);
                            break;
                        }
                        else
                        {
                            writeln(invalidAmountErr);
                            break;
                        }
                    default: writeln(invalidArgumentErr);
                }
                break;
            case "update":
                switch (args[2])
                {
                    case "page":
                        if (args.length == 5)
                        {
                            updatePage(args[3], args[4]);
                            break;
                        }
                        else
                        {
                            writeln(invalidAmountErr);
                            break;
                        }
                    case "project":
                        if (args.length == 4)
                        {
                            updateProject(args[3]);
                            break;
                        }
                        else
                        {
                            writeln(invalidAmountErr);
                            break;
                        }
                    default: writeln(invalidArgumentErr);
                }
                break;
            case "serve":
                if (args.length == 2)
                {
                    serveProject(defaultPort);
                    break;
                }
                if (args.length == 3)
                {
                    try
                    {
                        ushort customPort = to!ushort(args[2]);
                        serveProject(customPort);
                        break;
                    }
                    catch (ConvException e)
                    {
                        writeln(format(invalidTypeErr, args[2]));
                        break;
                    }
                }
                else
                {
                    writeln(invalidAmountErr);
                    break;
                }
            case "version":
                if (args.length == 2)
                {
                    writeln(dwttoolVersion);
                    break;
                }
                else
                {
                    writeln(invalidAmountErr);
                    break;
                }
            case "help":
                if (args.length == 2)
                {
                    showHelp;
                    break;
                }
                else
                {
                    writeln(invalidAmountErr);
                    break;
                }
            default: writeln(invalidArgumentErr);
        }
    }
    catch (RangeError e)
    {
        writeln(invalidArgumentErr);
    }
}