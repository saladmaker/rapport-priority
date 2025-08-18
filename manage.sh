#!/bin/bash

set -e

PROJECT_NAME="rapport_stack"
APP_DIR="rapport-service"

function build_app() {
  echo "📦 Packaging Quarkus runner jar..."
  (cd $APP_DIR && ./mvnw package -DskipTests)
}

function start() {
  build_app
  echo "🚀 Starting containers..."
  docker compose --project-name $PROJECT_NAME up -d --build
}

function stop() {
  echo "🛑 Stopping containers..."
  docker compose --project-name $PROJECT_NAME down
}


function clean() {
  echo "🔥 Removing containers, networks, and volumes..."
  docker compose --project-name $PROJECT_NAME down -v --remove-orphans
}

function logs() {
  echo "📜 Showing logs (Ctrl+C to exit)..."
  docker compose --project-name $PROJECT_NAME logs -f
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart)
    restart
    ;;
  clean)
    clean
    ;;
  logs)
    logs
    ;;
  build)
    build_app
    ;;
  *)
    echo "Usage: $0 {start|stop|restart|clean|logs|build}"
    exit 1
    ;;
esac
