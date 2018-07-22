#!/bin/bash

if [ $# -ne 1 ] || [ ! -f $1 ]; then
    echo "ERROR - usage: $0 /path/to/ftriage.conf"
    exit 1
else
    source $1
fi

# If foremost_unallocated OUTDIR does not exist, create it - else, continue 
if [ ! -d "$OUTDIR/carving/foremost_unallocated" ]; then
    echo "$OUTDIR/carving/foremost_unallocated does not exist - creating it now..."
    mkdir -p $OUTDIR/carving/foremost_unallocated
else
    echo "Directory $OUTDIR/carving/foremost_unallocated already exists - moving on..."
fi

# If blkls.unallocated dump does not exist, create it - else, continue
if [ ! -f "$OUTDIR/carving/$HOSTNAME.blkls.unallocated" ]; then
    echo 'Dumping unallocated space...'
    blkls $DISKPATH > $OUTDIR/carving/$HOSTNAME.blkls.unallocated
else
    echo "File $OUTDIR/carving/$HOSTNAME.blkls.unallocated already exists - moving on..."
fi    

# If foremost OUTDIR is not empty, inform user and exit
if [ "$(ls -A $OUTDIR'/carving/foremost_unallocated')" ]; then
    echo "Directory $OUTDIR/carving/foremost_unallocated is not empty, clear it out before filling it up - moving on for now..."
    #exit 1
else
    echo "$OUTDIR/carving/foremost_unallocated is empty - let's fill it up!"
    echo 'Carving files from unallocated space...'

    foremost -q -o $OUTDIR/carving/foremost_unallocated -c $FOREMOST_CONF $OUTDIR/carving/$HOSTNAME.blkls.unallocated
    #foremost -q -o $OUTDIR/carving/foremost $OUTDIR/carving/$HOSTNAME.blkls
    #foremost -q -b 4096 -o $OUTDIR/carving/foremost -c /usr/local/etc/foremost.conf $OUTDIR/carving/$HOSTNAME.blkls
fi

if [ -f "$OUTDIR/carving/foremost_unallocated/audit.txt" ]; then
    echo ""
    egrep '(FILES EXTRACTED|:=)' $OUTDIR/carving/foremost_unallocated/audit.txt
    echo "--------------"
else
    echo "File $OUTDIR/carving/foremost_unallocated/audit.txt does not exist..."
fi

# If tsk_recover OUTDIR does not exist, create it - else, continue 
if [ ! -d "$OUTDIR/carving/tsk_recover" ]; then
    echo "$OUTDIR/carving/tsk_recover does not exist - creating it now..."
    mkdir -p $OUTDIR/carving/tsk_recover
else
    echo ""
    echo "Directory $OUTDIR/carving/tsk_recover/ already exists - moving on..."
fi

# If tsk OUTDIR is not empty, inform user and exit
if [ "$(ls -A $OUTDIR'/carving/tsk_recover')" ]; then
    echo "Directory $OUTDIR/carving/tsk_recover/ is not empty, clear it out before filling it up - moving on for now..."
    #exit 1
else
    echo "$OUTDIR/carving/tsk_recover/ is empty - let's fill it up!"
    echo 'Carving unallocated files using tsk_recover...'
    tsk_recover $DISKPATH $OUTDIR/carving/tsk_recover
fi
