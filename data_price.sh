#!/bin/bash

#NOTE: This script needs to be run as a root user or SUDO. {Maybe I can add a test to this effect.}

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

#INT1 specific directories:
ROOT_DIR_INT1=/mnt/backup/volaxn_iau/nfs/int1/masterdata/    #This is the common path.
PRICE_DIR_INT1=$ROOT_DIR_INT1/$COUNTRY/master/                  #Price files are dropped here by the data team.
APWEB_INT1=$ROOT_DIR_INT1/$COUNTRY/apwebdata/
AUDMOB_INT1=$ROOT_DIR_INT1/$COUNTRY/audamobile/                 #There is no audamobile for NZ; so need to figure out a way to avoid this for NZ.
SRCHTREE_INT1_DATA=$ROOT_DIR_INT1/$COUNTRY/searchtree/           #The same files need to be copied to axn/config directory or else there will be issues.
SRCHTREE_INT1_CNFG=/mnt/backup/volaxn_iau/nfs/int1/axn/config/$COUNTRY/searchtree/
QPTR_DROP=$ROOT_DIR_INT1/$COUNTRY/Qapter                       #These files need to be copied to webpaddata folder under the correct directory structure.
WBPD_INT1=$ROOT_DIR_INT1/$COUNTRY/webpaddata                    #Create a new directoy under this folder and copy the tips folder from the previous version folder.

#PROD specific directories
ROOT_DIR_PROD=/mnt/backup/volaxn_pau/nfs/masterdata/
PRICE_DIR_PROD=$ROOT_DIR_PROD/$COUNTRY/master/
APWEB_PROD=$ROOT_DIR_PROD/$COUNTRY/apwebdata/
AUDMOB_PROD=$ROOT_DIR_PROD/$COUNTRY/audamobile/
SRCHTREE_PROD_DATA=$ROOT_DIR_PROD/$COUNTRY/searchtree/
SRCHTREE_PROD_CNFG=/mnt/backup/volaxn_pau/nfs/prod/axn/config/$COUNTRY/searchtree/
WBPD_PROD=$ROOT_DIR_PROD/$COUNTRY/webpaddata/                          #There is no Qapter folder for PROD and PROD2. The files are transferred from INT1 webpaddata directly.




# Now that the location specific variables are taken care of, let's find a way for the user to provide some way of input to distinguish between the role of this script.
# I want the user to input firstly whether the script is being used to do a price file release or a data release. Also, I need the user to tell the script as to what country is it for and
# what envrironment. I am thinking of creating fucntions for each of these tasks and then depending on the user input, calling a case to perform that function.

# Firstly need to find out out what the user wants to do. Let's ask some questions:
echo "What country you want to run this script for?
      Options are: au or nz
      Please enter one of the options from au/nz. Please use lower case only"

# Let's read the input and save this in a variable country
read -r COUNTRY
echo "You have chosen $COUNTRY."

echo "What update do you want to do?
      Your options are:
      For PriceFileUpdate, enter: PRICE
      For DataRelease, enter: DATA"

# User's iput will need to be stored in a variable for later use:
read -r UINPT                     # This variable defines the task that the script is doing.
echo "You have chosen a $UINPT release."

# Ask user for the environment for which this script needs to run:

echo "Which environment are you making the changes on?
Your options are:
INT
PP
PROD"
echo "Please enter one of the above options"
read -r ENV

# The idea is to create functions for each of these environments. INT and PROD can be done using the same function but PP will need to be written separately as the file system structure will not allow for simple cp command.


#NOTE: CREATE SIMILAR ECHO COMMANDS TO GET THE VERSIONS OF PRICE FILES AND DATA RELEASE#

#Create a function for prompting for price file version:

price_prompt()
    {
      echo "Please enter the price file version in the format XXXX. e.g. 0075"
      read -r NEW_PRICE     #This will be called by the price file update function.
    }

#The reason to use separate prompts for AU and NZ is that the Audamobile does not exist for NZ.
data_prompt_au()
    {
      echo "Please enter the version of apwebdata/onepad"
      read -r APW_AU

      echo "Please enter the version of Audamobile"
      read -r AM_AU

      echo "Please enter the version of Searchtree"
      read -r ST_AU

     #Qapter files need to be  copied over to the webpaddata folder before being updated.We will get the Qapter folder version and then move the files
     #+ This is only for INT1. For Prod2 the files will be directly copied from INT1. Same goes for PROD.
      echo "Please enter the version of Qapter"
      read -r QAP_AU
    }

data_prompt_nz()
    {
      echo "Please enter the version of apwebdata/onepad"
      read -r APW_NZ


      echo "Please enter the version of Searchtree"
      read -r ST_NZ

     #Qapter files need to be  copied over to the webpaddata folder before being updated.We will get the Qapter folder version and then move the files
     #+ This is only for INT1. For Prod2 the files will be directly copied from INT1. Same goes for PROD.
      echo "Please enter the version of Qapter"
      read -r QAP_NZ
    }

#The functions to gather the version details are now done. Next, we need to use these functions in a case statement:

case "$UINPT" in

  PRICE|price) price_prompt
              ;;
  DATA|data)
              if [[ $COUNTRY == 'au' ]];
              then
                  data_prompt_au
              elif [[ $COUNTRY == 'nz' ]];
              then
                  data_prompt_nz
              else
                  exit 4
              fi
              ;;
esac

# PRICE FILE update function is probably the simpleast of these.

price_update()
{

    cd $PRICE_DIR_INT1=$ROOT_DIR_INT1/$COUNTRY/master/   #Both PrOD2 and PROD get the updated files from INT1 directory.

    case "$ENV" in
#Let the case decide what commands need to run based on the ENV given by the user.
        INT)
          PREVER=$(cat lastversion.dat)
          cp -p $PREVER/P8000.* $NEW_PRICE/
# Nested case to determine the Country specific files that are copied over from the previous folder. There must be a better way to do this but let's just stick with
#+ what we are used to doing.
                    case $COUNTRY in
                        au) cp -p $PREVER/P8005enAU.dat $NEW_PRICE/
                        ;;
                        nz) cp -p $PREVER/P8006ENNZ.dat $NEW_PRICE/
                        ;;
                    esac

         echo $NEW_PRICE > lastversion.dat
         ;;

        PP)
          scp -r $NEW_PRICE tcserver@axn-tc01-p2au:/u01/masterdata/$COUNTRY/master/ && sleep 10   # scp will take some time so to make sure that
          #+ it finishes before updating the lastversion, putting it to sleep for 10 seconds.
          scp lastversion.dat tcserver@axn-tc01-p2au:/u01/masterdata/$COUNTRY/master/
        ;;

        PROD)
          cp -rp $NEW_PRICE  $PRICE_DIR_PROD/ && sleep 10
          echo $NEW_PRICE > $PRICE_DIR_PROD/lastversion.dat
        ;;
    esac
 }

# The next big step is to create functions that run the data release updates
# Need to figure out a way to create a single function for data release for both AU and NZ. 'case statement' seems like a good candidate
#+ for this. This will only be needed in case of Audomobile update as AM is not present in NZ. So, the script should simply echo that
#+ there is nothing to do when the case encouters NZ.
