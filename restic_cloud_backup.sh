#!/bin/bash

# in /etc/enviroment
#B2_ACCOUNT_ID=<your keyID here>
#B2_ACCOUNT_KEY=<your key here>
#RESTIC_PASSWORD=<your restic repository password here>

command1="restic -r b2:mybucket-desktop-backups:alfred/ backup /home/eric/Documents/ 2>&1"
output1=$(eval "${command1}")
result1=$?

command2="restic -r b2:mybucket-desktop-backups:alfred/ backup /home/eric/repos/ 2>&1"
output2=$(eval "${command2}")
result2=$?

message="
----------Dino-desktop Backup Report----------
$(date)
"

if [[ $result1 != 0 ]] || [[ $result2 != 0 ]]; then
    message="${message}
----------------------------------------
BACKUP FAILED!! See output below.
----------------------------------------
"
    subject="Backup FAILED---$(date)"
else
    message="${message}
----------------------------------------
Backup SUCCEEDED.
----------------------------------------
"
    subject="Backup successful---$(date)"
fi

message="${message}
\$ ${command1}
${output1}
\$ ${command2}
${output2}
----------------------------------------
Snapshot history:
----------------------------------------
$(restic -r b2:mybucket-desktop-backups:alfred/ snapshots)
"

echo "Subject: ${subject}"
echo "Message: ${message}"

echo "${message}" | mailx --subject "${subject}" username@gmail.com