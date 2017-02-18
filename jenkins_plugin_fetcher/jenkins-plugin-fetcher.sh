#!/bin/bash
set -e
set -x

#Set up our variables

jenkins_user="jenkins"
jenkins_group="jenkins"
holding_folder="jenk_plugin_deps"
plugin="git"
version="2.4.1"
#Ensure folder exists
cd ~
if [ ! -d "$holding_folder" ]; then
  mkdir "$holding_folder";
fi
cd "$holding_folder"
getDeps(){
  deps="$(sed -n "/Plugin-Dependencies:/,/Plugin-Developers/p" "$1"/META-INF/MANIFEST.MF | sed -e "s/.*Plugin-Dependencies://;s/Plugin-Developers.*//" | tr -d " \t\n\r" | sed -r -e 's/[-a-z0-9-]*:[0-9.]*;resolution:=optional[, \n\t\r]//g' | tr ',' ' ')"
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
installPlugin(){
  if [ ! -d "$1" ]; then
    wget "http://updates.jenkins-ci.org/download/plugins/$1/$2/$1.hpi"
    unzip $1.hpi -d $1
    getDeps $1
  else
    echo "Plugin: $1 already exists"
  fi
}
installPlugin "$plugin" "$version"
chown jenkins:jenkins *
find . -name "*.hpi" | xargs cp -t /var/lib/jenkins/plugins
service jenkins restart
#deps="$(sed -n "/Plugin-Dependencies:/,/Plugin-Developers/p" artifactory/META-INF/MANIFEST.MF | sed -e "s/.*Plugin-Dependencies://;s/Plugin-Developers.*//" | tr -d " \t\n\r" | sed -r -e 's/,[-a-z0-9-]*:[0-9.]*;resolution:=optional//g' | tr ',' ' ')"
#for d in $deps
#  do
#  IFS=':' read dependency depversion <<< "$d"
#    installPlugin $dependency $depversion
#  done
