/*
 * Jakefile
 * RLoginCompleter
 *
 * Created by You on April 23, 2013.
 * Copyright 2013, Your Company All rights reserved.
 */

var ENV = require("system").env,
    FILE = require("file"),
    JAKE = require("jake"),
    task = JAKE.task,
    FileList = JAKE.FileList,
    app = require("cappuccino/jake").app,
    configuration = ENV["CONFIG"] || ENV["CONFIGURATION"] || ENV["c"] || "Debug",
    OS = require("os");

app ("RLoginCompleter", function(task)
{
    ENV["OBJJ_INCLUDE_PATHS"] = "Frameworks";

    task.setBuildIntermediatesPath(FILE.join("Build", "RLoginCompleter.build", configuration));
    task.setBuildPath(FILE.join("Build", configuration));

    task.setProductName("RLoginCompleter");
    task.setIdentifier("com.yourcompany.RLoginCompleter");
    task.setVersion("1.0");
    task.setAuthor("Your Company");
    task.setEmail("feedback @nospam@ yourcompany.com");
    task.setSummary("RLoginCompleter");
    task.setSources((new FileList("**/*.j")).exclude(FILE.join("Build", "**")));
    task.setResources(new FileList("Resources/**"));
    task.setIndexFilePath("index.html");
    task.setInfoPlistPath("Info.plist");
    task.setNib2CibFlags("-R Resources/");

    if (configuration === "Debug")
        task.setCompilerFlags("-DDEBUG -g");
    else
        task.setCompilerFlags("-O");
});

task ("default", ["RLoginCompleter"], function()
{
    printResults(configuration);
});

task ("build", ["default"]);

task ("debug", function()
{
    ENV["CONFIGURATION"] = "Debug";
    JAKE.subjake(["."], "build", ENV);
});

task ("release", function()
{
    ENV["CONFIGURATION"] = "Release";
    JAKE.subjake(["."], "build", ENV);
});

task ("run", ["debug"], function()
{
    OS.system(["open", FILE.join("Build", "Debug", "RLoginCompleter", "index.html")]);
});

task ("run-release", ["release"], function()
{
    OS.system(["open", FILE.join("Build", "Release", "RLoginCompleter", "index.html")]);
});

task ("deploy", ["release"], function()
{
    FILE.mkdirs(FILE.join("Build", "Deployment", "RLoginCompleter"));
    OS.system(["press", "-f", FILE.join("Build", "Release", "RLoginCompleter"), FILE.join("Build", "Deployment", "RLoginCompleter")]);
    printResults("Deployment")
});

task ("desktop", ["release"], function()
{
    FILE.mkdirs(FILE.join("Build", "Desktop", "RLoginCompleter"));
    require("cappuccino/nativehost").buildNativeHost(FILE.join("Build", "Release", "RLoginCompleter"), FILE.join("Build", "Desktop", "RLoginCompleter", "RLoginCompleter.app"));
    printResults("Desktop")
});

task ("run-desktop", ["desktop"], function()
{
    OS.system([FILE.join("Build", "Desktop", "RLoginCompleter", "RLoginCompleter.app", "Contents", "MacOS", "NativeHost"), "-i"]);
});

function printResults(configuration)
{
    print("----------------------------");
    print(configuration+" app built at path: "+FILE.join("Build", configuration, "RLoginCompleter"));
    print("----------------------------");
}
