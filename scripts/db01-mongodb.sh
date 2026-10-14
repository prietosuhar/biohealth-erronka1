#!/bin/bash
# BioHealth – db01 (LAN, 192.168.10.3): MongoDB Community instalatu eta egiaztatu
#  - CPUak AVX badu  → MongoDB 7.0, biltegi ofiziala (apt), systemd zerbitzua `mongod`
#  - CPUak AVX ez badu (IsardVDIko CPU birtual batzuk) → MongoDB 5.0+ ez dabil ("Illegal instruction"),
#    beraz MongoDB 4.4 kontenedore batean (Docker), 127.0.0.1:27017-n
#  - bindIp 127.0.0.1: oraingoz ez dago MongoDB erabiltzen duen bezerorik sarean (WordPress eta GLPI SQL dira)
set -e
CODENAME=$(lsb_release -sc)
echo "Ubuntu: $(lsb_release -sd) ($CODENAME)"

if grep -qw avx /proc/cpuinfo; then
  echo "CPU: AVX bai → MongoDB 7.0 (apt)"
  sudo apt-get install -y -qq gnupg curl
  curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
    sudo gpg --dearmor -o /usr/share/keyrings/mongodb-server-7.0.gpg --yes
  echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu $CODENAME/mongodb-org/7.0 multiverse" | \
    sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
  sudo apt-get update -qq
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq mongodb-org
  sudo systemctl enable --now mongod
  sleep 5
  echo "=== Bertsioa ===";  mongod --version | head -1
  echo "=== Zerbitzua ==="; systemctl is-active mongod; systemctl is-enabled mongod
  echo "=== Konfigurazioa (/etc/mongod.conf) ==="; grep -A3 -E '^(net|storage|systemLog):' /etc/mongod.conf
  SHELL_CMD="mongosh --quiet"
else
  echo "CPU: AVX EZ → MongoDB 4.4 Docker kontenedorean"
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq docker.io
  sudo systemctl enable --now docker
  sudo docker volume create mongo_data
  sudo docker rm -f mongodb 2>/dev/null || true
  sudo docker run -d --name mongodb --restart unless-stopped \
    -p 127.0.0.1:27017:27017 -v mongo_data:/data/db mongo:4.4
  sleep 8
  echo "=== Bertsioa ===";  sudo docker exec mongodb mongod --version | head -1
  echo "=== Kontenedorea ==="; sudo docker ps --filter name=mongodb
  SHELL_CMD="sudo docker exec -i mongodb mongo --quiet"
fi

echo "=== Entzuten (27017) ==="; sudo ss -tlnp | grep 27017
echo "=== Proba: ping + dokumentu bat biohealth_nosql.logs_sistema-n ==="
$SHELL_CMD <<'JS'
db.adminCommand({ ping: 1 })
use biohealth_nosql
db.logs_sistema.insertOne({ host: "db01", nivel: "info", msg: "MongoDB instalatuta", fecha: new Date() })
printjson(db.logs_sistema.find({}, { _id: 0 }).toArray())
JS
