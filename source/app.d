// Main entry point of the application

import dwttool.cli;

import slf4d;
import slf4d.default_provider;

void main(string[] args)
{
    // Configuration of server logging
    auto provider = new shared DefaultProvider(false, Levels.ERROR);
    configureLoggingProvider(provider);

    handleCli(args);
}