select npl.parameter,npl.type,npl.level,nbf.estimate
from big_bash._parameter_levels npl
left outer join big_bash._basic_factors nbf
  on (nbf.factor,nbf.level,nbf.type)=(npl.parameter,npl.level,npl.type)
where npl.type='random'
order by parameter,level;
