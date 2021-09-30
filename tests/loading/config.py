## The configuration file of the loading edge generator.
## Change it when you need to change the test case.

# loading dataset directory
LoadingDataDir = "dataset" + "/"
VerificationFile = LoadingDataDir + "verification"
DistributionChart = LoadingDataDir + "distribution.pdf"
TotalEdge = 1200000000
# number of vertexs of different types
NumberOfTags = 1000
NumberOfProduct = 200000000
# delta mean for generating the edges
DeltaMean = 0.1 * TotalEdge / NumberOfTags
# edge order inside loading file
# the tag vertex is with large amount of edges
# group or randomize it will have large performance difference.
groupTag = True

# deviation of the edge number distribution of tag vertex
# change these to control the distribution of the ourput edges
StdDeviationCases = [0.1,
                     0.1 * TotalEdge / NumberOfTags,
                     0.5 * TotalEdge / NumberOfTags,
                     1.0 * TotalEdge / NumberOfTags,
                     1.5 * TotalEdge / NumberOfTags,
                     3.0 * TotalEdge / NumberOfTags]

# for easier verification of loading, we need to satisfy the following condition
assert TotalEdge % NumberOfProduct == 0, \
    "Please config the TotalEdge exactly a multiple of NumberOfTags"

