select max(total_laid_off), max(percentage_laid_off)  -- get max 
from layoff_staging2;

select *    -- get percentage is 1
from layoff_staging2
where percentage_laid_off = 1;

select *
from layoff_staging2              -- order by funds
where percentage_laid_off = 1
order by funds_raised_millions desc;

select company, sum(total_laid_off)
from layoff_staging2
group by company 
order by 2 desc ;

select min(date), max(date)
from layoff_staging2;

select industry, sum(total_laid_off)
from layoff_staging2
group by industry
order by 2 desc;

select country, sum(total_laid_off)
from layoff_staging2
group by country
order by 2 desc;

select date, sum(total_laid_off)
from layoff_staging2
group by date
order by 2 desc;

select stage, sum(total_laid_off)
from layoff_staging2
group by stage
order by 2 desc;

select company , avg(percentage_laid_off)
from layoff_staging2
group by company
order by 2 desc;

select substring(`date`,6,2) as `Month`, sum(total_laid_off)        -- get month when the laid off increased
from layoff_staging2
group by `month`
order by 1 ;

select substring(date,1,7) as `month`,sum(total_laid_off) as total_off
from layoff_staging2
where substring(date,1,7) is not null
group by `month`
order by 1 asc;

with Rolling_Total as
(
select substring(`date`,1,7) as `month`,sum(total_laid_off) as total_off
from layoff_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc)

select `month`,total_off, sum(total_off) over(order by `month`) as rolling_total
from Rolling_Total;

select company, year (`date`),sum(total_laid_off)
from layoff_staging2
group by company, YEAR(`date`)
order by 2,3 desc;

with most_laid_off (company,years,total_laid_off) as                          -- multiple cte
(
select company,year(`date`), sum(total_laid_off)
from layoff_staging2
group by company,year(`date`)
),company_year_rank as
(select *,dense_rank() over(partition by years order by total_laid_off desc) as ranking
from most_laid_off
where years is not null
)
select *
from company_year_rank
where ranking<=5;

create temporary table ranking
with most_laid_off (company,years,total_laid_off) as                          -- multiple cte
(
select company,year(`date`), sum(total_laid_off)
from layoff_staging2
group by company,year(`date`)
),company_year_rank as
(select *,dense_rank() over(partition by years order by total_laid_off desc) as ranking
from most_laid_off
where years is not null
)
select *
from company_year_rank
where ranking<=5;


select *
from ranking;



