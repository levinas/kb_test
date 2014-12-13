#! /bin/bash

DIR=/kb/dev_container/modules

cp $DIR/assembly/arast.t .

./arast.t |tee arast.t.tap
