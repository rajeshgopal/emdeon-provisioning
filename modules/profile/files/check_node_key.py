#!/usr/bin/python
import requests
import shell_comm
import sys

try:
        SERVER = sys.argv[1]
except:
        print "Please give master server IP"
        sys.exit(1)
MASTER_KEY = "cluster_master"
MASTER_VALUE = "%s" %shell_comm.ipadd()
MASTER_PAYLOAD = {MASTER_KEY:MASTER_VALUE}
NODES_ENDPOINT = "http://%s:8500/v1/catalog/nodes" %SERVER
KEY_ENDPOINT = "http://%s:8500/v1/kv/" %SERVER
allnodes = []

nodes_req = requests.get(NODES_ENDPOINT)

if nodes_req.status_code == 200:
	for items in nodes_req.json():
                if items['TaggedAddresses'] != None and items['TaggedAddresses']['wan']!=SERVER:
			allnodes.append(str(items['TaggedAddresses']['wan']))
	if len(allnodes)==0:
		print "No nodes available"
		print "Bring up your cluster setup"
	elif len(allnodes)==1:
		#print "Let's set up %s for cluster master" %allnodes[0]
                master_endpoint = KEY_ENDPOINT + MASTER_KEY
                master_req = requests.get(master_endpoint)
                if master_req.status_code == 404:
			#print "Master Key Not found, let's set up cluster master"
			set_master = KEY_ENDPOINT + MASTER_KEY
			set_master_req = requests.put(set_master, data=MASTER_PAYLOAD)
			if set_master_req.status_code == 200:
                                #print "Master Key Loaded successfully"
                                #pass
                                print shell_comm.host()
                                print str([shell_comm.host()])
			else:
				print "Check your configurations, Master Key Loading unsuccessful"
		elif master_req.status_code == 200:
	                #print "Master Key Found, but only one node present"
        	        master_value_endpoint = KEY_ENDPOINT + MASTER_KEY + '?raw'
                	master_val_req = requests.get(master_value_endpoint)
                        if master_val_req.status_code == 200:
                                if master_val_req.text.split('=')[1] == shell_comm.ipadd():
                                        print "This is the master, please setup your node"
                                else:
                                        print "%s"%master_val_req.text.split('=')[1]
                                        print "%s"%str(allnodes)
                        else:
                                print "Some error occured in orchestration"
        else:
                #print "Your master should already be up, set the rest of the nodes"
                master_value_endpoint = KEY_ENDPOINT + MASTER_KEY + '?raw'
                master_val_req = requests.get(master_value_endpoint)
                if master_val_req.status_code == 200:
                        print "%s"%master_val_req.text.split('=')[1]
                        print "%s"%str(allnodes)
