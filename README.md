StoryModelling
==============

An instagram for telling stories using models.

StoryModelling is a ludic environment for people involved with conceptual modelling. Usually modelling is conducted in very formal environments, either in enterprise, research or learning. 
StoryModelling is a ludic environment where people may post "stories" (m0-level models) which may be classified by existing conceptual models (m1-level models). Other users may "like", comment on or fork the stories. 
This environment should help people engage in meaningful conversation about modeling, share difficulties, get help and be creative.

StoryModelling focuses on m0 (token or object level) and allows classification using standard OntoUML models defined according to the OntoUMLPrime metamodel (https://github.com/nemo-ufes/ontoumlprime).

The stories metamodel is defined in eCore using the Eclipse Modelling Framework.
The data is served using emf-rest, a prototype for serving the model instances as JSON strings on a REST API (currently only GETs)
The data is then presented using d3.js
The d3.js presentation is embedded in a Corona SDK app.

