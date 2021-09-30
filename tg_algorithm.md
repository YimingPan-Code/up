## Speaker-listener Label Propagation Algorithm

### Description and Uses

The Speaker-listener Label Propagation Algorithm (SLPA) is a variation of the Label Propagation algorithm that is able to detect overlapping communities. The main difference between LPA and SLPA is that each node can only hold a single label in LPA while it is allowed to possess multiple labels in SLPA. The algorithm begins with each vertex having its own unique label. Next we iteratively record labels in a local accumulator based on specific speaking rule and listening rule. Then the post-processing of the record labels is applied. Finally we remove the nested communities and output all the communities. Note that it is not guaranteed to produce the same results every time.

### Specifications

```
CREATE QUERY tg_slpa (SET<STRING> v_type, SET<STRING> e_type, FLOAT threshold, INT max_iter, INT output_limit, 
BOOL print_accum = TRUE, STRING file_path = "")
```


|  Characteristic   | Value  |
|  ----  | ----  |
| Result  | Assigns a list of component id (INT) to each vertex, such that members of the same component have the same id value. |
| Required Input Parameters  | **v_type**: vertex types to traverse <br> **e_type**: edge types to traverse <br> **threshold**: threshold to drop a label <br> **max_iter**: number of iterations <br> **print_accum**: print JSON output <br> **file_path**: file to write CSV output to <br> **output_limit**: max #vertices to output (-1 = all) |
| Result Size  | V = number of vertices |
| Time Complexity  | O(E*k), E = number of edges, k = number of iterations. |
| Graph Types  | Undirected edges |

### Example

In the example below, we run tg_slpa algorithm on the social10 graph. We set max_iter = 10 and threshold = 0.1. 

```javascript
# Use _ for default values
RUN QUERY (["Person"], ["Coworker"], _, _, _, _, _)
```
<div align=center>
<img src="slpa.png"/>
</div>
<center>Visualized results of example query on a social graph with undirected edges Coworker</center>

```json
[
  {
    "@@COM": {
      "Fiona": [294649859],
      "Alex": [270532609],
      "Damon": [279969793],
      "Justin": [270532609],
      "Eddie": [279969793],
      "Chase": [279969793],
      "Howard": [294649859],
      "George": [294649859],
      "Bob":[270532609],
      "Ivy":[294649859]  
    }
  }
]
```


## Breadth-first Search

### Description and Uses

Breadth-first Search (BFS) is an algorithm to explore the vertexes of a graph layer by layer. It starts at the given node and explores all nodes at the present depth prior to moving on to the nodes at the next depth level.

### Specifications

```
CREATE QUERY tg_bfs(SET<STRING> v_type, SET<STRING> e_type,INT max_hops=10, VERTEX v_start,
BOOL print_accum = True, STRING result_attr = "",STRING file_path = "", BOOL display_edges = True)
```



| Characteristic            | Value                                                        |
| ------------------------- | ------------------------------------------------------------ |
| Result                    | Returns all the nodes that are accessible from the source vertex|
| Required Input Parameters | **v_type**: vertex types to traverse <br> **e_type**: edge types to traverse <br> **max_hops**: look only this far from each vertex <br> **v_start**: source vertex for traverse <br> **print_accum**: print JSON output <br> **result_attr**: INT attr to store results to<br> **file_path**: file to write CSV output to<br> **display_edges**:output edges for visualization |
| Result Size               | V = number of vertices                                       |
| Time Complexity           | O(E+V), E = number of edges, V = number of vertices.since every vertex and every edge will be explored in the worst case. |
| Graph Types               | Directed or Undirected edges, Weighted or Unweighted edges |

### Example

In the example below, we run tg_bfs algorithm from the source vertex alex on the social10 graph.

```
# Use _ for default values
RUN QUERY tg_bfs(["Person"], ["Friend"], _, ("Alex","Person"), _, _, _, _)
```

<div align=center>
<img src="bfs.png"/>
</div>

## A*

### Description and Uses
A* (pronounced "A-star") is a graph traversal and path search algorithm, which achieves better performance by using heuristics to guide its search. The algorithm starts from a source node, and at each iteration of its main loop it selects the path that minimizes
$$f(n) = g(n) + h(n)$$
where n is the next node on the path, g(n) is the cost of the path from the source node to n, and h(n) is a heuristic function that estimates the cost of the cheapest path from n to the target node. The algorithm terminates when the path it chooses to extend is a path from start to goal or if there are no paths eligible to be extended. The heuristic function is problem-specific. If the heuristic function is admissible, meaning that it never overestimates the actual cost to get to the target, the algorithm is guaranteed to return a least-cost path from source to target.

### Specifications

```python
CREATE QUERY tg_astar(VERTEX source_vertex, VERTEX target_vertex, SET<STRING> e_type, STRING wt_type,
STRING wt_attr, BOOL display = False)
```

| Characteristic            | Value                                                        |
| ------------------------- | ------------------------------------------------------------ |
| Result                    | Computes a shortest distance (INT) and shortest path (STRING) from vertex source to  target vertex. |
| Required Input Parameters |  **source_vertex**: start vertex <br> **target_vertex**: target vertex <br> **e_type**: edge types to traverse<br> **wt_type**: weight data type (INT,FLOAT,DOUBLE)  <br> **wt_attr**: attribute for edge weights<br> **display**: output edges for visualization |
| Result Size               | 1                                       |
| Time Complexity           | O(V^2), V = number of vertices. |
| Graph Types               | Directed or Undirected edges, Weighted edges              |

