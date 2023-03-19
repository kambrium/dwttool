// Some additional functions that did not fit anywhere else

module dwttool.utilities;

import dwttool.messages;

import core.stdc.stdlib;
import std.stdio;

void showHelp()
{
    foreach (string value; helpMsg)
    {
        writeln(value);
    }
}

void exitDwttool()
{
    writeln(exitingMsg);
    exit(2);
}