#! /usr/bin/python
import config

import numpy
import matplotlib
matplotlib.use('Agg')
from matplotlib import pyplot
from matplotlib.backends.backend_pdf import PdfPages

import os
import shutil

shutil.rmtree(config.LoadingDataDir)
os.mkdir(config.LoadingDataDir)
bins = numpy.linspace(0, 2 * config.TotalEdge / config.NumberOfTags, 12)

pp = PdfPages(config.DistributionChart)
figureIdx = 0
for deviation in config.StdDeviationCases:
  # generate normal distribution 
  distribution = numpy.random.normal(config.TotalEdge / config.NumberOfTags - config.DeltaMean, \
      deviation, config.NumberOfTags)
  
  # round up distribution
  dist = []
  for i in range(len(distribution)):
      count = int(round(distribution[i], 0))
      if distribution[i] < 0:
          dist.append(1)
      elif distribution[i] > 2 * config.TotalEdge / config.NumberOfTags - config.DeltaMean:
          dist.append(int(2 * config.TotalEdge / config.NumberOfTags - config.DeltaMean - 1))
      else:
          dist.append(count)

  delta = sum(dist) - config.TotalEdge
  distlen = len(distribution)
  while delta > distlen or delta < -1 * distlen:
      for i in range(distlen):
          dist[i] -= int(delta / (distlen - i))
          delta -= int(delta / (distlen - i))
          if dist[i] < 0:
              delta -= (dist[i] - 1)
              dist[i] = 1
  for i in range(distlen):
      if dist[i] > delta:
          dist[i] -= delta
        
  print "Deviation from mean:", deviation, ", Total edge count:", sum(dist)

  # draw distribution
  subplot = pyplot.figure(figureIdx)
  figureIdx += 1
  pyplot.title("Distribution of Tag Edge Count\n"
      "(x-axis: EdgeNum of Vertex Tag)\n"
      "(y-axis: Count)", fontsize=20)
  #pyplot.xlable("EdgeNum/Tag")
  #pyplot.ylable("TagCount")
  _, _, bars = pyplot.hist(dist, bins, alpha=0.5, label=str(int(deviation)))
  pyplot.legend(loc='upper right')
  pp.savefig(subplot, dpi = 300, transparent = True)
  t = [bar.remove() for bar in bars]

  # output edge csv
  with open(config.LoadingDataDir + str(figureIdx) + ".csv", "w", 1024 * 1024 * 128) as fout:
      if config.groupTag:
        productRoundRobinCounter = 0
        for i in range(config.NumberOfTags):
          count = dist[i]
          for j in range(int(count)):
            fout.write("prod%d,tag%d\n" % (productRoundRobinCounter % config.NumberOfProduct, i))
            productRoundRobinCounter = (productRoundRobinCounter + 1) % config.NumberOfProduct
      else:
        tagRoundRobinCounter = 0 
        edgeNumOfProduct = config.TotalEdge / config.NumberOfProduct
        for i in range(config.NumberOfProduct):
          for j in range(edgeNumOfProduct):
            fout.write("prod%d,tag%d\n" % (i, tagRoundRobinCounter % config.NumberOfTags))
            tagRoundRobinCounter = (tagRoundRobinCounter + 1) % config.NumberOfTags

  # output verification file
  with open(config.VerificationFile + str(figureIdx), "w", 1024*1024) as fout:
    for i in range(config.NumberOfTags):
      fout.write("tag%d %d\n" % (i, dist[i]))

pp.close()
