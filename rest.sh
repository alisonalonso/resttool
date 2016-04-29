#!/bin/bash

CURL_DEFAULT_ARGS="-iks"
EXTRA_ARGS=""
EXEC=0
REST_CONFIG_FILE=$HOME"/.resttool"

# creating resttool config File
if [ ! -f $REST_CONFIG_FILE ]; then
	echo -e "REST_ENDPOINT=\nREST_USER=" > $REST_CONFIG_FILE
fi

function showUsage {
  cat <<-HELP
Usage: rest [options...] [verb] [resource] [ [data...] | [header...] ]

Options:
 -h ENDPOINT    Default Endpoint to work with. The host for API requests.
 -u USER[:PWD]  Default server user.
 <curl ops>     Any other CURL option, except -h and -u

Resouce: Path to the Rest API resource.

Verb: Any HTTP Verb (GET, POST, HEADER, PUT, DELETE, etc...)

Data: Data do send. If used with GET, data will put on the final URL. Other verbs, resttool will will pass the data to the server using the content-type application/x-www-form-urlencoded.
 key=value      Use a pair key-value to pass data to server

Header: You can pass extra header to include in the request. You may specify any number of extra headers.
 header:value   Use this form to send extra headers. 
HELP
}

# save the config 
# ($key, $value)
function saveConfigFile {
  key=$1
  value=$2
  SED="s/^\($key\)=.*/\1=${value//\//\\\/}/g"
  sed -i $SED $REST_CONFIG_FILE
}


while true; do
  case "$1" in
    -h)
      var=REST_ENDPOINT
      opt="$2"
      shift 2
      saveConfigFile $var $opt
      ;;
    -u) 
      var=REST_USER
      opt="$2"
      shift 2
      saveConfigFile $var $opt
      ;;
    GET)
      CURL_DEFAULT_ARGS="$CURL_DEFAULT_ARGS -G"
      shift
      ;;
    "HEAD")
      CURL_DEFAULT_ARGS="$CURL_DEFAULT_ARGS -I"
      shift
      ;;
    POST | PUT) 
      CURL_DEFAULT_ARGS="$CURL_DEFAULT_ARGS -X $1"
      shift
      ;;
    /*)
      RESOURCE=$1
      EXEC=true
      shift
      ;;
    *=* | \{*\})
      EXTRA_ARGS="$EXTRA_ARGS -d $1"
      shift
      ;;
    *:*)
      EXTRA_ARGS="$EXTRA_ARGS -H $1"
      shift
      ;;
    #-- ) shift; break ;;
    * ) break ;;
  esac

done

# Loading default args
. ~/.resttool
[ ! -z $REST_USER ] && REST_USER="-u $REST_USER"

if [ $EXEC = true ]; then
  curl $REST_USER $CURL_DEFAULT_ARGS $EXTRA_ARGS $REST_ENDPOINT$RESOURCE
else
  showUsage
fi

