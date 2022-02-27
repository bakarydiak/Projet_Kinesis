Initialisé le projet terraform pour créer l'infrastructure aws 
terraform init
terraform plan
terraform apply
le code terraform génère, un kinesis data stream, kinesis analytics, kinesis firehose, bucket s3
utilisé le meteo_server pour inserer des données dans le datastream et remplir le firehose.

L'objectif est de démontrer que la pipeline de données créer fonctionne,
on utilise le projet java pour alimenter la pipeline avec les données d'une api 
la pipeline reçoit des données météorologique.

les données siont récupéré depuis l'api suivante https://openweathermap.org/api plus précisement "Current Weather Data"
pour récupéré les données en un lieu spécifiqueet les transfere dans le data streampuis le diffusé dans le reste del'infrastructure
