#! /bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cp $DIR/KBaseFBAModeling/* .

t/test_pipeline.t
