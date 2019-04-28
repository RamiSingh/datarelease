#!/bin/bash

# Q: Why do we need this script?
# A: To enable data release in an automated and standard way so that there is no room for any errors. This script will entail all the steps/commands that are essential in
#+   order to get the data release done effectively.

# Q: What are the types for files that need to be deployed?
# A: There are two kinds of changes that are raised by the SD team:
#                               a) PRICE FILES
#                               b) DATA FILES
#    These files have different fucntions and different locations on the file system.
#
# Q: What countries are these files deployed for?
# A: We deploy for AU and NZ. There are separate changes raised by the SD for these.
#
# Q: What about the environments?
# A: The files are released to the INT1 environment first. Once the testing passes for INT1, then these are deployed to PROD2 and then finally to PROD. These locations will
#    will need to be abstracted in the form of variables to make the script readable.
#
# Q: How will the script be structured?
# A: I have the following structure/flow in mind:
#
#       1. Initialise all the variables. These will primarily be the file locations.
#       2. Create fucntions based on location(AU/NZ) and type of release (Price/Data).
#       3. Create cases that call these functions based on the location and type of release.

# Let's get started
##############################
#   DATA RELEASE V1.0(WIP)   #
##############################


# Let's get the locations saved in the form of variables:
# For INT1 AU
ROOT_DIR_INT1=/mnt/backup/volaxn_iau/nfs/int1/masterdata/    #This is the common path.
PRICE_DIR_AU_INT1=$ROOT_DIR_INT1/au/master                  #Price files are dropped here by the data team. 
APWEB_AU_INT1=$ROOT_DIR_INT1/au/apwebdata
AUDMOB_AU_INT1=$ROOT_DIR_INT1/au/audamobile
SRCHTREE_AU_INT1_DATA=$ROOT_DIR_INT1/au/searchtree           #The same files need to be copied to axn/config directory or else there will be issues.
SRCHTREE_AU_INT1_CNFG=/mnt/backup/volaxn_iau/nfs/int1/axn/config/au/searchtree
QPTR_DROP_AU=$ROOT_DIR_INT1/au/Qapter                           #These files need to be copied to webpaddata folder under the correct directory structure.
WBPD_AU_INT1=$ROOT_DIR_INT1/au/webpaddata                    #Create a new directoy under this folder and copy the tips folder from the previous version folder.

#For INT1 NZ
PRICE_DIR_NZ_INT1=$ROOT_DIR_INT1/nz/master                   #Price files are dropped here by the data team. 
APWEB_NZ_INT1=$ROOT_DIR_INT1/nz/apwebdata
AUDMOB_NZ_INT1=$ROOT_DIR_INT1/nz/audamobile
SRCHTREE_NZ_INT1_DATA=$ROOT_DIR_INT1/nz/searchtree           #The same files need to be copied to axn/config directory or else there will be issues.
SRCHTREE_NZ_INT1_CNFG=/mnt/backup/volaxn_iau/nfs/int1/axn/config/nz/searchtree
QPTR_DROP_NZ=$ROOT_DIR_INT1/nz/Qapter                           #These files need to be copied to webpaddata folder under the correct directory structure.
WBPD_NZ_INT1=$ROOT_DIR_INT1/nz/webpaddata                    #Create a new directoy under this folder and copy the tips folder from the previous version folder.
