<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents** 

- [Yookore Microservice Architecture](#yookore-microservice-architecture)
  - [General Microservices Requirements](#general-microservices-requirements)
  - [Single-App Microservice Requirements](#single-app-microservice-requirements)
    - [Integration Requirements for every Single-App Microservice](#integration-requirements-for-every-single-app-microservice)
    - [A Microservice as OAuth2 Resource Server](#a-microservice-as-oauth2-resource-server)
  - [The 12 Factor](#the-12-factor)
  - [Cloud Foundry Global Environment variables](#cloud-foundry-global-environment-variables)
  - [Presentation Layer Microservice Requirements](#presentation-layer-microservice-requirements)
  - [Integration](#integration)
    - [Integration by Service Discovery](#integration-by-service-discovery)
    - [Apache Camel as Message Server and Channel Server](#apache-camel-as-message-server-and-channel-server)
  - [Storing log files](#storing-log-files)
  - [Storing binary files (Photos, Videos, Avatars)](#storing-binary-files-photos-videos-avatars)
  - [Mobile Integration](#mobile-integration)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Yookore Microservice Architecture

## General Microservices Requirements
* All aspects of deployment, monitoring, testing, and recovery must be fully automated. For example, monitoring a service should occur instantly and automatically by virtue of it being deployed, not requiring a separate manual step. Similarly failure discovery and rerouting to old code must be fully automated, no human intervention required.
* If a failure occurs when deploying an updated Payment module microservice, it's important that the time between the failure, reporting, and rerouting to existing, working code is kept under around this 10 second range.
* Refactor database schemas, and de-normalize everything, to allow complete separation and partitioning of data. That is, do not use underlying tables that serve multiple microservices. There should be no sharing of underlying tables that span multiple microservices, and no sharing of data. Instead, if several services need access to the same data, it should be shared via a service API (such as a published REST or a message service interface).
* Deployment: should run in a container, such as Tomcat, Docker, or in whatever container system is provided by the PaaS. Do not run microservices on bare metal, or directly on a VM

## Single-App Microservice Requirements
* **Persistence** 

    Can implement own database or persistence layer (polygot persistence)

* **Own web framework** 

    Can use own web framework
    
* **Continuous deployment**

    Should have its own SCM repository(e.g git) so it can truly be updated and enhanced independent of other services
    
* **Dependency management**

    Must have its own manifest and dependencies, instead of maintaining a global dependency list for all services. This allows, for example, one microservice
    to depend on Spring v3.2, while another can require Spring 4.1. The dependencies for one microservice can change over time with no effect on the
    dependencies of other microservices.
    
* **Dedicated state management**

    Do not build stateful services. Instead, maintain state in a dedicated persistence service, or elsewhere
    
* **API Endpoints**

    Create access libraries or API that can be used to access the service
    
* **Optimize the service interaction**  

    Instead of transmitting the standard text/html REST content type, consider using something like Google Protocol Buffers, Simple Binary Encoding, or Apache Thrift, to decrease the size of the payload and optimize the inter-microservice communications.
    
* **Integration Testing**

    Shall contain integration testing
    
* **Load Testing**

    Application performance testing
    
* **Is an OAuth Resource Server**

    The token is time-sensitive. The token would be generated with the REST service and authenticated with the remote microservice (uaa for example). The
    Resource server will have the capability to validate the access_token using information from a shared storage.
    
* **Rate limiting**

    Application monitoring including Request metering, API calls identification (that is, the client application id or the user id, the client IP address).
    
* **HTTP Proxy**

    The microservice should be deployed behind a proxy.
    
* **Fault Tolerance**

    When a component of a microservice fails (for example, redis), what happens? Implement a fault tolerance such as Netflix's Hystrix.
    
* **Produce messages**

    Using a compatible STOMP client, a microservice should be able to connect to the message server and send or produce messages that can be consumed by all the connected clients (clients that are connected to both the message broker and message channel)

### Integration Requirements for every Single-App Microservice
* Must obey all Single-App microservice requirements (see [Single-App Microservice Requirements][single-app-microservice])
* Shall define own endpoint through which it can send and receive messages
* Shall be able to send and receive messages
* Shall be able to exchange messages between other microservices
* Shall be able to receive messages from Apache Camel endpoints
* Shall be able to produce message to Apache Camel endpoints
* Shall support Asynchronous Routing with corresponding Apache Camel endpoints

[single-app-microservice]: https://github.com/yookore/yookore_poc/blob/master/docs/Microservice-Spec.md#single-app-microservice-requirements

### A Microservice as OAuth2 Resource Server
* Is a registered OAuth2 client server
* Shall protect its resources by validating the access_token from every client requests

## The 12 Factor
[The 12 Factor][12-factor] says that web applications should retrieve their configuration from environmental variables. Storing configuration as environment variables favours PaaS such as Cloud Foundry.

A real-life use case is application settings or system preferences.

[12-factor]: http://12factor.net/

## Cloud Foundry Global Environment variables
ENV               | Description
------------------|------------
HOME              | Root folder for the deployed application. For example, `HOME=/home/vcap/app`
MEMORY_LIMIT      | The maximum amount of memory that each instance of the application can consume. ```MEMORY_LIMIT=512m```
PORT              | The DEA allocates a port to the application during staging. For example, `PORT=61857`
PWD               | Identifies the present working directory, where the buildpack that processed the application ran. For example, `PWD=/home/vcap`
TMPDIR            | Directory location where temporary and staging files are stored. For example, TMPDIR=/home/vcap/tmp
VCAP_APP_HOST     | The IP address of the DEA host. For example, `VCAP_APP_HOST=0.0.0.0`
VCAP_APP_PORT     | Equivalent to the PORT variable
CF_INSTANCE_IP    | The external IP address of the DEA running the container with the app instance. For example, `CF_INSTANCE_IP=1.2.3.4`
CF_INSTANCE_PORT  | The PORT of the app instance. For example, `CF_INSTANCE_PORT=5678`
CF_INSTANCE_ADDR  | The CF_INSTANCE_IP and CF_INSTANCE_PORT of the app instance in the format 
CF_INSTANCE_INDEX | The index number of the app instance. For example, `CF_INSTANCE_INDEX=0`
CF_INSTANCE_PORTS | The external and internal ports allocated to the app instance. For example, `CF_INSTANCE_PORTS=[{external:5678,internal:5678}]`

- VCAP_APPLICATION: This variable contains useful information about a deployed application. 
   
        {
          "instance_id":"451f045fd16427bb99c895a2649b7b2a",
          "instance_index":0,
          "host":"0.0.0.0",
          "port":61857,
          "started_at":"2013-08-1200:05:29 +0000",
          "started_at_timestamp":1376265929,
          "start":"2013-08-12 00:05:29+0000",
          "state_timestamp":1376265929,
          "limits":{"mem":512,"disk":1024,"fds":16384},
          "application_version":"c1063c1c-40b9-434e-a797-db240b587d32",
          "application_name":"styx-james",
          "application_uris":["styx-james.a1-app.cf-app.com"],
          "version":"c1063c1c-40b9-434e-a797-db240b587d32",
          "name":"styx-james",
          "uris":["styx-james.a1-app.cf-app.com"],
          "users":null,
          "space_name": "dev"
        }
    
- VCAP_SERVICES: Cloud Foundry will add connection details to the VCAP_SERVICES environment variable when you restart your application

        {
          "sendgrid-n/a": [
            {
              "name": "mysendgrid",
              "label": "sendgrid-n/a",
              "tags": [
                "smtp"
              ],
              "plan": "free",
              "credentials": {
                "hostname": "smtp.sendgrid.net",
                "username": "QvsXMbJ3rK",
                "password": "HCHMOYluTv"
              }
            }
          ]
        }     

## Presentation Layer Microservice Requirements
* HTML5 compliant
* Client implementation shall be event-driven
* Uses MV (removing the Controller): The JavaScript user interface (UI) client handles arbitrary action requests in the form of a JSON payload, and sends them as a message on the messaging channel (the message endpoint)
* Should be able to connect, listen and subscribe to multiple message channels
* The application launches, handshakes and subscribes to a message bus, at which point it can post and react to subsequent messages on the bus.
* Possible Javascript MV* frameworks: Backbonejs, AngularJS, ReactJS,
* Possible Javascript View & templating: Rendr.js (use case to be investigated)
* Write own client models which should be compatible with its server-side counterpart in order to foster seamless asynchronous communication.

![Yookore Event-driven UI Layer](/docs/images/Yookore Event-driven UI Layer.png)

## Integration
How do we make microservices talk to one another.

There are 2 techniques to Integration:
- Integration by Service Discovery
- Integration by Messaging

### Integration by Service Discovery
Cloud Foundry has a built-in service registry called Consul. There are Consul clients for various programming languages including Python, Java, NodeJS

An alternative service registry is [Netflix's Eureka][eureka-netflix]. see [Example Java Implementation][eureka-spring-sample]

[eureka-netflix]: https://github.com/netflix/eureka
[eureka-spring-sample]: https://spring.io/blog/2015/01/20/microservice-registration-and-discovery-with-spring-cloud-and-netflix-s-eureka

### Apache Camel as Message Server and Channel Server
Camel brings a unique solution to our message routing requirements by aggregating all messages emitted by each microservice in a central location.

* Each microservice connects to Camel
* Each microservice registers its message channel with Camel
* When a microservice emits messages, Camel routes to the intended destination.

## Storing logs

Every microservice logs is managed by Cloud Foundry [Loggregator](https://github.com/cloudfoundry/loggregator). This means that devs should make use of the standard logging system of their preferred platform. For example,

Platform | Logging system
---------|---------------
Java     |`log4j`
Python   | ``
NodeJS   | `console`

To view application/microservice logs, see [Viewing microservice logs]

## Minifying Static files

## Storing binary files (Photos, Videos, Avatars)

see [Storage Requirements](https://github.com/yookore/yookore_poc/blob/master/docs/Infrastructure-Spec.md#storage-requirements)

## Mobile Integration
For asynchronous communication with various microservices, Android mobile apps can exchange messages over AMQP by using the [CloudAMQP android library](https://www.cloudamqp.com/blog/2014-10-28-rabbitmq-on-android.html).

### IOS Integration
For IOS, please check out the [librabbitmq-objc](https://github.com/profmaad/librabbitmq-objc)

### Windows mobile integration
Please checkout [amqpnetlite](https://github.com/Azure/amqpnetlite)
