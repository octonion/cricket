begin;

drop table if exists big_bash.results;

create table big_bash.results (
	game_id		      integer,
	year		      integer,
	game_date	      date,
	team_name	      text,
	opponent_name	      text,
	field		      text,
	team_score	      float,
	opponent_score	      float

);

insert into big_bash.results
(game_id,
 year,
 game_date,
 team_name,
 opponent_name,
 field,
 team_score,
 opponent_score)
(
select
game_id,
season as year,
date,
home_team,
away_team,
'offense_home',
home_run_rate,
away_run_rate

from big_bash.games

where
    season between 2020 and 2021
    
and home_run_rate is not null
and away_run_rate is not null
);

insert into big_bash.results
(game_id,
 year,
 game_date,
 team_name,
 opponent_name,
 field,
 team_score,
 opponent_score)
(
select
game_id,
season as year,
date,
away_team,
home_team,
'defense_home',
away_run_rate,
home_run_rate

from big_bash.games

where
    season between 2020 and 2021

and home_run_rate is not null
and away_run_rate is not null
);

commit;
