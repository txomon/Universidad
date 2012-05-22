#!/bin/sh

TBDIR="$HOME/Txobox"
LOGFILE="/var/log/txobox"

exec 1>&$LOGFILE/txobox.out
exec 2>&$LOGFILE/txobox.err


echo "Starting Txobox!"
PSEF=$(ps -eF | grep script.sh | wc -l)

if [ 1 -lt $PSEF ]; then
    exit;
fi
exit;
if [ ! -d $TBDIR ]; then
    echo "$TBDIR doesn't exist" > $LOGFILE
    mkdir -p $TBDIR
    cd $TBDIR
    git init
    git config user.email "me@localhost"
    git config user.name "$USER"
    git annex init "Txobox"
    git remote add prueba javier@localhost:Txobox/
fi

cd $TBDIR

git annex add *
git annex sync
git annex copy --to prueba *
git annex unlock *