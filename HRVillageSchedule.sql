create database class_11;

use class_11;

CREATE TABLE HRVillageSchedule (
        state_name VARCHAR(7) NOT NULL,
        district_name VARCHAR(13) NOT NULL,
        block_tehsil_name VARCHAR(16) NOT NULL,
        village_name VARCHAR(24) NOT NULL,
        ref_village_type_name VARCHAR(10) NOT NULL,
        major_medium_scheme VARCHAR(30),
        major_medium_scheme_name VARCHAR(33),
        geographical_area DECIMAL(38, 0) NOT NULL,
        cultivable_area DECIMAL(38, 0) NOT NULL,
        net_sown_area DECIMAL(38, 0) NOT NULL,
        gross_irrigated_area_kharif_season DECIMAL(38, 0) NOT NULL,
		gross_irrigated_area_rabi_season DECIMAL(38, 0) NOT NULL,
        gross_irrigated_area_perennial_season DECIMAL(38, 0) NOT NULL,
        gross_irrigated_area_other_season DECIMAL(38, 0) NOT NULL,
        gross_irrigated_area_total DECIMAL(38, 0) NOT NULL,
        net_irrigated_area DECIMAL(38, 0) NOT NULL,
        avg_ground_water_level_pre_monsoon DECIMAL(38, 0) NOT NULL,
        avg_ground_water_level_post_monsoon DECIMAL(38, 0) NOT NULL,
        ref_selection_wua_exists_name VARCHAR(9) NOT NULL
);
use class_11;

LOAD DATA INFILE  
"D:\HRVillageSchedule.csv"
into table HRVillageSchedule
FIELDS TERMINATED by ','
ENCLOSED by '"'
lines terminated by '\n'
IGNORE 1 ROWS;

SELECT * FROM  HRVillageSchedule;

SELECT DISTINCT district_name, block_tehsil_name from  HRVillageSchedule

SELECT * from  HRVillageSchedule where ref_village_type_name = 'Tribal'
                                 group by district_name 
						         order by ref_village_type_name;
                                 
SELECT block_tehsil_name, ref_village_type_name, major_medium_scheme, geographical_area
FROM HRVillageSchedule
WHERE geographical_area  BETWEEN 10000 AND 25000; 

select * from HRVillageSchedule;

select * from HRVillageSchedule
where cultivable_area > 2000;

select ref_village_type_name , village_name
from HRVillageSchedule
where ref_village_type_name = 'Tribal';

select ref_village_type_name ,
count(*) as village_count
from HRVillageSchedule
group by ref_village_type_name;

# DATA EXPLORATION #
#****LET'S SEE THE SHAPE OF THE TABLE I.E COLUMNS AND ROW IN THE TABLE****#

select count( * ) as rownum from  HRVillageSchedule; #ROWS
select count( * ) as col_num from information_schema.columns where table_name = "HRVillageSchedule"; #COLUMNS
#*****THERE ARE THE 7038 ROWS AND 19 COLUMNS IN THE  HRVillageSchedule TABLE

select district_name, block_tehsil_name, village_name, geographical_area from  HRVillageSchedule
order by geographical_area desc ;
#****THUS MEWAT, MAHENDRAGARH, HISSAR DITRICTS HAVE LARGE GEOGRAPHICAL AREA AS COMPARE TO OTHER DISTRICTS****#

select district_name, block_tehsil_name, village_name, cultivable_area from  HRVillageSchedule
order by cultivable_area desc;
#***THUS MAHENDRAGARH AND HISSAR DISTRICTS HAVE LARGE CULTIVABLE AREA AS COMPARE TO OTHER DISTRICTS***#

select district_name, block_tehsil_name, village_name, cultivable_area from  HRVillageSchedule
order by net_sown_area desc;
#***MAHENDRAGARH(Malra) AND HISSAR(Bir hisar)***#

set GLOBAL sql_mode = (SELECT REPLACE (@@sql_mode, 'ONLY_FULL_GROUP_BY', ' '));


SELECT 
    MAX(district_name) AS district_name, 
    MAX(block_tehsil_name) AS block_tehsil_name, 
    MAX(village_name) AS village_name,
    gross_irrigated_area_kharif_season
    FROM  HRVillageSchedule
    GROUP BY gross_irrigated_area_kharif_season
    ORDER BY cultivable_area;

#****STATISTICAL SUMMERY****#
SELECT
    MIN(cultivable_area) AS min_cultivable_area,
    MAX(cultivable_area) AS max_cultivable_area,
    AVG(cultivable_area) AS avg_cultivablr_area,
    SUM(cultivable_area) AS total_cultivable_area
    from HRVillageSchedule;


#****DISTRIBUTION OF VILLAGE TYPES****#
SELECT
    SUM(gross_irrigated_area_kharif_season) AS total_kharif_irrigated_area,
    SUM(gross_irrigated_area_rabi_season) AS total_rabi_irrigated_area,
    SUM(gross_irrigated_area_perennial_season) AS total_perennial_irrigated_area,
    SUM(gross_irrigated_area_other_season) AS total_other_irrigated_area
    FROM HRVillageSchedule;


#****AVEARAGE GROUNDWATER LEVEL****#
SELECT
    AVG(avg_ground_water_level_pre_monsoon) AS avg_pre_monsoon_groundwater_level,
    AVG(avg_ground_water_level_post_monsoon) AS avg_post_monsoon_groundwater_lavel
    FROM HRVillageSchedule;


#****MAJOR MEDIUM SCHEMES ANALYSIS****#
SELECT
    major_medium_scheme_name,
    COUNT(*) AS scheme_count
    FROM HRVillageSchedule
    WHERE major_medium_scheme IS NOT NULL
    GROUP BY major_medium_scheme_name;
    
    
# 1. ANALYSIS OF CULTIVABLE VS IRRIGATED AREAS #
SELECT
    district_name,
    SUM(cultivable_area) AS total_cultivable_area,
    SUM(net_irrigated_area) AS total_irrigated_area,
    (SUM(net_irrigated_area) / SUM(cultivable_area)) * 100 as irrigation_efficiency_percentage
    FROM HRVillageSchedule
    GROUP BY district_name
    ORDER BY irrigation_efficiency_percentage DESC;
    
#THUS DISTRICT ROTHAK HAVE HIGH IRRIGATION EFFICIENCY  


 # 2.GROUNDWATER LEVEL FLUCTUATION #
 
 SELECT
    district_name, 
    AVG(avg_ground_water_level_pre_monsoon) AS avg_pre_monsoon_groundwater, 
    AVG(avg_ground_water_level_post_monsoon) AS avg_post_monsoon_groundwater,
    AVG(avg_ground_water_level_post_monsoon) - AVG(avg_ground_water_level_pre_monsoon) AS avg_groundwater_change
    FROM HRVillageSchedule
    GROUP BY district_name
    ORDER BY avg_groundwater_change ;
    
# PANIPAT HAS HUGE CHANGE IN GROUNDWATER  


# 3. IMPACT OF MAJOR MEDIUM SCHEME  #

SELECT
    major_medium_scheme_name,
    COUNT(*) AS number_of_villages_under_scheme,
    SUM(gross_irrigated_area_total) AS total_irrigated_area_under_scheme
    FROM HRVillageSchedule
    WHERE major_medium_scheme IS NOT NULL
    GROUP BY major_medium_scheme_name
    ORDER BY total_irrigated_area_under_scheme DESC;
    
# WE GET TO KNOW MAJORITY OF VILLAGES  IS NOT IN THIS SCHEME


# 4. VILLAGE TYPE AND AGRICULTURAL LAND USE  #

SELECT
	ref_village_type_name, 
    AVG(geographical_area) AS avg_geographical_area, 
    AVG(cultivable_area) AS avg_cultivable_area, 
    AVG(net_sown_area) AS avg_net_sown_area
    FROM HRVillageSchedule
    GROUP BY ref_village_type_name;
    
#GEOGRAPHICAL AREA,CULTIVABLE AREA AND NET SOWN AREA IS LARGE IN QUANTITY


# 4. SEASONAL IRRIGATION ANALYSIS #

SELECT
    AVG(gross_irrigated_area_kharif_season) AS avg_kharif_irrigation, 
    AVG(gross_irrigated_area_rabi_season) AS avg_rabi_irrigation, 
    AVG(gross_irrigated_area_perennial_season) AS avg_perennial_irrigation,
    AVG(gross_irrigated_area_other_season) AS avg_other_season_irrigation
    FROM HRVillageSchedule;
    
# THUS WE GET TO KNOW THAT KHARIF IS HUGELY CULTIVATED


# 6. ANALYSIS OF IRRIGATED AREA BY SEASON AND VILLAGE TYPE #

SELECT
	ref_village_type_name,
    AVG(gross_irrigated_area_kharif_season) AS avg_kharif_irrigation,
    AVG(gross_irrigated_area_rabi_season) AS avg_rabi_irrigation,
    AVG(gross_irrigated_area_perennial_season) AS avg_perennial_irrigation,
    AVG(gross_irrigated_area_other_season) AS avg_other_season_irrigation
    FROM HRVillageSchedule
    GROUP BY ref_village_type_name; 
    
# 7. DISTRICT WISE WATER USE ASSOCIATION PRESENCE AND IRRIGATED AREA #

SELECT
	district_name,
    ref_selection_wua_exists_name,
    AVG(net_irrigated_area) AS avg_net_irrigated_area
    FROM HRVillageSchedule
    GROUP BY district_name, ref_selection_wua_exists_name
    ORDER BY district_name, avg_net_irrigated_area DESC;
    
# 8. ANALYSIS OF IRRIGATED AREA BY SEASON AND VILLAGE TYPE #

SELECT
    ref_village_type_name,
    AVG(gross_irrigated_area_kharif_season) AS avg_kharif_irrigation,
    AVG(gross_irrigated_area_rabi_season) AS avg_rabi_irrigation,
    AVG(gross_irrigated_area_perennial_season) AS avg_perennial_irrigation,
    AVG(gross_irrigated_area_other_season) AS avg_other_season_irrigation
    FROM HRVillageSchedule
    GROUP BY ref_village_type_name;
    
    
# 9. EFFICIENCY OF MAJOR MEDIUM SCHEMES ACROSS VILLAGE TYPES #

SELECT
	ref_village_type_name,
    major_medium_scheme_name,
    AVG(gross_irrigated_area_total) AS avg_irrigation_area_under_scheme
    FROM HRVillageSchedule
    WHERE major_medium_scheme IS NOT NULL
    GROUP BY ref_village_type_name, major_medium_scheme_name
    ORDER BY avg_irrigation_area_under_scheme DESC;
    
# THUS 'BHAKHRA JAL SCHAI JOJNA' IS MOST SUCSESSFUL IN TRIBAL AREA AND 'CHANDRAWAL MINOR KHAJURI MINOR' IS MOST SUCSESSFUL IN NON TRIBAL AREA

# 10. ANALYSIS OF GEOGRAPHICAL VS CULTIVABLE AREA #

SELECT
	block_tehsil_name,
    SUM(geographical_area) AS total_geographical_area,
    SUM(cultivable_area) AS total_cultivable_area,
    (SUM(cultivable_area) / SUM(geographical_area)) * 100 AS cultivable_area_percentage
    FROM HRVillageSchedule
    GROUP BY block_tehsil_name
    ORDER BY cultivable_area_percentage DESC; 
    
# HOHANA TEHSIL HAVE HIGHEST GEOGRAPHICAL AREA AND CULTIVABLE AREA


# 11.MAJOR MEDIUM SCHEME EFFECTIVENESS BY DISTRICT #

