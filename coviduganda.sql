select *
from Sheet1$


select *
from dbo.Sheet1$

create view deathscases as
-----select data we are going to be using
select location,date,new_cases,total_cases,total_deaths,[ population ]
from ['FIRST DATA SET$']

create view casesvsdeaths as 
-----looking at total cases vs total deaths as percentage 
----shows the likelihood of dying from covid globally
select location,date,total_cases,total_deaths,
(convert(float,total_deaths)/convert(float,total_cases))*100 as percentagedeaths 
from ['FIRST DATA SET$']
--order by 1,2

create view Ugandacasesvsdateaths as 
-----looking at total cases vs total deaths in uganda
---shows likelihood of dying from contracting covid in uganda
select location,date,total_cases,total_deaths,
(convert(float,total_deaths)/convert(float,total_cases))*100 as percentagedeaths
from ['FIRST DATA SET$']
where location like '%uganda%'
--order by 1,2 

create view usacasesvsdeaths as 
----looking at total cases vs total deaths in united states
--likelihhod of dying if you contract covid in the united states
select location,date,total_cases,total_deaths,
(convert(float,total_deaths)/convert(float,total_cases))*100 as percentagedeaths
from ['FIRST DATA SET$']
where location like '%states%'
--order by 1,2

create view totalcasesvstotalpopulation as 
---looking at total cases vs total population
---shows what percentage of population has covid
select location,date,[ population ],total_cases,total_deaths,
(total_cases/[ population ])*100 as percentageppulation
from ['FIRST DATA SET$']
--order by 1,2 




create view totalcasesvstotalpopulationuganda as 
-----looking at total cases vs total population in uganda
---shows what percentage of population of ugandans contracted covid
select location,date,[ population ],total_cases,total_deaths,
(total_cases/[ population ])*100 as sickugandans
from ['FIRST DATA SET$']
where location like '%uganda%'
--order by 1,2
create view totalcasesvstotalpopulationstates as 
---looking at total cases vs total population in unted states
---population that has contracted covid in the usa 
select location,date,[ population ],total_cases,total_deaths,
(total_cases/[ population ])*100 as sickamericans
from ['FIRST DATA SET$']
where location like '%states%'
--order by 1,2
create view highestinfectionrate as 
----looking at countries with highest infection rates compared to population
select location,[ population ],max(total_cases) as highestinfectioncount,
max(total_cases/[ population ])*100 as percentagepopulationinfected
from ['FIRST DATA SET$']
--where location like '%states%'
group by location,[ population ]
--order by percentagepopulationinfected desc


create view deathpercountperpopulation as 
---showing countries with the highest death count per population
select location,max(convert(float,total_deaths)) as totaldeathcount
from ['FIRST DATA SET$']
where continent is not null
group by location
--order by totaldeathcount desc

create view deathcount as 
---LET'S BREAK THINGS DOWN BY CONTINENT
---showing continents with the highest deathcount
select location,max(convert(float,total_deaths)) as deathcount  
from ['FIRST DATA SET$']
--where location like '$states%'
where continent is null
group by location
--order by deathcount desc

create view africapercentage as 
---globally
select continent,date,total_cases,total_deaths,
(convert(float,total_deaths)/convert(float,total_cases))*100 as percentagedeaths
from ['FIRST DATA SET$']
where continent like '%africa%'
--order by 1,2 

create view populationpercentage as 
select continent,[ population ],max(total_cases) as highestinfectioncount,
max(total_cases/[ population ])*100 as percentagepopulationinfected
from ['FIRST DATA SET$']
--where location like '%states%'
group by continent,[ population ]
--order by percentagepopulationinfected desc

create view globaldeaths as
select date,sum(new_cases),sum(convert(float,new_deaths))
---(convert(float,total_deaths)/convert(float,total_cases))*100 as deaths
from ['FIRST DATA SET$']
where continent  is not null
group by date
--order by 1,2

