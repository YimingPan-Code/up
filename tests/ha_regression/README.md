Tigergraph HA and Consistency Regression
=================

This folder is for Tigergraph HA and Consistency Regression. Its tests rely on [Jepsen](https://github.com/jepsen-io/jepsen). It is intended to be used by a CI tool or anyone with docker who wants to try the test themselves.

The folder jepsen-docker contains the docker setups for Tigergraph multi-nodes system as well as jepsen environment.

The folder jepsen-tigergraph contains the test cases. Different failure scenarios and cases of our system can be added here.

1. Install dependencies

````
     curl -fsSL get.docker.com -o get-docker.sh
     sh get-docker.sh
     sudo curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
     chmod 777 /usr/local/bin/docker-compose
     sudo apt-get install -y gnuplot || sudo yum install -y gnuplot
````

2. To start a simple test

````
    ./setup.sh
    docker exec -it jepsen-control /jepsen/tigergraph/run.sh
````
