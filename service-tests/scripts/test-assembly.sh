#! /bin/bash

DIR=/kb/dev_container/modules

cp $DIR/assembly/test/arast.t .

./arast.t |tee arast.t.tap
