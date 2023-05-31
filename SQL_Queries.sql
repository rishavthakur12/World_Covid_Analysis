show tables;
select * from covid_death;
select location, date, total_cases, new_cases, total_deaths, population from covid_death;
-- total cases vs total death, shows the probability of dying if affected by covid
 select continent, location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage from covid_death;
 select location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage from covid_death where location like '%india';
 
 -- total_cases vs population,  shows population affeceted
 select location, date, total_cases, new_cases,population, (total_cases/population)*100 as affected_population from covid_death where location like '%india';
 
 -- shows highest infection rate for countries compared to respective population
  select location,population,Max(total_cases) as hidhest_infection_count, max(total_cases/population)*100 
  as percent_affected_population from covid_death group by location  order by percent_affected_population desc ;
  
-- countries wth highest death count to respective population
select location, MAX(cast(Total_deaths as decimal)) as total_death_count from covid_death where continent is not NULL 
group by Location order by total_death_count  desc;

-- shows the death percentage location wise 
-- select location, population, max(total_deaths) as highest_deaths, max(total_deaths/population)*100 
-- as percent_deaths from covid_death group by location order by percent_deaths desc;

-- lets break things down by continent
select continent, MAX(cast(Total_deaths as decimal)) as total_death_count from covid_death where continent is not null
group by continent order by total_death_count  desc;


-- Global numbers
 select  date, sum(new_cases) as total_Cases, sum(cast(new_deaths as decimal)) as total_Deaths, (sum(cast(new_deaths as decimal))/sum(new_cases))*100 as death_percentage 
 from covid_death
 where continent is not null group by date;


 select  sum(new_cases) as total_Cases, sum(cast(new_deaths as decimal)) as total_Deaths, (sum(cast(new_deaths as decimal))/sum(new_cases))*100 as death_percentage 
 from covid_death
 where continent is not null; 


-- total population  vs vaccinations
select * 
from covid_death dea
join covid_vaccinations vac
on dea.location = vac.location
and dea.date = vac.date; 

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as decimal)) over (partition by dea.location order by dea.location, dea.date) as people_vaccinated
from covid_death dea
join covid_vaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3;


-- USE CTE
with popvsvac (Continent, Location, Date, Population,  new_vaccinations, people_vaccinated) as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as decimal)) over (partition by dea.location order by dea.location, dea.date) as people_vaccinated
from covid_death dea
join covid_vaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
select *, (people_vaccinated/population)*100 from popvsvac; 

-- TEMP TABLE  (this is just another way of CTE)**************************************
Drop table if exists Percentpopulationvaccinated;
Create table Percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
Population numeric,
New_vaccinations numeric,
Rollingpeoplevaccinated numeric
);

insert into Percentpopulationvaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as decimal)) over (partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
from covid_death dea
join covid_vaccinations vac
on dea.location = vac.location
and dea.date = vac.date;
-- where dea.continent is not null;


select *, (Rollingpeoplevaccinated/population)*100 from Percentpopulationvaccinated ; 
-- **************************************



-- QUERIES FOR TABLEAU:
 
select  sum(new_cases) as total_Cases, sum(cast(new_deaths as decimal)) as total_Deaths, (sum(cast(new_deaths as decimal))/sum(new_cases))*100 as death_percentage 
from covid_death
where continent is not null; 


Select continent, SUM(cast(new_deaths as decimal)) as TotalDeathCount
From covid_death 
-- Where location like '%states%'
-- Where continent is null 
-- and location not in ('World', 'European Union', 'International')
Group by continent
order by TotalDeathCount desc;


Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From  covid_death
-- --Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc;


Select continent, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From covid_death
-- --Where location like '%states%'
Group by continent, Population
order by PercentPopulationInfected desc;


select Continent, sum(total_tests) from covid_vaccinations group by Continent;



-- USE CTE
with popvsvac (Continent, Location, Date, Population,  new_vaccinations, people_vaccinated) as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as decimal)) over (partition by dea.location order by dea.location, dea.date) as people_vaccinated
from covid_death dea
join covid_vaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
select *, (people_vaccinated/population)*100 from popvsvac; 

describe covid_vaccinations;
select date, continent , new_tests, total_tests, people_vaccinated, new_vaccinations, total_vaccinations from covid_vaccinations order by date;












 


