Tigergraph HA and Consistency Regression
=================

To run this test independently:

1. Install dependencies

````
     mkdir -p ~/lin
     cd ~/bin
     curl -O https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
     chmod a+x lein
     export PATH="$PATH":~/bin
````

2. To start a simple test under this folder, try the following command as an example

````
     # Notice that please make sure your ~/.bashrc be fully ran (some will forbid using the non-interactive mode)
     lein run test --node 192.168.55.79 --node 192.168.55.80 --node 192.168.55.81 --agent-node 192.168.55.81 --username tigergraph --password tigergraph --test-suite gse --recovery-time 10
      
````
