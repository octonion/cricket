#!/bin/bash

psql cricket -c "drop table if exists super_smash.results;"

psql cricket -f sos/standardized_results.sql

psql cricket -c "vacuum full verbose analyze super_smash.results;"

psql cricket -c "drop table if exists super_smash._basic_factors;"
psql cricket -c "drop table if exists super_smash._parameter_levels;"

R --vanilla -f sos/lmer.R

psql cricket -c "vacuum full verbose analyze super_smash._parameter_levels;"
psql cricket -c "vacuum full verbose analyze super_smash._basic_factors;"

psql cricket -f sos/normalize_factors.sql
psql cricket -c "vacuum full verbose analyze super_smash._factors;"

psql cricket -f sos/schedule_factors.sql
psql cricket -c "vacuum full verbose analyze super_smash._schedule_factors;"

psql cricket -f sos/current_ranking.sql > sos/current_ranking.txt
cp /tmp/current_ranking.csv sos/current_ranking.csv

psql cricket -f sos/predictions.sql > sos/predictions.txt
cp /tmp/predictions.csv sos/predictions.csv
