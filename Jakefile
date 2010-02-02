/*
 * Jakefile
 * dbstore
 *
 * Created by You on February 2, 2010.
 * Copyright 2010, Your Company All rights reserved.
 */

var ENV = require("system").env,
    FILE = require("file"),
    task = require("jake").task,
    FileList = require("jake").FileList,
    app = require("cappuccino/jake").app,
    configuration = ENV["CONFIG"] || ENV["CONFIGURATION"] || ENV["c"] || "Debug";

app ("dbstore", function(task)
{
    task.setBuildIntermediatesPath(FILE.join("Build", "dbstore.build", configuration));
    task.setBuildPath(FILE.join("Build", configuration));

    task.setProductName("dbstore");
    task.setIdentifier("com.yourcompany.dbstore");
    task.setVersion("1.0");
    task.setAuthor("Your Company");
    task.setEmail("feedback @nospam@ yourcompany.com");
    task.setSummary("dbstore");
    task.setSources(new FileList("**/*.j"));
    task.setResources(new FileList("Resources/*"));
    task.setIndexFilePath("index.html");
    task.setInfoPlistPath("Info.plist");

    if (configuration === "Debug")
        task.setCompilerFlags("-DDEBUG -g");
    else
        task.setCompilerFlags("-O");
});

task ("default", ["dbstore"]);