Example

In the example below, we run tg_astar algorithm to find the shortest path between the source vertex "Kings Cross" and the target vertex "Kentish Town" on a graph which is a transport network of stations. Each station has its geometric attibutes(i.e.latitude and longitude) and the edge weight represents the distance between stations in kilometers. The heuristic function used to guide the search is the [Haversine Formula](https://en.wikipedia.org/wiki/Haversine_formula), which computes the distance between two points on a sphere given their longitudes and latitudes

```
# Use _ for default values
RUN QUERY astar(("Kings Cross","Station"), ("Kentish Town","Station"),["CONNECTION"], "FLOAT", "distance", _)
```

<div align=center>
<img src="astar.png"/>
</div>


## Article Rank

### Description and Uses

ArticleRank is a variant of the Page Rank algorithm, which measures the transitive influence of nodes.

Page Rank follows the assumption that relationships originating from low-degree nodes have a higher influence than relationships from high-degree nodes. Article Rank lowers the influence of low-degree nodes by lowering the scores being sent to their neighbors in each iteration.

formula:see google folder

### Specifications

```
CREATE QUERY tg_slpa (SET<STRING> v_type, SET<STRING> e_type, FLOAT threshold, INT max_iter, INT output_limit, 
BOOL print_accum = TRUE, STRING file_path = "")
```


|  Characteristic   | Value  |
|  ----  | ----  |
| Result  | Assigns a list of component id (INT) to each vertex, such that members of the same component have the same id value. |
| Required Input Parameters  | **v_type**: vertex types to traverse <br> **e_type**: edge types to traverse <br> **threshold**: threshold to drop a label <br> **max_iter**: number of iterations <br> **print_accum**: print JSON output <br> **file_path**: file to write CSV output to <br> **output_limit**: max #vertices to output (-1 = all) |
| Result Size  | V = number of vertices |
| Time Complexity  | O(E*k), E = number of edges, k = number of iterations. |
| Graph Types  | Undirected edges |

## Speaker-listener Label Propagation Algorithm

### Description and Uses

The Speaker-listener Label Propagation Algorithm (SLPA) is a variation of the Label Propagation algorithm that is able to detect overlapping communities. The main difference between LPA and SLPA is that each node can only hold a single label in LPA while it is allowed to possess multiple labels in SLPA. The algorithm begins with each vertex having its own unique label. Next we iteratively record labels in a local accumulator based on specific speaking rule and listening rule. Then the post-processing of the record labels is applied. Finally we remove the nested communities and output all the communities. Note that it is not guaranteed to produce the same results every time.

### Specifications

```
CREATE QUERY tg_slpa (SET<STRING> v_type, SET<STRING> e_type, FLOAT threshold, INT max_iter, INT output_limit, 
BOOL print_accum = TRUE, STRING file_path = "")
```


|  Characteristic   | Value  |
|  ----  | ----  |
| Result  | Assigns a list of component id (INT) to each vertex, such that members of the same component have the same id value. |
| Required Input Parameters  | **v_type**: vertex types to traverse <br> **e_type**: edge types to traverse <br> **threshold**: threshold to drop a label <br> **max_iter**: number of iterations <br> **print_accum**: print JSON output <br> **file_path**: file to write CSV output to <br> **output_limit**: max #vertices to output (-1 = all) |
| Result Size  | V = number of vertices |
| Time Complexity  | O(E*k), E = number of edges, k = number of iterations. |
| Graph Types  | Undirected edges |

## Speaker-listener Label Propagation Algorithm

### Description and Uses

The Speaker-listener Label Propagation Algorithm (SLPA) is a variation of the Label Propagation algorithm that is able to detect overlapping communities. The main difference between LPA and SLPA is that each node can only hold a single label in LPA while it is allowed to possess multiple labels in SLPA. The algorithm begins with each vertex having its own unique label. Next we iteratively record labels in a local accumulator based on specific speaking rule and listening rule. Then the post-processing of the record labels is applied. Finally we remove the nested communities and output all the communities. Note that it is not guaranteed to produce the same results every time.

### Specifications

```
CREATE QUERY tg_slpa (SET<STRING> v_type, SET<STRING> e_type, FLOAT threshold, INT max_iter, INT output_limit, 
BOOL print_accum = TRUE, STRING file_path = "")
```


|  Characteristic   | Value  |
|  ----  | ----  |
| Result  | Assigns a list of component id (INT) to each vertex, such that members of the same component have the same id value. |
| Required Input Parameters  | **v_type**: vertex types to traverse <br> **e_type**: edge types to traverse <br> **threshold**: threshold to drop a label <br> **max_iter**: number of iterations <br> **print_accum**: print JSON output <br> **file_path**: file to write CSV output to <br> **output_limit**: max #vertices to output (-1 = all) |
| Result Size  | V = number of vertices |
| Time Complexity  | O(E*k), E = number of edges, k = number of iterations. |
| Graph Types  | Undirected edges |

