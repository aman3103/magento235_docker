echo "Installing dependencies."

composer install --no-suggest --no-ansi --no-progress --prefer-dist

command -v docker-sync >/dev/null && continue || { echo "docker-sync command not found."; exit 1; }

echo  "Running Docker Sync, for the first time it will take sometime"
docker-sync start

echo  "Running Docker docker-compose up -d"
docker-compose up -d

echo "Deploying Magento to Docker"
docker-compose run deploy cloud-deploy

echo  "Setting Magento to developer mode"
docker-compose run deploy magento-command deploy:mode:set developer

echo  "Installing Sample Data"

docker-compose run deploy magento-command sampledata:deploy
docker-compose run deploy magento-command setup:upgrade
