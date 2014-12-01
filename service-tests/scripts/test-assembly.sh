#! /bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
MODULE_SCRIPTS=DIR/assembly

for t in $(MODULE_SCRIPTS) ; do
    cp $t .
    if [ $? -ne 0 ] ; then
        exit 1 ;
    fi
    ./$t
done

