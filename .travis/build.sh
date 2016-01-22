#!/bin/bash
set -e

function deploy() {
  if [ "$1" != "porcelain" ];
  then
    echo "Executing Maven deploy (${TRAVIS_BRANCH})..."
    mvn clean deploy -B -U -Dcodebase.directory=$(pwd) -Dcoverage.reports.dir=$(pwd)/target/all --settings target/config/ci/settings.xml
  else
    echo "Skipped Maven deploy (${TRAVIS_BRANCH}): Porcelain"
  fi
}

function install() {
  if [ "$1" != "porcelain" ];
  then
    echo "Executing Maven install (${TRAVIS_BRANCH})..."
    mvn clean install -B -U -Dcoverage.reports.dir=$(pwd)/target/all --settings target/config/ci/settings.xml
  else
    echo "Skipped Maven install (${TRAVIS_BRANCH}): Porcelain"
  fi
}

mode=$1

if [ "${TRAVIS_PULL_REQUEST}" = "false" ];
then
  case "${TRAVIS_BRANCH}" in
    master | develop ) deploy "$mode";;
    feature\/*       ) install "$mode";;
    *                ) install "$mode";;
  esac
else
  install "$mode"
fi
