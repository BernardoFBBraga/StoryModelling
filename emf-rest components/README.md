StoryModelling
==============
Data serving using EMF-REST
==============

This part serves .xmi data as JSON strings in a REST API.
To get EMF-Rest running, follow the installation tutorial on http://emf-rest.com/install.html


Our folder structure follows the emf-rest default. 
The inputModel folder contains the .ecore model
The WebContent folder contains example xmi of the .ecore model


Don't forget to install Tomcat too, as EMF-REST depends on it. You may need to configure the Tomcat paths on your project properties under Java Build Path. Under libraries you may add jsp-api.jar and servlet-api.jar.


After setting the project, you'll need to confifure the Tomcat so the d3.js page may request the data. under Window>Show View>Servers you will find the Tomcat. Edit the server properties and under monitoring add port 8080 (default used by the Python simpleHTTPServer).