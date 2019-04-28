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
PRICE_DIR_INT1=$ROOT_DIR_INT1/$COUNTRY/master/                  #Price files are dropped here by the data team.
APWEB_INT1=$ROOT_DIR_INT1/$COUNTRY/apwebdata/
AUDMOB_INT1=$ROOT_DIR_INT1/$COUNTRY/audamobile/                 #There is no audamobile for NZ; so need to figure out a way to avoid this for NZ.
SRCHTREE_INT1_DATA=$ROOT_DIR_INT1/$COUNTRY/searchtree/           #The same files need to be copied to axn/config directory or else there will be issues.
SRCHTREE_INT1_CNFG=/mnt/backup/volaxn_iau/nfs/int1/axn/config/$COUNTRY/searchtree/
QPTR_DROP=$ROOT_DIR_INT1/$COUNTRY/Qapter                       #These files need to be copied to webpaddata folder under the correct directory structure.
WBPD_INT1=$ROOT_DIR_INT1/$COUNTRY/webpaddata                    #Create a new directoy under this folder and copy the tips folder from the previous version folder.

#For INT1 NZ
#PRICE_DIR_NZ_INT1=$ROOT_DIR_INT1/$COUNTRY/master                   #Price files are dropped here by the data team.
#APWEB_NZ_INT1=$ROOT_DIR_INT1/nz/apwebdata
#AUDMOB_NZ_INT1=$ROOT_DIR_INT1/nz/audamobile
#SRCHTREE_NZ_INT1_DATA=$ROOT_DIR_INT1/nz/searchtree           #The same files need to be copied to axn/config directory or else there will be issues.
#SRCHTREE_NZ_INT1_CNFG=/mnt/backup/volaxn_iau/nfs/int1/axn/config/nz/searchtree
#QPTR_DROP_NZ=$ROOT_DIR_INT1/nz/Qapter                           #These files need to be copied to webpaddata folder under the correct directory structure.
#WBPD_NZ_INT1=$ROOT_DIR_INT1/nz/webpaddata                    #Create a new directoy under this folder and copy the tips folder from the previous version folder.

# Now that the location specific variables are taken care of, let's find a way for the user to provide some way of input to distinguish between the role of this script.
# I want the user to input firstly whether the script is being used to do a price file release or a data release. Also, I need the user to tell the script as to what country is it for and
# what envrironment. I am thinking of creating fucntions for each of these tasks and then depending on the user input, calling a case to perform that function.
# Firstly need to find out out what the user wants to do. Let's ask some questions:

echo "What do you want to do?"
sleep 2
echo "Your options are:"
echo "Price File Update OR Data Release"
sleep 2
echo "For PriceFileUpdate, enter: PRICE"
sleep 2
echo "For DataRelease, enter: DATA"

#NOTE: CREATE SIMILAR ECHO COMMANDS TO GET THE VERSIONS OF PRICE FILES AND DATA RELEASE#

# User's iput will need to be stored in a variable for later use:
read UINPT                     # This variable defines the task that the script is doing.
echo "You have chosen a $UINPT release."

# Now, we need to know what country does the user want to make the changes to. Again, asking some questions:

echo "What country you want to run this script for?"
sleep 2
echo "Options are: au or nz"
sleep 2
echo "Please enter one of the options from au/nz"

# Let's read the input and save this in a variable country
read COUNTRY
echo "You have chosen $COUNTRY."

#GET THE USER TO INPUT THE VERSIONS OF THE FILES AND CREATE FUNCTIONS THAT BASED ON $UINPT TO PRESENT FOR PRICE FILE OR DATA RELEASE VERSIONS.

# Create a function that does the price file changes
price() {
#cd to the master directoy
cd $PRICE_DIR_INT1
#Save the value of lastversion into a variable. This will be the directory to copy old files from
PREV_VER=$(cat lastversion.dat)
echo "The last version of the Price File is $PREV_VER"
#Now, there are some files that are common to both AU and NZ but there is one file that is not. So let's make two fucntions that can take care of that.
#But first, let's copy the common files across to the new folder.








}
