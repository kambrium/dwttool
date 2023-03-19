// The functions required for managing projects and pages

module dwttool.core;

import dwttool.messages;
import dwttool.utilities;

import std.algorithm;
import std.file;
import std.format;
import std.path;
import std.range;
import std.regex;
import std.stdio;

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

void createProject(string projectName)
{
    writeln(creatingNewProjectMsg);

    if (!projectName.exists)
    {
        mkdir(projectName);
        // Create an example template inside of the new project folder
        string templatePath = buildPath(projectName, "master.dwt");
        std.file.write(templatePath, exampleTemplate);
    }
    else
    {
        writeln(format(createProjectErr, projectName));
        exitDwttool;
    }
}

void updateProject(string templateName)
{
    writeln(updatingProjectMsg);

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
        writeln(format(missingTemplateErr, templateName));
        exitDwttool;
    }
}

void createPage(string fileName, string templateName)
{
    writeln(creatingNewPageMsg);

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
        writeln(format(createFileErr, fileName, templateName));
    }
}

void updatePage(string fileName, string templateName)
{
    writeln(updatingPageMsg);

    string fromFile;
    try
    {
        fromFile = readText(fileName);
    }
    catch (FileException ex)
    {
        writeln(format(readFileErr, fileName));
        exitDwttool;
    }
    string fromTemplate;
    try
    {
        fromTemplate = readText(templateName);
    }
    catch (FileException ex)
    {
        writeln(format(readTemplateErr, templateName));
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