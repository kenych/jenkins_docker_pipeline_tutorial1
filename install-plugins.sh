#!/usr/bin/env bash

plugin_url_base="https://updates.jenkins-ci.org"

JENKINS_PLUGINS=(
job-dsl:1.59
ws-cleanup)

JENKINS_URL="http://localhost:8080"
JENKINS_CLI="jenkins-cli.jar"
VERSION_SEPARATOR=":"

curl -O ${JENKINS_URL}/jnlpJars/jenkins-cli.jar

# Pinned and latest version url examples:
# https://updates.jenkins-ci.org/download/plugins/ws-cleanup/0.34/ws-cleanup.hpi
# https://updates.jenkins-ci.org/latest/ws-cleanup.hpi

for plugin_identifier in ${JENKINS_PLUGINS[@]}
do
  plugin_name=$(echo ${plugin_identifier} | cut -d ${VERSION_SEPARATOR} -f 1)
  plugin_version=$(echo ${plugin_identifier} | cut -d ${VERSION_SEPARATOR} -f 2)

  [[ ${plugin_identifier} =~ .*${VERSION_SEPARATOR}.* ]] &&
    plugin_url_path="download/plugins/${plugin_name}/${plugin_version}/${plugin_name}.hpi" || \
    plugin_url_path="latest/${plugin_name}.hpi"


    echo "downloading: ${plugin_url_base}/${plugin_url_path}"

    curl -vL "${plugin_url_base}/${plugin_url_path}" -o "${plugin_name}.hpi"

  #    doesn't work!
  # java -jar ${JENKINS_CLI} -auth admin:"${ADMIN_TOKEN}" -noCertificateCheck -s ${JENKINS_URL} install-plugin "${plugin_url_base}/${plugin_url_path}"
    curl -i -F file=@${plugin_name}.hpi ${JENKINS_URL}/pluginManager/uploadPlugin

done

sleep 20

curl "${JENKINS_URL}/pluginManager/api/json?depth=1" | jq -r '.plugins[] | .shortName + ":"+ .version'


