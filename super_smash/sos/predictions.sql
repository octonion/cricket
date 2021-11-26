begin;

select

g.date::date as date,
sf1.team_id as home,
sf2.team_id as away,
(exp(i.estimate)*sf1.offensive*o.exp_factor*sf2.defensive)::numeric(5,1) as e_home,
(exp(i.estimate)*sf2.offensive*d.exp_factor*sf1.defensive)::numeric(5,1) as e_away,
((exp(i.estimate)*sf1.offensive*o.exp_factor*sf2.defensive)-
(exp(i.estimate)*sf2.offensive*d.exp_factor*sf1.defensive))::numeric(5,1) as e_d,
(20*(((exp(i.estimate)*sf1.offensive*o.exp_factor*sf2.defensive)-
(exp(i.estimate)*sf2.offensive*d.exp_factor*sf1.defensive))))::numeric(5,2) as e_rd

from super_smash.games g
join super_smash._schedule_factors sf1
  on (sf1.team_id)=(g.home_team)
join super_smash._schedule_factors sf2
  on (sf2.team_id)=(g.away_team)

join super_smash._factors o
  on (o.parameter,o.level)=('field','offense_home')
join super_smash._factors d
  on (d.parameter,d.level)=('field','defense_home')

join super_smash._basic_factors i
  on (i.factor)=('(Intercept)')

where
    g.date::date >= CURRENT_DATE
order by date asc, home asc;

copy
(
select

g.date::date as date,
sf1.team_id as home,
sf2.team_id as away,
(exp(i.estimate)*sf1.offensive*o.exp_factor*sf2.defensive)::numeric(5,1) as e_home,
(exp(i.estimate)*sf2.offensive*d.exp_factor*sf1.defensive)::numeric(5,1) as e_away,
((exp(i.estimate)*sf1.offensive*o.exp_factor*sf2.defensive)-
(exp(i.estimate)*sf2.offensive*d.exp_factor*sf1.defensive))::numeric(5,2) as e_d

from super_smash.games g
join super_smash._schedule_factors sf1
  on (sf1.team_id)=(g.home_team)
join super_smash._schedule_factors sf2
  on (sf2.team_id)=(g.away_team)

join super_smash._factors o
  on (o.parameter,o.level)=('field','offense_home')
join super_smash._factors d
  on (d.parameter,d.level)=('field','defense_home')

join super_smash._basic_factors i
  on (i.factor)=('(Intercept)')

where
    g.date::date >= CURRENT_DATE
order by date asc, home asc
) to '/tmp/predictions.csv' csv header;

commit;
