Step 6 (Gradle): Retrieve and start executable JAR File

For Maven, scroll down to Step 6 (Maven).

Let us see, where the executable jar file can be found:

For that, let us enter a bash session on the same Docker container:

(dockerhost)$ docker exec -it jenkins bash
jenkins@(container):/$ cd /var/jenkins_home_local/workspace/GitHub\ Triggered\ Build/build/libs/

In case you have started Jenkins with the jenkins image (Step 1.2, alternative (A)), the project will be found on

(container):$ cd /var/jenkins_home

In case you have started Jenkins with the oveits/jenkins_tutorial image (Step 1.2, alternative (B)), the project will be found on

(container):$ cd /var/jenkins_home_local

Then enter the Project. In my case “GitHub Triggered Build”

(container)$ cd 'GitHub Triggered Build'

The jar is found on the path defined in build.gradle file (default: build/libs).

(container)$ cd build/libs
(container)$ ls
GitHub Triggered Build-0.0.1-SNAPSHOT.jar   META-INF   lib   log4j.properties   properties   templates

Now let us start the executable file:

$ java -jar 'GitHub Triggered Build-0.0.1-SNAPSHOT.jar'
[                          main] MainSupport                    INFO  Apache Camel 2.16.0 starting
0 [main] INFO org.apache.camel.main.MainSupport  - Apache Camel 2.16.0 starting
[                          main] DefaultTypeConverter           INFO  Loaded 196 type converters
1706 [main] INFO org.apache.camel.impl.converter.DefaultTypeConverter  - Loaded 196 type converters
...
2762 [main] INFO org.apache.camel.spring.SpringCamelContext  - Total 15 routes, of which 15 is started.
[                          main] SpringCamelContext             INFO  Apache Camel 2.16.0 (CamelContext: camel-1) started in 1.046 seconds
2765 [main] INFO org.apache.camel.spring.SpringCamelContext  - Apache Camel 2.16.0 (CamelContext: camel-1) started in 1.046 seconds

Yes. perfect, it seems to work.
thumps_up_3

You can stop the Apache Camel process by pressing <CTRL>-C in the console.
Step 6 (Maven): Retrieve and start executable JAR File

For Gradle, scroll up to Step 6 (Gradle).

In case of Maven, the location of the created JAR file can be seen at the end of the build console output:

[INFO] Building jar: /var/jenkins_home_local/workspace/GitHub Triggered Build/target/camel-spring4-0.0.1-SNAPSHOT.jar
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 08:15 min
[INFO] Finished at: 2017-01-03T13:13:06+00:00
[INFO] Final Memory: 37M/263M
[INFO] ------------------------------------------------------------------------
Finished: SUCCESS

Let us test the executable JAR:

(dockerhost)$ docker exec -it jenkins bash
jenkins@(container):/$ java -jar '/var/jenkins_home_local/workspace/GitHub Triggered Build/target/camel-spring4-0.0.1-SNAPSHOT.jar'
no main manifest attribute, in /var/jenkins_home_local/workspace/GitHub Triggered Build/target/camel-spring4-0.0.1-SNAPSHOT.jar

Okay, the jar is not executable yet. Let us change the POM file to create an executable fat JAR as described on Mkyong’s page:

$ git clone <repository-URL>
$ cd <repository-Dir>
$ vi pom.xml

Add the following text to the plugins-part of pom.xml:

cloning the git repository, adding the text below to the plugins part, adding pom.xml to git, commit the git change and push the change:

      <!-- Maven Assembly Plugin -->
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-assembly-plugin</artifactId>
        <version>2.4.1</version>
        <configuration>
          <!-- get all project dependencies -->
          <descriptorRefs>
            <descriptorRef>jar-with-dependencies</descriptorRef>
          </descriptorRefs>
          <!-- MainClass in mainfest make a executable jar -->
          <archive>
            <manifest>
            <mainClass>de.oveits.simplerestfulfilestorage.MainApp</mainClass>
            </manifest>
          </archive>

        </configuration>
        <executions>
          <execution>
          <id>make-assembly</id>
          <!-- bind to the packaging phase -->
          <phase>package</phase>
          <goals>
            <goal>single</goal>
          </goals>
          </execution>
        </executions>
      </plugin>

For other projects, you will need to adapt the blue part above.

Then:

$ git add pom.xml
$ git commit -m "Maven creates fat executable JAR file now"
$ git push

Now again, let us build the project:

-> Build Now

-> 2017-01-05-01_15_51-github-triggered-build-jenkins

-> Console Output

Now there are many downloads, and it takes a while:

2017-01-05-01_18_33-github-triggered-build-6-console-jenkins

After ~2.5 minutes, it is ready:

2017-01-05-01_19_25-github-triggered-build-6-console-jenkins

And we can find and run the new fat JAR file on the Docker container:

(dockerhost)$ docker exec -it jenkins bash
(container) $ ls -ltr '/var/jenkins_home_local/workspace/GitHub Triggered Build/target'
total 57680
drwxr-xr-x 3 jenkins jenkins     4096 Jan  3 13:12 generated-sources
drwxr-xr-x 6 jenkins jenkins     4096 Jan  3 13:12 classes
drwxr-xr-x 3 jenkins jenkins     4096 Jan  3 13:12 generated-test-sources
drwxr-xr-x 3 jenkins jenkins     4096 Jan  3 13:12 test-classes
drwxr-xr-x 2 jenkins jenkins     4096 Jan  3 13:13 maven-archiver
-rw-r--r-- 1 jenkins jenkins    44657 Jan  4 23:58 camel-spring4-0.0.1-SNAPSHOT.jar
drwxr-xr-x 2 jenkins jenkins     4096 Jan  5 00:00 archive-tmp
-rw-r--r-- 1 jenkins jenkins 58988354 Jan  5 00:00 camel-spring4-0.0.1-SNAPSHOT-jar-with-dependencies.jar

Here, we can see, that a large JAR file with all dependencies has been created. Now let us try to execute it:

(container) $ java -jar '/var/jenkins_home_local/workspace/GitHub Triggered Build/target/camel-spring4-0.0.1-SNAPSHOT-jar-with-dependencies.jar'
17/01/05 00:07:50 INFO main.MainSupport: Apache Camel 2.16.0 starting
0 [main] INFO org.apache.camel.main.MainSupport  - Apache Camel 2.16.0 starting
...
17/01/05 00:07:52 INFO spring.SpringCamelContext: Total 15 routes, of which 15 is started.
2420 [main] INFO org.apache.camel.spring.SpringCamelContext  - Total 15 routes, of which 15 is started.
17/01/05 00:07:52 INFO spring.SpringCamelContext: Apache Camel 2.16.0 (CamelContext: camel-1) started in 0.876 seconds
2422 [main] INFO org.apache.camel.spring.SpringCamelContext  - Apache Camel 2.16.0 (CamelContext: camel-1) started in 0.876 seconds

Yes. perfect, it seems to work.

thumps_up_3

You can stop the Apache Camel process by pressing <CTRL>-C in the console.