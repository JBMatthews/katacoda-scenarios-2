We will prepare an environment with a Jenkins server running as a Docker Container.

First you can see in the Terminal that we started the container in detached mode with a tail to a log file we will create and use later.
    
With the next command, we then clone a Jenkins home directory into the container, before we start the Jenkins application. The Jenkins Home directory has been prepared to allow us using Jenkins without any login.

After a minute or so, we should see that the `jenkins.war` is started:

`docker exec jenkins ps -ef`{{execute}}

#### Load Dashboard

You can load the Jenkins' dashboard by clicking the Dashboard tab on the right (note: sometimes, you need to wait a few seconds and press "display port" at this point), or via the following URL https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/.

In the next steps, you'll use the Dashboard to configure the plugins and start building Docker Images.