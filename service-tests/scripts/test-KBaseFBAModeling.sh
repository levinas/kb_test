#! /bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cp -r $DIR/KBaseFBAModeling/* .

test_pipeline.t