create view peoplefromcovid as 
---looking at percentage deaths of people who have contracted covid globally
select 
sum(new_cases) as totalcases,
sum(convert(float,new_deaths)) as totaldeaths,
sum(convert(float,new_deaths))/sum(new_cases)*100 as percentagedeaths
from ['FIRST DATA SET$']
where continent is not null
--group by date
--order  by 1,2

create view failedtreatment as 
---joining both deaths and vaccinations
select *
from ['FIRST DATA SET$']
join Sheet1$
on ['FIRST DATA SET$'].location=Sheet1$.location
and ['FIRST DATA SET$'].date=Sheet1$.date


create view peoplevaccinated as 
--looking at total population vs vaccination
select ['FIRST DATA SET$'].continent,
['FIRST DATA SET$'].location,
['FIRST DATA SET$'].date,
['FIRST DATA SET$'].[ population ],
Sheet1$.new_vaccinations
from ['FIRST DATA SET$']
join Sheet1$
on ['FIRST DATA SET$'].location=Sheet1$.location
and ['FIRST DATA SET$'].date=Sheet1$.date
where ['FIRST DATA SET$'].continent is not null
--order by 1,2,3


----rolling count
create view peopletreated as 
select ['FIRST DATA SET$'].continent,
['FIRST DATA SET$'].location,
['FIRST DATA SET$'].date,
Sheet1$.new_vaccinations,
sum(convert(float,sheet1$.new_vaccinations)) over (partition by['FIRST DATA SET$'].location 
order by ['FIRST DATA SET$'].location,['FIRST DATA SET$'].date) as RollingPeopleVaccinated
from ['FIRST DATA SET$']
join Sheet1$
on ['FIRST DATA SET$'].location=Sheet1$.location
and ['FIRST DATA SET$'].date=Sheet1$.date
where ['FIRST DATA SET$'].continent is not null
---order by 2 ,3
create view continuingnumber as 
---USE CTE 
With PopVsVac(Continent,location,date,population,new_vaccinations,RollingPeopleVaccinated) as 
(
select ['FIRST DATA SET$'].continent,['FIRST DATA SET$'].location,['FIRST DATA SET$'].date,
['FIRST DATA SET$'].[ population ],Sheet1$.new_vaccinations,
sum(convert(float,Sheet1$.new_vaccinations)) 
over (partition by['FIRST DATA SET$'].location
order by ['FIRST DATA SET$'].location, ['FIRST DATA SET$'].date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/Population)*100
from ['FIRST DATA SET$']
join Sheet1$
on ['FIRST DATA SET$'].location=Sheet1$.location
and ['FIRST DATA SET$'].date=Sheet1$.date
where ['FIRST DATA SET$'].continent is not null
--order by 2,3
)
select *
from PopVsVac

-------rolling numbers cte
----USE CTE 
With PopVsVac(Continent,location,date,population,new_vaccinations,RollingPeopleVaccinated) as 
(
select ['FIRST DATA SET$'].continent,['FIRST DATA SET$'].location,['FIRST DATA SET$'].date,
['FIRST DATA SET$'].[ population ],Sheet1$.new_vaccinations,
sum(convert(float,Sheet1$.new_vaccinations)) 
over (partition by['FIRST DATA SET$'].location
order by ['FIRST DATA SET$'].location, ['FIRST DATA SET$'].date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/Population)*100
from ['FIRST DATA SET$']
join Sheet1$
on ['FIRST DATA SET$'].location=Sheet1$.location
and ['FIRST DATA SET$'].date=Sheet1$.date
where ['FIRST DATA SET$'].continent is not null
--order by 2,3
)
select*,(	RollingPeopleVaccinated/population)*100
from PopVsVac

----creating a view to store data for visualisations 


--looking at total population vs vaccination
create view Percet
select ['FIRST DATA SET$'].continent,
['FIRST DATA SET$'].location,
['FIRST DATA SET$'].date,
['FIRST DATA SET$'].[ population ],
Sheet1$.new_vaccinations
from ['FIRST DATA SET$']
join Sheet1$
on ['FIRST DATA SET$'].location=Sheet1$.location
and ['FIRST DATA SET$'].date=Sheet1$.date
where ['FIRST DATA SET$'].continent is not null
order by 1,2,3
