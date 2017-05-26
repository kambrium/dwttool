import core.exception;
import core.stdc.stdlib;
import std.algorithm;
import std.file;
import std.format;
import std.path;
import std.range;
import std.regex;
import std.stdio;
import vibe.core.core;
import vibe.http.fileserver;
import vibe.http.router;
import vibe.http.server;

// Constants
private
{
	enum ver = "0.1.0";

	enum invalidArgumentError = "ERROR: No or invalid argument(s) given. Enter 'dwttool help' for help.";
	enum invalidAmountError = "ERROR: Invalid amount of arguments given. Enter 'dwttool help' for help.";
	enum invalidTypeError = "ERROR: Port must be a number.";
	enum missingTemplateError = "ERROR: Could not find template '%s'.";
	enum createProjectError = "ERROR: %s already exists. Try another name.";
	enum createFileError = "ERROR: Could not create file %s from template %s.";
	enum readFileError = "ERROR: Could not read file %s.";
	enum readTemplateError = "ERROR: Could not read template %s.";
}

// Do not indent!
private enum exampleTemplate = "
<!DOCTYPE html>
<html>

<head>
<!-- #BeginEditable \"head\" -->
<!-- #EndEditable -->
</head>

<body>
<!-- #BeginEditable \"content\" -->
<!-- #EndEditable -->
</body>

</html>";

private void main(string[] args)
{ 
    // CLI handling
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
							writeln(invalidAmountError);
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
							writeln(invalidAmountError);
							break;
						}
					default: writeln(invalidArgumentError);
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
							writeln(invalidAmountError);
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
							writeln(invalidAmountError);
							break;
						}
					default: writeln(invalidArgumentError);
				}
				break;
			case "serve":
				if (args.length == 2)
				{
					serveProject;
					break;
				}
				else
				{
					writeln(invalidAmountError);
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
					writeln(invalidAmountError);
					break;
				}
        	default: writeln(invalidArgumentError);
    	}
	}
	catch (RangeError e)
	{
		writeln(invalidArgumentError);
	}
}

private void createProject(string projectName)
{
    writeln("Creating new project...");
	
    if (!projectName.exists)
    {
		mkdir(projectName);
		// Create an example template inside of the new project folder
		string templatePath = buildPath(projectName, "master.dwt");
		std.file.write(templatePath, exampleTemplate);
    }
    else
    {
        writeln(format(createProjectError, projectName));
		exitDwttool;
    }
}

private void updateProject(string templateName)
{
    writeln("Updating project...");

	if (templateName.exists)
	{
    	foreach (DirEntry entry; dirEntries(".", SpanMode.breadth))
    	{
        	if (endsWith(entry.name, ".html") && entry.isFile)
        	{
				updatePage(entry.name, templateName);
        	}
    	}
	}
	else
	{
		writeln(format(missingTemplateError, templateName));
        exitDwttool;
	}
}

private void createPage(string fileName, string templateName)
{
    writeln("Creating new page...");
	
	try
    {
		// Determine if a directory has to be made
		string pathHierarchy = fileName.dropBack(baseName(fileName).length+1);
		if (!pathHierarchy.empty && !pathHierarchy.exists)
		{
			mkdirRecurse(pathHierarchy);
		}
		// A new HTML file is just a copy of a template
		copy(templateName, fileName);
    }
    catch (FileException ex)
    {
		writeln(format(createFileError, fileName, templateName));
    }
}

private void updatePage(string fileName, string templateName)
{
	writeln("Updating page...");
	
	string fromFile;
	try
	{
		fromFile = readText(fileName);
	}
	catch (FileException ex)
	{
		writeln(format(readFileError, fileName));
		exitDwttool;
	}
	string fromTemplate;
	try
	{
		fromTemplate = readText(templateName);
	}
	catch (FileException ex)
	{
		writeln(format(readTemplateError, templateName));
		exitDwttool;
	}

	// Get editable regions from file
	auto matchings = matchAll(fromFile, regex(`<!-- #BeginEditable "(.*?)" -->(.*?)<!-- #EndEditable -->`, "s"));
	// Insert editable regions into template
	foreach (Captures!string c; matchings)
	{
		string r = format(`<!-- #BeginEditable "%s" -->(.*?)<!-- #EndEditable -->`, c[1]);
		fromTemplate = replaceAll(fromTemplate, regex(r, "s"), c[0]);
	}

	std.file.write(fileName, fromTemplate);
}

private int serveProject()
{
	writeln("Starting server...");
	writeln("Press Ctrl+C to quit.");
	auto router = new URLRouter;
	router.get("*", serveStaticFiles("."));
	auto settings = new HTTPServerSettings;
	settings.port = 50_000;
	settings.bindAddresses = ["::1", "127.0.0.1"];
	listenHTTP(settings, router);
	return runEventLoop();
}

private void showHelp()
{
    writeln(format("dwttool - A tool to manage websites based on Dynamic Web Templates - Version %s", ver));
    writeln("");
    writeln("Usage:");
    writeln("  dwttool create project <project>       Create new dwttool project");
	writeln("  dwttool create page <page> <template>  Create new dwttool page");
    writeln("  dwttool update project <template>      Update dwttool project");
	writeln("  dwttool update page <page> <template>  Update dwttool page");
	writeln("  dwttool serve                          Serve dwttool project on port 50000");
	writeln("  dwttool help                           Read this text");
}

private void exitDwttool()
{
    writeln("Exiting...");
    exit(0);
}