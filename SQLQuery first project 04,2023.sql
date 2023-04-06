select *
from Portifolio_project..coviddeaths
where continent is not null
order by 3,4


--lets select t he data we are going to start using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM portifolio_project..covidDeaths
where continent is not null 
order by 1,2



--TOTALCASES vs TOTALDEATHS
--this will show the lielyhood of dying when you contract covid in the country 

SELECT location, date, total_cases, new_cases, total_deaths,(total_deaths/total_cases)*100 as Deathparcentage
FROM portifolio_project..covidDeaths
where location = 'brazil'
and continent is not null 
order by 1,2

Select Location, total_cases, total_deaths, ((cast(total_deaths as float)/(cast(total_cases as float))
))*100 as deathpercentage

From Portifolio_Project..CovidDeaths
Where location like '%states%'
and continent is not null 
order by 1,2


--TOTAL CASES vs POPULATION
--will indcate the percentage of infected with covid 

Select Location, date, population, total_cases, ((cast(total_cases as float)/(cast(population as float))
))*100 as populationpercentageinfected

From Portifolio_Project..CovidDeaths
--Where location like '%states%'and continent is not null 
order by 1,2

--countries with highest infection rate compared to their population

SELECT location, population,  max(total_cases) as Highestinfectioncount, max(cast(total_cases as float)/cast(population as float))*100 as percentpopinfected
FROM portifolio_project..covidDeaths

group by location, population
order by 1,2

--countries with the highest death count per population

SELECT location, max(total_deaths) as TotalDeathcount
FROM portifolio_project..covidDeaths
 group by location 
order by TotalDeathcount desc

--BREAKING THINGS DOWN BY CONTINENT 
--showing continents with the highest death count per population 

select continent, MAX(total_deaths) as Totaldeathcount 
from portifolio_project..coviddeaths
where continent is not null
group by continent
order by Totaldeathcount desc

--global numbers 

select  SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, (cast(SUM(new_deaths) as float)/cast(SUM(New_cases) as float))*100 as deathpercetage
From portifolio_project..coviddeaths
where continent is not null

order by 1,2

--Total population Vs vaccinations
--this shows the percentage of pupulation that has atleast one covid vaccine

SELECT dea.continent, dea.location, dea.date, dea.population, vac.total_vaccinations, vac.new_vaccinations, (SUM(vac.new_vaccinations) OVER (partition by dea.location order by dea.location, dea.date)) as RollingPeoplevaccinated

FROM portifolio_project..coviddeaths dea
JOIN portifolio_project..covidvaccinations vac
		ON dea.location = vac.location
		AND dea.date = vac.date
		where dea.continent is not null
ORDER BY 2,3;


--USING THE CTE TO PERFORM CACULATIONS ON PARTITON BY IN PREVIOUS QUERY

WITH PopVsVac (continent, total_vacccinations, location, date, population, new_vaccinations, RollingPeoplevaccinated)
AS
(SELECT dea.continent, dea.location, dea.date, dea.population, vac.total_vaccinations, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeoplevaccinated
FROM portifolio_project..coviddeaths dea
JOIN portifolio_project..covidvaccinations vac
		ON dea.location = vac.location
		AND dea.date = vac.date
		where dea.continent is not null

)
SELECT *, ((cast(Rollingpeoplevaccinated as float))/(NULLIF (population, 0)))*100 AS percentvaacperpopulation
FROM PopvsVac;

--using temp table to perform calculation on partition By in the previous query 

DROP table if exists #PercentPopulationVaccinated

create table #PercentPopulationVaccinated
(continent nvarchar(255),
loaction nvarchar(255),
date datetime,
population numeric,
New_vaccinations numeric,
RollingpeopleVaccinated numeric,

)

insert into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeoplevaccinated
FROM portifolio_project..coviddeaths dea
JOIN portifolio_project..covidvaccinations vac
		ON dea.location = vac.location
		AND dea.date = vac.date
		where dea.continent is not null

SELECT *, ((cast(Rollingpeoplevaccinated as float))/(NULLIF (population, 0)))*100 AS percentvaacperpopulation
FROM #PercentPopulationVaccinated


--creating a view to store data for later visualiation


CREATE VIEW 