SELECT
	district_name,
    major_medium_scheme_name,
    COUNT(*) AS number_of_villages,
    SUM(gross_irrigated_area_total) AS total_irrigation_under_scheme
    FROM HRVillageSchedule
    WHERE major_medium_scheme IS NOT NULL
    GROUP BY district_name, major_medium_scheme_name
    ORDER BY district_name, total_irrigation_under_scheme DESC; 
    
    
# 12.PRE AND POST MONSOON GROUNDWATER LEVEL CHANGES BY VILLAGE TYPE #

SELECT
	ref_village_type_name,
    AVG(avg_ground_water_level_pre_monsoon) AS avg_pre_monsoon_groundwater,
    AVG(avg_ground_water_level_post_monsoon) AS avg_post_monsoon_groundwater,
    AVG(avg_ground_water_level_post_monsoon) - AVG(avg_ground_water_level_pre_monsoon) AS avg_groundwater_change
    FROM HRVillageSchedule
    GROUP BY ref_village_type_name
    ORDER BY avg_groundwater_change DESC;
    
# GROUND WATER IS MORE DEPLEDTED ON NON-TRIBAL VILLAGE THAN TRIBAL VILLAGE 

# 13.COMPARISON OF CULTIVABLE AREA TO IRRIGATED AREA #

SELECT
	state_name,
    (SUM(net_irrigated_area) / SUM(cultivable_area)) * 100 AS irrigation_coverage_percentage
    FROM HRVillageSchedule
    GROUP BY state_name;
    
# THE HARYANA STATE HAVE 86.7874% AREA UNDER IRRIGATION 

# 13. IDENTIFYING REGIONS WITH HIGH AND LOW GROUNDWATER  RECHARGE #

SELECT
	district_name,
    AVG(avg_ground_water_level_post_monsoon - avg_ground_water_level_pre_monsoon) AS avg_groundwater_recharge
    FROM HRVillageSchedule
    GROUP BY district_name
    ORDER BY avg_groundwater_recharge DESC;
    
# FATEHABAD HAS VERY LOW GROUNDWTER RECHARGE

# 14. AGRICULTURAL INTENSITY ANALYSIS #

SELECT
	block_tehsil_name,
    (SUM(net_sown_area) / SUM(cultivable_area)) * 100 AS agricultural_intensity_percentage
    FROM HRVillageSchedule
    GROUP BY block_tehsil_name
    ORDER BY agricultural_intensity_percentage DESC;
    
# UCHANA HAVE HIGH AGRICULTURAL INTENSITY PERCENTAGE    

# 16. ANALYSIS OF SEASONAL IRRIGATION DEPENDENCY #

SELECT
	(SUM(gross_irrigated_area_kharif_season) / SUM(gross_irrigated_area_total)) * 100 AS kharif_season_dependency,
    (SUM(gross_irrigated_area_rabi_season) / SUM(gross_irrigated_area_total)) * 100 AS rabi_season_dependency,
    (SUM(gross_irrigated_area_perennial_season) / SUM(gross_irrigated_area_total)) * 100 AS perennial_season_dependency
    FROM HRVillageSchedule;
    
# RABI SEASON HAVE HIGH DEPENDENCY     
    
# 17. CORRELATION BETWEEN GROUNDWTER LEVEL AND IRRIGATED AREAS #

SELECT 
	district_name,
    AVG(avg_ground_water_level_post_monsoon) AS avg_post_monsoon_groundwater,
    AVG(net_irrigated_area) AS avg_net_irrigated_area
    FROM HRVillageSchedule
    GROUP BY district_name
    ORDER BY avg_post_monsoon_groundwater, avg_net_irrigated_area DESC;
    
# 'HISSAR' IS ONLY DISTRICT WITH LOW POST MONSOON GROUNDWATER AND HUGE IRRIGATED AREA AND
# REST OF DISTRICT HAVE GROUND WATER AND IRRIGATION AREA DIRECTLY PROPORTIONAL TO EACH OTHER.# 

         












                              
        

