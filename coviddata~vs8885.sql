--select *
--from Portfolioproject.dbo.CovidDeaths$

--select*
--from Portfolioproject.dbo.CovidVaccinations$
--order by 3,4

--Select *
--From Portfolioproject..CovidDeaths$
--Where continent is not null 
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths,population
From Portfolioproject..CovidDeaths$
order by 1,2




Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
From Portfolioproject..CovidDeaths$
where location like '%kenya%'
order by 1,2


Select Location, date, total_cases, population, (total_cases/population)*100 as percentagepopulationinfected
From Portfolioproject..CovidDeaths$
where location like '%states%'
order by 1,2


Select Location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as percentagepopulationinfected
From Portfolioproject..CovidDeaths$
--where location like '%states%'
group by location,population
order by percentagepopulationinfected desc


Select Location, max(cast(Total_deaths as int)) as totaldeathCount
From Portfolioproject..CovidDeaths$
--where location like '%states%'
where continent is not null
group by location
order by totaldeathCount desc



Select continent, max(cast(Total_deaths as int)) as totaldeathCount
From Portfolioproject..CovidDeaths$
--where location like '%states%'
where continent is not null
group by continent
order by totaldeathCount desc



Select sum(new_cases)as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/ sum(new_cases)*100 as DeathPercentage
From Portfolioproject..CovidDeaths$
---where location like '%kenya%'
where continent is not null
--group by date
order by 1,2

--cte


with popvsvac (continent,location,date,population,incrementofvacs,new_vaccinations)
as 
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum( cast(vac.new_vaccinations as int))  over (partition by dea.location) as incrementofvacs
from Portfolioproject..CovidDeaths$ as dea
join Portfolioproject..CovidVaccinations$ as vac
     on dea.location = vac.location
	 and dea.date = vac.date
	where dea.continent is not null
--order by 2,3
)

select*,(incrementofvacs/population)*100
from popvsvac


-- temp table


drop table if exists #percentagepopulationvaccinations
create table #percentagepopulationvaccinations
(continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
incrementofvacs numeric
)

insert into #percentagepopulationvaccinations

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum( cast(vac.new_vaccinations as int))  over (partition by dea.location) as incrementofvacs
from Portfolioproject..CovidDeaths$ as dea
join Portfolioproject..CovidVaccinations$ as vac
     on dea.location = vac.location
	 and dea.date = vac.date
	where dea.continent is not null
--order by 2,3


select*,(incrementofvacs/population)*100
from #percentagepopulationvaccinations


--view

create view percentagepopulationvaccinations as 
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum( cast(vac.new_vaccinations as int))  over (partition by dea.location) as incrementofvacs
from Portfolioproject..CovidDeaths$ as dea
join Portfolioproject..CovidVaccinations$ as vac
     on dea.location = vac.location
	 and dea.date = vac.date
	where dea.continent is not null
--order by 2,3