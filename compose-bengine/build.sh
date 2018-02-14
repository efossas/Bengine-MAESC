#!/bin/sh
  
# validate argument
if [ $# -ne 1 ]
then
  echo "Usage: build.sh [tag]";
  exit 1;
fi

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

# build which images ?
bengine=$(askfile "Build bengine ? [Y/n] ")
printf "\n"; qengine=$(askfile "Build qengine ? [Y/n] ")
printf "\n"; ffmpeg=$(askfile "Build ffmpeg ? [Y/n] ")
printf "\n"; imagemagick=$(askfile "Build imagemagick ? [Y/n] ")
printf "\n"; python2=$(askfile "Build python2.7 ? [Y/n] ")
printf "\n"; sagemath=$(askfile "Build sagemath ? [Y/n] ")
printf "\n"; unoconv=$(askfile "Build unoconv ? [Y/n] ")
printf "\n";

# build images
if $bengine; then
  cd .. && ./build.sh "$1"
  cd -
  echo "bengine built"
fi

if $qengine; then   
  rm -rf docker-qengine
  git clone https://gitlab.com/academicsystems/docker-qengine
  if ! grep -Fxq "compose-bengine/docker-qengine" ../.gitignore; then echo "compose-bengine/docker-qengine" >> ../.gitignore; fi
  cd docker-qengine && ./build.sh "$1" "localhost"
  cd .. && rm -rf docker-qengine
  echo "qengine built"
fi

if $ffmpeg; then   
  rm -rf docker-ffmpeg
  git clone https://gitlab.com/academicsystems/docker-ffmpeg
  if ! grep -Fxq "compose-bengine/docker-ffmpeg" ../.gitignore; then echo "compose-bengine/docker-ffmpeg" >> ../.gitignore; fi
  cd docker-ffmpeg && ./build.sh "$1"
  cd .. && rm -rf docker-ffmpeg
  echo "ffmpeg built"
fi

if $imagemagick; then 
  rm -rf docker-imagemagick
  git clone https://gitlab.com/academicsystems/docker-imagemagick
  if ! grep -Fxq "compose-bengine/docker-imagemagick" ../.gitignore; then echo "compose-bengine/docker-imagemagick" >> ../.gitignore; fi
  cd docker-imagemagick && ./build.sh "$1"
  cd .. && rm -rf docker-imagemagick
  echo "imagemagick built"
fi

if $python2; then
  rm -rf docker-python2.7
  git clone https://gitlab.com/academicsystems/docker-python2.7
  if ! grep -Fxq "compose-bengine/docker-python2.7" ../.gitignore; then echo "compose-bengine/docker-python2.7" >> ../.gitignore; fi
  cd docker-python2.7 && ./build.sh "$1"
  cd .. && rm -rf docker-python2.7
  echo "python2.7 built"
fi

if $sagemath; then
  rm -rf docker-sagemath
  git clone https://gitlab.com/academicsystems/docker-sagemath
  if ! grep -Fxq "compose-bengine/docker-sagemath" ../.gitignore; then echo "compose-bengine/docker-sagemath" >> ../.gitignore; fi
  cd docker-sagemath && ./build.sh "$1"
  cd .. && rm -rf docker-sagemath
  echo "sagemath built"
fi

if $unoconv; then 
  rm -rf docker-unoconv
  git clone https://gitlab.com/academicsystems/docker-unoconv
  if ! grep -Fxq "compose-bengine/docker-unoconv" ../.gitignore; then echo "compose-bengine/docker-unoconv" >> ../.gitignore; fi
  cd docker-unoconv && ./build.sh "$1"
  cd .. && rm -rf docker-unoconv
  echo "unoconv built"
fi


