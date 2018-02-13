#!/bin/sh
  
# validate argument
if [ $# -ne 2 ]
then
  echo "Usage: compose.sh [tag] [domain]";
  exit 1;
fi

printf "This file is to jump start your compose.\nYou can configure your own docker-compose.yml file if needed.\nClick any key to continue.";
read -n1 -p "" ignore

askfile () {
  bool=true;
  while $bool
  do
    read -n1 -p "$1 [Y/n] " response
    if [ "$response" = "Y" -o "$response" = "y" ]
    then
      echo ""
      response=true
      bool=false
    elif [ "$response" = "N" -o "$response" = "n" ]
    then
      echo ""
      response=false
      bool=false
    else
      echo ""; echo "Enter Y or N"
    fi
  done
  echo "$response"
}

# set up volume directories
mkdir -p ./volume/content
mkdir -p ./volume/config
mkdir -p ./volume/assets

if [ ! -f ./volume/config/config.json ]
  then
    printf "\nCopying config.json..."
    cp ../assets/config.json ./volume/config/config.json
  else
    printf "\n"
    response=$(askfile "Use existing config.json?")
    if ! $response; then
      printf "\nCopying config.json..."
      cp ../assets/config.json ./volume/config.json
    fi
fi

# copy files over
usenewssl=true
if [ ! -f ./volume/assets/ssldomain ]
  then
    printf "\nCopying ssldomain..."
    cp ../assets/ssldomain ./volume/assets/ssldomain
  else
    printf "\n"
    response=$(askfile "Use existing ssldomain?")
    if $response
      then
        usenewssl=false
    else
      printf "\nCopying ssldomain..."
      cp ../assets/ssldomain ./volume/assets/ssldomain
    fi
fi

usenewdc=true
if [ ! -f ./docker-compose.yml ]
  then
    printf "\nCopying docker-compose.yml..."
    cp ./default-docker-compose.yml ./docker-compose.yml
  else
    printf "\n"
    response=$(askfile "Use existing docker-compose.yml?")
    if $response
      then
        usenewdc=false
    else
        printf "\nCopying docker-compose.yml..."
        cp ./default-docker-compose.yml ./docker-compose.yml
    fi
fi

# add tags to images and domain into docker-compose.yml & ssldomain file
OS=$(uname)
if $usenewssl; then
    printf "\nSetting up ssldomain..."
    if [[ "$OS" == "Linux" ]]; then
        sed -i "s/.*DOMAIN=.*/DOMAIN=$2/g" ./volume/assets/ssldomain
    elif [[ "$OS" == "Darwin" ]]; then
        sed -i "" "s/.*DOMAIN=.*/DOMAIN=$2/g" ./volume/assets/ssldomain
    fi
fi

if $usenewdc; then
    printf "\nSetting up docker-compose.yml..."
    if [[ "$OS" == "Linux" ]]; then
        sed -i "s/.*bengine.*/    image: $1\/bengine:latest" docker-compose.yml
        sed -i "s/.*qengine.*/    image: $1\/qengine:latest" docker-compose.yml
        sed -i "s/.*sagemath.*/    image: $1\/sagemath:latest" docker-compose.yml
        sed -i "s/.*python2.*/    image: $1\/python2.7:latest" docker-compose.yml
        sed -i "s/.*ffmpeg.*/    image: $1\/ffmpeg:latest" docker-compose.yml
        sed -i "s/.*imagemagick.*/    image: $1\/imagemagick:latest" docker-compose.yml
        sed -i "s/.*unconv.*/    image: $1\/unoconv:latest" docker-compose.yml
    elif [[ "$OS" == "Darwin" ]]; then
        sed -i "" "s/.*image:.*bengine.*/    image: $1\/bengine:latest/g" docker-compose.yml
        sed -i "" "s/.*image:.*qengine.*/    image: $1\/qengine:latest/g" docker-compose.yml
        sed -i "" "s/.*image:.*sagemath.*/    image: $1\/sagemath:latest/g" docker-compose.yml
        sed -i "" "s/.*image:.*python2.*/    image: $1\/python2.7:latest/g" docker-compose.yml
        sed -i "" "s/.*image:.*ffmpeg.*/    image: $1\/ffmpeg:latest/g" docker-compose.yml
        sed -i "" "s/.*image:.*imagemagick.*/    image: $1\/imagemagick:latest/g" docker-compose.yml
        sed -i "" "s/.*image:.*unoconv.*/    image: $1\/unoconv:latest/g" docker-compose.yml
    fi
fi

printf "\n"
response=$(askfile "Run Docker Compose ?")
if $response; then
  printf "\nRunning: docker-compose -f docker-compose.yml up -d --build\n"
  docker-compose -f docker-compose.yml up -d --build
fi

printf "\n"



