#!/bin/bash
set -euo pipefail

main() {
  case "${1}" in
    start)
      start
      ;;
    *)
      exec "${@}"
      ;;
  esac
}

start() {
  echo "Building OpenGTS"
  cd "${GTS_HOME}" && ant all > /dev/null 2>&1 && cd /docker
  rm -rf "${CATALINA_HOME}/webapps/"* && mkdir "${CATALINA_HOME}/webapps/ROOT"
  cp "${GTS_HOME}/build/track.war" "${CATALINA_HOME}/webapps/track.war"
  echo "<% response.sendRedirect(\"/track/Track\"); %>" > "${CATALINA_HOME}/webapps/ROOT/index.jsp"

  echo "Starting MySQL"
  mysqld --initialize-insecure
  mysqld_safe --bind-address="*" > /dev/null 2>&1 &

  while [[ -z "$(pidof mysqld)" ]]; do
    sleep 2
  done

  sleep 5

  echo "Initializing database"
  mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'root'" --skip-password > /dev/null 2>&1
  mysql -e "RENAME USER 'root'@'localhost' TO 'root'@'%'" --password="root" > /dev/null 2>&1

  "${GTS_HOME}/bin/initdb.sh" -rootUser="root" -rootPass="root" > /dev/null 2>&1
  "${GTS_HOME}/bin/admin.sh" Account -account="default" -create -pass="default" > /dev/null 2>&1

  echo "Starting Tomcat"
  "${CATALINA_HOME}/bin/catalina.sh" run > /dev/null 2>&1 &

  echo "Starting DCS"
  # TODO: change tk10x
  "${GTS_HOME}/bin/runserver.sh" -s tk10x -p 10000 > /dev/null 2>&1

  echo "Ready"
  exec /sbin/my_init > /dev/null 2>&1
}

main "${@}"
