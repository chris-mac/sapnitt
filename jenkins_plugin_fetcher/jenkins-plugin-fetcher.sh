#!/bin/bash
set -e
set -x

#Set up our variables

plugin="$1"
version="$2"

getDeps(){
  deps="$(sed -n "/Plugin-Dependencies:/,/Plugin-Developers/p" "$1"/META-INF/MANIFEST.MF | sed -e "s/.*Plugin-Dependencies://;s/Plugin-Developers.*//" | tr -d " \t\n\r" | sed -r -e 's/[-a-z0-9-]*:[0-9.]*;resolution:=optional//g' | tr ',' ' ')"
  if [ -n "$deps" ]; then
    for d in $deps
      do
        IFS=':' read dependency depversion <<< "$d"
        installPlugin $dependency $depversion
      done
  else
    echo "No essential dependencies"
  fi 
}

#Taken from http://stackoverflow.com/questions/16989598/bash-comparing-version-numbers#24067243
function version_gt() { test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1"; }

installPlugin(){
  if [ ! -d "$1" ]; then
    wget "http://updates.jenkins-ci.org/download/plugins/$1/$2/$1.hpi"
    unzip $1.hpi -d $1
    getDeps $1
  else
    #Get plugin current verion and overwrite
    currentversion="$(grep '^Plugin-Version: ' $1/META-INF/MANIFEST.MF | sed -e "s/Plugin-Version: //g")"
    if version_gt $2 $currentversion; then
      echo "Upgrading plugin: $1 version from $currentversion to $2"
      rm -rf $1 $1.jpi
      wget "http://updates.jenkins-ci.org/download/plugins/$1/$2/$1.hpi" -O $1.hpi
      unzip -o $1.hpi -d $1
      getDeps $1
    fi
  fi
}
service jenkins stop
cd /var/lib/jenkins/plugins
installPlugin "$plugin" "$version"
chown -R jenkins:jenkins *
service jenkins start
