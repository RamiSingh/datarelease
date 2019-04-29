#!/bin/bash

#NOTE: This script needs to be run as a root user. {Maybe I can add a test to this effect.}

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

# Now that the location specific variables are taken care of, let's find a way for the user to provide some way of input to distinguish between the role of this script.
# I want the user to input firstly whether the script is being used to do a price file release or a data release. Also, I need the user to tell the script as to what country is it for and
# what envrironment. I am thinking of creating fucntions for each of these tasks and then depending on the user input, calling a case to perform that function.
# Firstly need to find out out what the user wants to do. Let's ask some questions:


echo "What country you want to run this script for?"
echo "Options are: au or nz"
echo "Please enter one of the options from au/nz. Please use lower case only"

# Let's read the input and save this in a variable country
read COUNTRY
echo "You have chosen $COUNTRY."


echo "What do you want to do?"
echo "Your options are:"
echo "Price File Update OR Data Release"
echo "For PriceFileUpdate, enter: PRICE"
echo "For DataRelease, enter: DATA"

# User's iput will need to be stored in a variable for later use:
read UINPT                     # This variable defines the task that the script is doing.
echo "You have chosen a $UINPT release."

#NOTE: CREATE SIMILAR ECHO COMMANDS TO GET THE VERSIONS OF PRICE FILES AND DATA RELEASE#

#Create a function for prompting for price file version:

price_prompt()
{
      echo "Please enter the price file version in the format XXXX. e.g. 0075"
      read NEW_PRICE
}

#The reason to use separate prompts for AU and NZ is that the Audamobile does not exist for NZ.
data_prompt_au()
{
      echo "Please enter the version of apwebdata/onepad"
      read APW_AU

      echo "Please enter the version of Audamobile"
      read AM_AU

      echo "Please enter the version of Searchtree"
      read ST_AU

     #Qapter files need to be  copied over to the webpaddata folder before being updated.We will get the Qapter folder version and then move the files
     #+ This is only for INT1. For Prod2 the files will be directly copied from INT1. Same goes for PROD.
      echo "Please enter the version of Qapter"
      read QAP_AU
}

data_prompt_nz()
{
      echo "Please enter the version of apwebdata/onepad"
      read APW_NZ


      echo "Please enter the version of Searchtree"
      read ST_NZ

     #Qapter files need to be  copied over to the webpaddata folder before being updated.We will get the Qapter folder version and then move the files
     #+ This is only for INT1. For Prod2 the files will be directly copied from INT1. Same goes for PROD.
      echo "Please enter the version of Qapter"
      read QAP_NZ
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
