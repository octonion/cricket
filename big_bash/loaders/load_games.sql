begin;

drop table if exists big_bash.games;

set datestyle to 'SQL, DMY';

create table big_bash.games (
	season			   integer,
	date			   timestamp,
	home_team          text,
	away_team          text,
	home_runs          integer,
	home_wickets       integer,
	home_overs         text,
	away_runs          integer,
	away_wickets       integer,
	away_overs         text,
	home_run_rate      float,
	away_run_rate      float,
	winning_team       text,
	winning_margin     text
);

copy big_bash.games from '/tmp/games.csv' with delimiter as ',' csv;

alter table big_bash.games add column game_id serial;

commit;
