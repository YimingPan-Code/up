import config
import sys
import subprocess
import json

def run(cmd):
    process = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, \
        stderr=subprocess.STDOUT)
    output = process.communicate()[0].strip()
    ret = process.returncode
    return ret, output

def verify_tag_edge_distribution(deviation):
    result = True
    with open(config.VerificationFile + deviation, "r") as fp:
        line = fp.readline()
        while line != "":
            line = line.split()
            cmd = "gsql \"run query tagEdgeNum(\\\"" + line[0] + "\\\")\""
            ret, output = run(cmd)
            try:
                retEdgeNum = json.loads(output)["results"][0]["tagEdgeNum"]
            except Exception as e:
                print "Json: " + output
                print "Exception: " + str(e) 
                result = False
            else:
                if ret != 0 or int(retEdgeNum) != int(line[1]):
                   print "Verfication failure! %s expected %s edges, given %s" % \
                       (line[0], line[1], retEdgeNum)
                   result = False 
            line = fp.readline()
    return result

def verify_product_edge_unification():
    result = True
    productOutdegree = config.TotalEdge / config.NumberOfProduct
    cmd = "gsql \"run query productVertexNum(" + str(productOutdegree) + ")\""
    ret, output = run(cmd)
    try:
        retOutdegree = json.loads(output)["results"][0]["productVertexNum"]
    except Exception as e:
        result = False
        print "Failed. Json: " + output
        #print "Exception: " + str(e) 
    else:
        if ret != 0 or retOutdegree != config.NumberOfProduct:
            result = False
            print "Verification failure! Ret:", ret, \
                " Expect %d product, given %d" % \
                (config.NumberOfProduct, retOutdegree)
    return result

print "Verifying loading " + sys.argv[1]
if not verify_tag_edge_distribution(sys.argv[1]):
    print "Failed to verify tag edge distribution!"
    sys.exit(-1)

if not verify_product_edge_unification():
    print "Failed to verify product edge unification!"
    sys.exit(-1)
