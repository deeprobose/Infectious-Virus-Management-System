-- Queries for the database
-- 1. Retrieve the top 5 countries with the highest number of cases for a specific virus: 

SELECT c.country_name, SUM(ca.case_count) AS total_cases
FROM Countries c
JOIN Cases ca ON c.country_id = ca.country_id
JOIN Viruses v ON v.virus_id = ca.virus_id
WHERE v.virus_name = 'HIV'
GROUP BY c.country_name
ORDER BY total_cases DESC
LIMIT 5;

-- Gain from Query: Ability to develope health care system according to the virus and its symptoms. 

-- 2. For each virus, retrieve the virus name, the vaccine with the highest efficacy, along with its development status and efficacy value, as well as the vaccine with the lowest efficacy, along with its development status and efficacy value.

SELECT v.virus_name,
       vc_max.vaccine_name AS highest_efficacy_vaccine,
       vc_max.development_status AS highest_efficacy_status,
       vc_max.efficacy,
       vc_min.vaccine_name AS lowest_efficacy_vaccine,
       vc_min.development_status AS lowest_efficacy_status,
       vc_min.efficacy
FROM Viruses v
JOIN (
    SELECT virus_id,
           MAX(efficacy) AS max_efficacy,
           MIN(efficacy) AS min_efficacy
    FROM Vaccines
    GROUP BY virus_id
) sub ON v.virus_id = sub.virus_id
JOIN Vaccines vc_max ON vc_max.virus_id = sub.virus_id AND vc_max.efficacy = sub.max_efficacy
JOIN Vaccines vc_min ON vc_min.virus_id = sub.virus_id AND vc_min.efficacy = sub.min_efficacy;

-- Gain: to determine the most and least effective vaccine available for each virus. 

-- 3. Determine which countries are prepared for an outbreak? (i.e. which countries have the ratio of total quarantine facility capacity to population less than 1:100)

SELECT c.country_name,
       SUM(qf.capacity) AS total_capacity,
       c.population,
       CASE WHEN SUM(qf.capacity) / c.population >= 0.01 THEN 'PREPARED'
            ELSE 'NOT PREPARED'
       END AS prepared_status
FROM Countries c
LEFT JOIN Quarantine_Facilities qf ON qf.country_id = c.country_id
GROUP BY c.country_id, c.country_name, c.population;

-- Gain: Ability to understand if a country is prepared for an outbreak or not. 

-- 4. Which viruses have the transmission mode 'Mosquito Bites', and what is the total number of cases for each virus? Additionally, for each virus, which country has the highest number of cases? What prevention methods must be implemented by the citizens of that country. 

SELECT v.virus_name, SUM(c.case_count) AS total_cases, ch.country_name AS country_with_highest_cases, v.prevention_methods
FROM Viruses v
JOIN Cases c ON v.virus_id = c.virus_id
JOIN (
    SELECT virus_id, country_name
    FROM Cases c
    JOIN Countries co ON c.country_id = co.country_id
    WHERE c.case_count = (
        SELECT MAX(case_count)
        FROM Cases
        WHERE virus_id = c.virus_id
    )
) ch ON v.virus_id = ch.virus_id
WHERE v.transmission_mode = 'Mosquito Bites'
GROUP BY v.virus_id, v.virus_name, ch.country_name, v.prevention_methods
ORDER BY total_cases DESC;

-- Gain: To isolate certain group of viruses and to focus on those countries for a particular tranmission type and the prevention method which needs to be implemented. 

-- 5. What are the viruses with the highest mortality rates, considering the total number of deaths in relation to the total number of cases?

SELECT v.virus_name,
       SUM(d.death_numbers) AS total_deaths,
       SUM(c.case_count) AS total_cases,
       (SUM(d.death_numbers) / SUM(c.case_count)) * 100 AS mortality_rate
FROM deaths d
JOIN Viruses v ON d.virus_id = v.virus_id
JOIN Cases c ON d.virus_id = c.virus_id
GROUP BY v.virus_id, v.virus_name
ORDER BY mortality_rate DESC;

-- Gain: understand which virus is deadlier as compared to other viruses. 