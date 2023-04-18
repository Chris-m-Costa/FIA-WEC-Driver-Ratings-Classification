use wec_proj;


select * from wec_data;

where crossing_finish_line_in_pit = 'B'
order by MyUnknownColumn;

select * from wec_data
where engine = 'Ferrari'
order by MyUnknownColumn;

select * from wec_data
where s1_improvement > 0
or s2_improvement > 0
or s3_improvement > 0
order by MyUnknownColumn;

select distinct lap_improvement, s1_improvement  from wec_data;

select distinct crossing_finish_line_in_pit from wec_data;
