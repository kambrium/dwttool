// The messages used in the application

module dwttool.messages;

enum invalidArgumentErr = "ERROR: No or invalid argument(s) given. Enter 'dwttool help' for help.";
enum invalidAmountErr = "ERROR: Invalid amount of arguments given. Enter 'dwttool help' for help.";
enum invalidTypeErr = "ERROR: %s is not a valid port number.";
enum missingTemplateErr = "ERROR: Could not find template '%s'.";
enum createProjectErr = "ERROR: %s already exists. Try another name.";
enum createFileErr = "ERROR: Could not create file %s from template %s.";
enum readFileErr = "ERROR: Could not read file %s.";
enum readTemplateErr = "ERROR: Could not read template %s.";

enum creatingNewProjectMsg = "Creating new project...";
enum updatingProjectMsg = "Updating project...";
enum creatingNewPageMsg = "Creating new page...";
enum updatingPageMsg = "Updating page...";
enum exitingMsg = "Exiting...";
enum startingServerMsg = "Starting server... Press Ctrl+C to quit.";

enum string[] helpMsg = [
    "dwttool - A tool to manage websites based on Dynamic Web Templates",
    "",
    "Usage:",
    "  dwttool create project <project>       Create new dwttool project",
    "  dwttool create page <page> <template>  Create new dwttool page",
    "  dwttool update project <template>      Update dwttool project",
    "  dwttool update page <page> <template>  Update dwttool page",
    "  dwttool serve [<port>]                 Serve dwttool project. Standard port is 4343",
    "  dwttool version                        Get dwttool version",
    "  dwttool help                           Read this text"
];