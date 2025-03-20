#!/bin/bash

set -e
set -o pipefail

CONCERTO_DIR="/opt/concerto"
GIT_REPO="https://github.com/campsych/concerto-platform.git"

install_dependencies() {
    printf "Menginstal dependensi...\n"
    sudo apt update && sudo apt install -y \
        git \
        docker.io \
        docker-compose \
        curl \
        unzip
}

clone_concerto_repo() {
    if [[ -d "$CONCERTO_DIR" ]]; then
        printf "Direktori Concerto sudah ada, memperbarui repository...\n"
        cd "$CONCERTO_DIR" && git pull
    else
        printf "Mengkloning repository Concerto...\n"
        sudo git clone "$GIT_REPO" "$CONCERTO_DIR"
        sudo chown -R "$USER:$USER" "$CONCERTO_DIR"
    fi
}

setup_env_file() {
    local env_file="$CONCERTO_DIR/.env"
    if [[ ! -f "$env_file" ]]; then
        printf "Membuat file konfigurasi .env...\n"
        cat <<EOF > "$env_file"
CONCERTO_DB_HOST=db
CONCERTO_DB_PORT=3306
CONCERTO_DB_NAME=concerto
CONCERTO_DB_USER=concerto
CONCERTO_DB_PASS=concerto_password
CONCERTO_ADMIN_EMAIL=admin@example.com
CONCERTO_ADMIN_PASS=admin
EOF
    fi
}

run_concerto() {
    printf "Menjalankan Concerto dengan Docker...\n"
    cd "$CONCERTO_DIR"
    sudo docker-compose up -d
}

main() {
    install_dependencies
    clone_concerto_repo
    setup_env_file
    run_concerto

    printf "Instalasi Concerto selesai!\n"
}

main
