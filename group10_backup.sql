-- Create Viruses Table
CREATE TABLE Viruses (
    virus_id INT PRIMARY KEY NOT NULL,
    virus_name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    transmission_mode VARCHAR(50) NOT NULL,
    symptoms TEXT NOT NULL,
    prevention_methods TEXT NOT NULL
);

-- Create Countries Table
CREATE TABLE Countries (
    country_id INT PRIMARY KEY NOT NULL,
    country_name VARCHAR(100) NOT NULL,
    continent VARCHAR(50) NOT NULL,
    population INT NOT NULL,
    government_type VARCHAR(50) NOT NULL,
    healthcare_system TEXT NOT NULL
);

-- Create Cases Table
CREATE TABLE Cases (
    case_id INT PRIMARY KEY NOT NULL,
    virus_id INT NOT NULL,
    country_id INT NOT NULL,
    date_reported DATE NOT NULL,
    case_type VARCHAR(50) NOT NULL,
    case_count INT NOT NULL,
    FOREIGN KEY (virus_id) REFERENCES Viruses(virus_id),
    FOREIGN KEY (country_id) REFERENCES Countries(country_id)
);

-- Create Vaccines Table
CREATE TABLE Vaccines (
    vaccine_id INT PRIMARY KEY NOT NULL,
    virus_id INT NOT NULL,
    vaccine_name VARCHAR(100) NOT NULL,
    development_status VARCHAR(50) NOT NULL,
    efficacy DECIMAL(5, 2) NOT NULL,
    side_effects TEXT NOT NULL,
    research_institutions TEXT NOT NULL,
    FOREIGN KEY (virus_id) REFERENCES Viruses(virus_id)
);

-- Create Research Table
CREATE TABLE Research (
    research_id INT PRIMARY KEY NOT NULL,
    virus_id INT NOT NULL,
    researcher_name VARCHAR(100) NOT NULL,
    research_institution VARCHAR(100) NOT NULL,
    research_topic VARCHAR(100) NOT NULL,
    publication_date DATE NOT NULL,
    findings TEXT NOT NULL,
    FOREIGN KEY (virus_id) REFERENCES Viruses(virus_id)
);

-- Create Travel_Advisories Table
CREATE TABLE Travel_Advisories (
    advisory_id INT PRIMARY KEY NOT NULL,
    country_id INT NOT NULL,
    advisory_level VARCHAR(50) NOT NULL,
    advisory_date DATE NOT NULL,
    advisory_details TEXT NOT NULL,
    FOREIGN KEY (country_id) REFERENCES Countries(country_id)
);

-- Create Testing_Labs Table
CREATE TABLE Testing_Labs (
    lab_id INT PRIMARY KEY NOT NULL,
    lab_name VARCHAR(100) NOT NULL,
    country_id INT NOT NULL,
    lab_type VARCHAR(50) NOT NULL,
    testing_capacity INT NOT NULL,
    contact_information VARCHAR(100) NOT NULL,
    FOREIGN KEY (country_id) REFERENCES Countries(country_id)
);

-- Create Quarantine_Facilities Table
CREATE TABLE Quarantine_Facilities (
    facility_id INT PRIMARY KEY NOT NULL,
    facility_name VARCHAR(100) NOT NULL,
    country_id INT NOT NULL,
    facility_type VARCHAR(50) NOT NULL,
    capacity INT NOT NULL,
    location VARCHAR(100) NOT NULL,
    FOREIGN KEY (country_id) REFERENCES Countries(country_id)
);
