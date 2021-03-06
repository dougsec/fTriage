#!/bin/bash

# Author:
# Matt May <mcmay.web@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License.  You may obtain a
# copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
# License for the specific language governing permissions and limitations
# under the License.

if [ $# -ne 1 ] || [ ! -f $1 ]; then
    echo "ERROR - usage: $0 ftriage.conf"
    exit 1
else
    source $1
fi

# If volatility OUTDIR does not exist, create it - else, continue 
if [ ! -d "$OUTDIR/carving/volatility" ]; then
    echo "Directory $OUTDIR/carving/volatility/ does not exist - creating it now..."
    mkdir -p $OUTDIR/carving/volatility
else
    echo "Directory $OUTDIR/carving/volatility/ already exists - moving on..."
fi

# If volatility OUTDIR is not empty, inform user and continue
if [ "$(ls -A $OUTDIR'/carving/volatility')" ]; then
    echo "Directory $OUTDIR/carving/volatility/ not empty - moving on..."
    #exit 1
else
    echo "Directory $OUTDIR/carving/volatility/ is empty - let's fill it up!"
fi

# If filescan_audit.txt already exists, then inform user and exit - else, create it
if [ -f "$OUTDIR/carving/volatility/filescan_audit.txt" ]; then
    echo "filescan_audit.txt already exists - exiting now..."
    exit 1
else
    echo "filescan_audit.txt not detected - creating now..."
    vol.py --profile=$PROFILE -f $MEMPATH  filescan | tee $OUTDIR/carving/volatility/filescan_audit.txt
fi

