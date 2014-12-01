#! /bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
MODULE_SCRIPTS=$DIR/assembly

cp $DIR/assembly/arast.t .

./arast.t

