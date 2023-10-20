Select *
From PortfolioPorj..['owid-covid-data$']
where continent is not null
order by 3,4

--Select *
--From PortfolioPorj..vacination$
--order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioPorj..['owid-covid-data$']
where continent is not null
order by 1,2

--Looking at total cases vs total deaths

Select location, date, total_cases,total_deaths
From PortfolioPorj..['owid-covid-data$']
where location like '%states%'
and continent is not null
order by 1,2

--Looking at total cases vs Population

Select location, date, population, total_cases, (total_cases/population)*100 as Percentofpopulationinfected
From PortfolioPorj..['owid-covid-data$']
where location like '%india%'
order by 1,2

--looking at countries with higest infection rate compared to population

Select location, population, Max(total_cases) as Highestinfectioncount, MAX((total_cases/population))*100 as Percentofpopulationinfected
From PortfolioPorj..['owid-covid-data$']
--where location like '%india%'
Group by location, population
order by Percentofpopulationinfected desc

--Countries with highest death count per population

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioPorj..['owid-covid-data$']
--where location like '%india%'
where continent is not null
Group by location, population
order by TotalDeathCount desc

---continent
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioPorj..['owid-covid-data$']
--where location like '%india%'
where continent is not null
Group by continent, population
order by TotalDeathCount desc

--- continent with highest death count

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioPorj..['owid-covid-data$']
--where location like '%india%'
where continent is not null
Group by location, population
order by TotalDeathCount desc

-- Global numbers

Select SUM(new_cases), SUM(cast(new_deaths as int)), SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioPorj..['owid-covid-data$']
---where location like '%india%'
where continent is not null
--Group By date
order by 1,2

 --Joining two tables
 Select *
 From PortfolioPorj..['owid-covid-data$'] dea
 Join PortfolioPorj..vacination$ vac
 On dea.date = vac.date

 --total number of people vacinated in the world

 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(CONVERT(int,vac.new_vaccinations )) OVER (Partition by dea.location order by dea.location,dea.Date) as RollingPeopleVaccinated
 from PortfolioPorj..['owid-covid-data$'] dea
 Join PortfolioPorj..vacination$ vac
 On dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 2,3

 --Use CTE
  with PopvsVac (Continent,location,Date,Population, New_Vaccinations, RollingPopleVaccinated)
  as
  (
   Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(CONVERT(int,vac.new_vaccinations )) OVER (Partition by dea.location order by dea.location,
 dea.Date) as RollingPeopleVaccinated
 from PortfolioPorj..['owid-covid-data$'] dea
 Join PortfolioPorj..vacination$ vac
 On dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 --order by 2,3
 )
 select * ,(RollingPopleVaccinated/Population)*100
 From PopvsVac

 --Creating view to store data for visualizations

 Create View PercentPopulationVaccinated as
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,
 dea.date) as RollingPeopleVaccinated
  from PortfolioPorj..['owid-covid-data$'] dea
 Join PortfolioPorj..vacination$ vac
 On dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 --order by 2,3

 --Tableau query
 --1
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioPorj..['owid-covid-data$']
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

--2
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioPorj..['owid-covid-data$']
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International' , 'High income' ,'Upper middle income', 'Lower middle income' , 'low income')
Group by location
order by TotalDeathCount desc

--3
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioPorj..['owid-covid-data$']
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

--4
Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioPorj..['owid-covid-data$']
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc