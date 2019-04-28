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

