# Introduction

This application implements the [GITB test service APIs](https://www.itb.ec.europa.eu/docs/services/latest/) in a
[Spring Boot](https://spring.io/projects/spring-boot) web application that is meant to support
[GITB TDL test cases](https://www.itb.ec.europa.eu/docs/tdl/latest/) running in the Interoperability Test Bed. 

## Processing service implementation

The sample processing service is used by the Test Bed to lowercase or uppercase a given text input.

Once running, the processing endpoint's WDSL is available at http://localhost:8080/services/process?WSDL. See 
[here](https://www.itb.ec.europa.eu/docs/services/latest/processing/) for further information on validation service implementations.

# Prerequisites

The following prerequisites are required:
* To build: JDK 17+, Maven 3.8+.
* To run: JRE 17+.

# Building and running

1. Build using `mvn clean package`.
2. Once built you can run the application in two ways:  
  a. With maven: `mvn spring-boot:run`.  
  b. Standalone: `java -jar ./target/ehmi-test-services-1.0-SNAPSHOT.jar`.

## Live reload for development

This project uses Spring Boot's live reloading capabilities. When running the application from your IDE or through
Maven, any change in classpath resources is automatically detected to restart the application.

## Packaging using Docker

Running this application as a [Docker](https://www.docker.com/) container is very simple as described in Spring Boot's
[Docker documentation](https://spring.io/guides/gs/spring-boot-docker/). The first step is to 
[Install Docker](https://docs.docker.com/install/) and ensure it is up and running. You can now build the Docker image
using the approach that best suits you. Note that in both cases you can adapt as you want the resulting image name.

**Option 1: Using the provided Dockerfile** 

First make sure you build the app by issuing `mvn package`. Once built you can create the image using:
```
docker build -t local/ehmi-test-services --build-arg JAR_FILE=./target/ehmi-test-services-1.0-SNAPSHOT.jar .
```

**Option 2: Using the Spring Boot Maven plugin**
```
mvn spring-boot:build-image -Dspring-boot.build-image.imageName=local/ehmi-test-services
```

### Running the Docker container

Assuming an image name of `local/ehmi-test-services`, it can be ran using `docker run --name ehmi-test-services -p 8080:8080 -d local/ehmi-test-services`.

### Running within WSL
For developmental purposes only. If your ITB setup is running in docker and your WSDL services are running outside of docker but within WSL 2. Then you need to do the following:

So what you need to do in the windows machine port forward the port you are running on the WSL machine, this script port forwards the port 7000

netsh interface portproxy delete v4tov4 listenport="7000" # Delete any existing port 4000 forwarding
$wslIp=(wsl -d Ubuntu -e sh -c "ip addr show eth0 | grep 'inet\b' | awk '{print `$2}' | cut -d/ -f1") # Get the private IP of the WSL2 instance
netsh interface portproxy add v4tov4 listenport="7000" connectaddress="$wslIp" connectport="7000"
And on the container ITB docker run command you have to add

--add-host=host.docker.internal:host-gateway
or if you are using docker-compose:

    extra_hosts:
      - "host.docker.internal:host-gateway"
Then inside the container you should be able to curl to

curl host.docker.internal:4000
and get a response!