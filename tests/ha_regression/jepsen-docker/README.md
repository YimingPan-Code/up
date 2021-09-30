Dockerized Jepsen and Tigergraph Multi-Nodes System
=================

This docker image attempts to simplify the setup required by Tigergraph Jepsen test environment.
It is intended to be used by a CI tool or anyone with docker who wants to try it themselves.

It contains all the jepsen dependencies and code. It uses [Docker Compose](https://github.com/docker/compose) to spin up the three
containers used for Tigergraph Cluster and one container for Jepsen control node.

To setup the docker environment and log in the Jepsen control node

````
    ./up.sh
    docker exec -it jepsen-control bash
````
