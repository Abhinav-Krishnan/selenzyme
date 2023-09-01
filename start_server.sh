#!/usr/bin/env bash
DIR=$(cd "$(dirname "$0")"; pwd)

docker stop selenzyme-updated #$(docker ps -a -q)
docker rm selenzyme-updated #$(docker ps -a -q)
docker rmi selenzyme-updated #$(docker images -q)

sudo rm -rf selenzyme

# # Base container, build only once before installing selenzyme
docker build -t sbc/selenzybase-updated -f Dockerfile.base .
docker build -t selenzyme-updated .

# Clone updated Selenzyme repo
mkdir selenzyme
cd selenzyme
git clone https://github.com/Abhinav-Krishnan/selenzy.git selenzyPro
cd selenzyPro
DATASET='s886f5hbgk'
VERSION='1'
wget "https://prod-dcd-datasets-cache-zipfiles.s3.eu-west-1.amazonaws.com/${DATASET}-${VERSION}.zip" -O data.zip
echo -e "import zipfile\nzipfile.ZipFile('data.zip','r').extractall('.')" | python
tar -xzvf data.tar.gz
rm data.tar.gz
rm data.zip
mkdir -p log
mkdir -p uploads
cd ..
cd ..

docker run --name nginx-proxy-updated -d -p 80:80 -p 88:7700 -v /var/run/docker.sock:/tmp/docker.sock:ro jwilder/nginx-proxy
docker run --name selenzyme-updated -d -p 5000:5000 -e LD_LIBRARY_PATH='/opt/conda/bin/../lib' -e VIRTUAL_HOST=selenzyme.synbiochem.co.uk -v "$DIR/selenzyme:/selenzyme" selenzyme
