#!/bin/bash
BUCKET="capstone-p19-log-backups-590507089733-ap-south-1"
PROJECT_DIR="/home/clouduser/capstone-projects/project19-scheduled-s3-backup"
DESTINATION="s3://${BUCKET}/project19-scheduled-backups/AZLTT0222435e27/"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
if /usr/local/bin/aws s3 cp \
"${PROJECT_DIR}/logs/application.log" \
"${DESTINATION}application-${TIMESTAMP}.log"
then
   echo "Backup uploaded successfully."
else
   echo "Backup upload failed."
   exit 1
fi
