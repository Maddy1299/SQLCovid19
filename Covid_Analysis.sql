select * from CovidP1..CovidVaccinations
where continent is not null
order by 3,4

select * from CovidP1..CovidDeaths
where continent is not null
order by 3,4

Select location,date,population,total_cases,new_cases,total_deaths
From CovidP1..CovidDeaths
where continent is not null
order by 1,2

--Total case for each country today...

Select location,total_cases,total_deaths
from CovidP1..CovidDeaths
where date='2021-05-31 00:00:00.000' and continent is not null
order by 1

--Countries with no deaths

Select location,total_cases,total_deaths
from CovidP1..CovidDeaths
where date='2021-05-31 00:00:00.000' and total_deaths IS NULL and  continent is not null
order by 1

select location,date,total_deaths 
from CovidP1..CovidDeaths where total_deaths IS NULL and continent is not null
order by location


--Select max(dates) where totals deaths is null for each country

select location,MAX(date) as 'First Death Occurance'
from CovidP1..CovidDeaths where total_deaths IS NULL and continent is not null
group by location
order by location

--First day where Cases occured in each country
select location,MIN(date) as 'First Case Occurance'
from CovidP1..CovidDeaths
where continent is not null
group by location
order by location

--No of days between first occurnace and first Death
select location,MAX(date) as 'First Death Occurance',MIN(date) as 'First Case Occurance'
from CovidP1..CovidDeaths where total_deaths IS NULL and continent is not null
group by location
order by location



--Countrywise Death Percentage 
Select location,total_cases,total_deaths,(total_deaths/total_cases)*100 as 'Death Percentage'
from CovidP1..CovidDeaths
where date='2021-05-31 00:00:00.000'
order by 1

--Daily Death Percentage
Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as 'Death Percentage'
from CovidP1..CovidDeaths
order by 1,2

--growth rate
select location,total_cases
from CovidP1..CovidDeaths
where date='2021-05-31 00:00:00.000'
order by 1

select location,total_cases 
from CovidP1..CovidDeaths
where date='2021-05-30 00:00:00.000'
order by 1


select location,total_cases as total_Case_today
from CovidP1..CovidDeaths
where date = (select MAX(date) from CovidP1..CovidDeaths)
order by 1

select MAX(date)-1
from CovidP1..CovidDeaths

select location,total_cases as total_Case_today,date
from CovidP1..CovidDeaths
where date = (select MAX(date)-1 from CovidP1..CovidDeaths)
order by 1

select A.location,A.total_cases as total_Case_today,B.total_cases as total_Cases_yesterday,B.population,((A.total_cases-B.total_cases)/B.total_cases)*100 as Growth_Rate
from CovidP1..CovidDeaths A,CovidP1..CovidDeaths B
where B.date = (select MAX(date)-1 from CovidP1..CovidDeaths) and 
      A.date = (select MAX(date) from CovidP1..CovidDeaths) and 
	  A.location = B.location
order by Growth_Rate desc

select 1380004385*0.03,max(total_cases),(1380004385*0.03)-max(total_cases)
from CovidP1..CovidDeaths
where location='india'

select location,population,avg(new_cases/total_cases)*100 as growth_rate
from CovidP1..CovidDeaths
--where location='india'
where continent is not null
group by location,population
order by growth_rate desc,location,population desc

--select location,new_cases,total_cases
--from CovidP1..CovidDeaths
--where location = 'Anguilla'



--pecentage of population affected -Daily
Select location,date,total_cases,population,(total_cases/population)*100 as 'Affected Percentage'
from CovidP1..CovidDeaths
order by 1,2

--pecentage of population affected -Countrywise
Select location,total_cases,population,(total_cases/population)*100 as 'Affected Percentage'
from CovidP1..CovidDeaths
where date='2021-05-30 00:00:00.000' 
order by 1

--select * 
--from CovidP1..CovidDeaths
--where location='international'


--Countries not affected by Covid
select location
from CovidP1..CovidDeaths
where total_cases IS NULL and date='2021-05-30 00:00:00.000'
order by 1

--Highest infetion rates
select location,population,MAX(Total_Cases) as 'People Infected', MAX((total_cases/population)*100) as 'Highest Infection Rate'
from CovidP1..CovidDeaths
--where continent = 'Oceania'
where continent is not null
group by location,population
order by [Highest Infection Rate]desc

--select total_cases,date
--from CovidP1..CovidDeaths
--where location='Gibraltar'

select distinct continent
from CovidP1..CovidDeaths


With VP (continent, location,Date,population,New_vaccinations,Total_People_Vaccinated)
as(
select cv.continent,cv.location,cv.date,cd.population,cv.new_vaccinations,
SUM(convert(int,cv.new_vaccinations)) OVER (Partition by cv.location order by cv.location,cv.date) as Total_People_Vaccinated
from CovidP1..CovidDeaths cd
join CovidP1..CovidVaccinations cv
on cd.location = cv.location
and cv.date = cd.date
where cv.continent is not null
)
select * , (Total_People_Vaccinated/population)*100 as Vaccinated_percentage
from VP

select 28129+14886
--43015

Create View VP2 as
select cv.continent,cv.location,cv.date,cd.population,cv.new_vaccinations,
SUM(convert(int,cv.new_vaccinations)) OVER (Partition by cv.location order by cv.location,cv.date) as Total_People_Vaccinated
from CovidP1..CovidDeaths cd
join CovidP1..CovidVaccinations cv
on cd.location = cv.location
and cv.date = cd.date
where cv.continent is not null

select * from VP2

Create table #TVP(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Total_ppl_vaccinated numeric)

insert into #TVP
select cv.continent,cv.location,cv.date,cd.population,cv.new_vaccinations,
SUM(convert(int,cv.new_vaccinations)) OVER (Partition by cv.location order by cv.location,cv.date) as Total_People_Vaccinated
from CovidP1..CovidDeaths cd
join CovidP1..CovidVaccinations cv
on cd.location = cv.location
and cv.date = cd.date
where cv.continent is not null

select * from #TVP