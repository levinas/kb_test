#! /bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cp $DIR/annotate_plant_transcripts/* .

njs-run-genome-annotation annotate_genome Athaliana.TAIR10.json
