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
  cd "${GTS_HOME}" && ant all && ant taip && cd /docker
  rm -rf "${CATALINA_HOME}/webapps/"* && mkdir "${CATALINA_HOME}/webapps/ROOT"
  cp "${GTS_HOME}/build/track.war" "${CATALINA_HOME}/webapps/track.war"
  echo "<% response.sendRedirect(\"/track/Track\"); %>" > "${CATALINA_HOME}/webapps/ROOT/index.jsp"

  echo "Starting MySQL"
  mysqld --initialize-insecure
  mysqld_safe --bind-address="*" &

  while [[ -z "$(pidof mysqld)" ]]; do
    sleep 2
  done

  sleep 5

  echo "Initializing database"
  mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'root'" --skip-password
  mysql -e "RENAME USER 'root'@'localhost' TO 'root'@'%'" --password="root"

  "${GTS_HOME}/bin/initdb.sh" -rootUser="root" -rootPass="root"
  "${GTS_HOME}/bin/admin.sh" Account -account="default" -create -pass="default"

  echo "Starting Tomcat"
  "${CATALINA_HOME}/bin/catalina.sh" run &

  echo "Starting DCS"
  "${GTS_HOME}/bin/runserver.sh" -s taip -p 31275

  echo "Ready"
  exec /sbin/my_init
}

main "${@}"
