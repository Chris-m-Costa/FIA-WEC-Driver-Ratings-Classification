# FIA WEC Driver Ratings Analysis

### Final project for IronHack Data Analytics Bootcamp Course

This project is centered around an analysis of data from the FIA World Endurance Championship to predict the driver rating of each driver. The project will use multiple machine learning techniques and several python libraries for analysis as well as PDF scraping for feature engineering.

## The dataset

The original dataset is found on [Kaggle](https://www.kaggle.com/datasets/tristenterracciano/fia-wec-lap-data-20122022) and includes lap by lap data for WEC races from the series inception in 2012 to mid-2022 season. The data made available on Kaggle originally comes from [the official WEC results portal](http://fiawec.alkamelsystems.com/) where .csv files can be downloaded for all events and session that have taken place. 

## The Sport

The [World Endurance Championship](fiawec.com) is sanctioned by the [FIA](fia.com) (Fédération Internationale de l'Automobile) and organized by the [ACO](https://www.lemans.org/en) (Automobile Club de l'Ouest) who trace their history back to 1906 and have organized the famous Le Mans 24 Hour motor race since it first ran in 1923. The Le Mans 24hr today forms the focal point of the WEC and will celebrate it's centenary this June in front of a sold-out crowd. 
A typical WEC season runs over 6-8 races with race lengths varying from 4 hours up to the full 24 hours and visits several of the most famous and prestigious motor racing circuits in the world. 

WEC races feature multiple car classes with different performance characteristics all racing amongst themselves, sharing the circuit at the same time. This forces drivers to not only navigate the circuit in the fastest possible lap time but also to negotiate faster and/or slower traffic driven by a range of experience and skill level drivers.  

Two of the car classes (LMP1/Hypercar and LMGTE-Pro) are the home of major automotive manufactuers competing with either high-performance, production derived GT cars or fully bespoke racing prototypes, the ultimate expression of what a racing can can achieve and driven by fully proffesional drivers. In addition there are the two pro-am categories: LMP2 which features a moderately lower performance level racing prototype in the vein of the LMP1/Hypercar chassis, and the LMGTE-Am class which features the same GT chassis as the Pro counterpart class but with cars mandated to be of the previous years specification or older.

Due to the long duration of the events cars will be shared by a team of up to 3 drivers alternating stints throughout the race with driver changes happening during the already frantic process of normal pit servcie for fuel and tires. Driver lineups in the pro-am categories are restricted in the rating of the drivers eligible to allow parity for the lesser skilled or experienced drivers.

## The Precious Metals Rating System 
### Our machine learning target

The drivers in the WEC (and other similar racing series) are rated by the FIA into Bronze, Silver, Gold, and Platinum categories based their experience level, career achievements, on-track performances and age. The platinum rating is reserved for the most experienced and highly decorated professional drivers, the gold ranking is attainable by any driver who has acheived significant success and experience in their career but not yet reached the upper echelon of career acheivments. The silver rating is primarily for the most talented/accomplished amateurs and for young and aspiring pros the the early stages of their careers. The Bronze rating is the lowest level of the FIA rating system and is applied to lowest levels of experienced drivers allowed to compete in the series. There are alos age levels involved with ages of 50 and 55 bringing an automatic step down in driver rating regardless of experience or acheivments. 

The driver rating system was devised in 2016 to help ensure fair balance of driver talent in pro-am racing categories. In the LMP2 class each car must feature at least one Bronze or Silver rated driver, and no more than one Platinum-rated driver. The other driver(s) in the car may be rated either Silver or Gold. In the GTE-Am class at least one Bronze rated driver is required, no more than one Platinum-rated driver is permitted, the remaining drivers may Bronze, Silver, or Gold rated.

## The Project

### PDF Scraping

The target for our machine learning project is the driver rating information, unfortunately this was not available in the Kaggle provided dataset. To aquire this data I went looking into the materials availabe in the fiawec.alkamelsystems results portal. Here can be found official entry lists for each event shows each car with all drivers named and their corresponding precious metal rating. The data is available only in PDF form (as can be found in the wec_entry_lists folder here in the repo) and so had to be scraped. To that end I found a python library known as [Tabula-py](https://tabula-py.readthedocs.io/en/latest/index.html), a python wrapper for the Tabula-Java package that can read tables from a PDF document into a pandas DataFrame or a CSV file. Several steps need to be taken to scrape the wanted driver name and ratings data cleanly into DataFrames, several PDF's have minor differences which necessitated slightly different functions for each table. 

For most seasons the Le mans 24 entry list was used; as Le Mans is the biggest event of the season it often brings additional one-off entries as well as additional drivers added to some cars so these lists were used to pull in ratings for as many drivers as possible. For the 2017 season all PDFs for Le Mans were in the form of scanned physical documents (signed by the race director and event stewards) and would not scrape using Tabula. For this season the PDF for the Spa-Francorchamps event was used; this was the first event of the season and allowed us to atleast acquire the data for all full season drivers.

A regex function was used to trim the drivers names of any excess punctuation marks (and country abbreviations) before exporting each years data into separate CSV files. In another notebook these individual CSV files were read into a DateFrame, had a year column added to each, and concatenated together. The python Unidecode library was used to remove any accents, tildes, or umlaut characters from driver name, change all names to lower case, and strip any trailing or leading white spaces. The clean, combined driver_names dateframe is then exported to a new CSV.

### Feature Engineering

The original dataset included a column for the season in which the lap took place. Most seasons are simple years 2012, 2013, 2014...
Starting in 2018 the ACO decided to run the series on a winter based calendar meaning the season would run from 2018-2019, this was continued for the following season running from 2019-2020. The Covid-19 pandemic casued a delay in the planned calendar in 2020 pushing the end of the season much later in the year, close to a normal seasons end date. The winter season was abandoned after this point.
For easier use in the model and and for other feature engineering steps this column was replaced with a year column.  A function was devised to reploace the season with the corresponding year, for the two winter season years the round number was checked against known historic series calendars and placed in the correct year. 

Ex: elif row['season'] == '2018-2019':
            if row['round'] <= 5:
                new_column_values.append(2018)
            elif row['round'] > 5:
                new_column_values.append(2019)
                
In endurance racing a cars average laptime throughout a race is a much more important factor in overall performance than a single laps pace. To this end a new column was derived to show a rolling 5-lap average for each driver. To make this column work and show accurate values the function had to group by car number, driver number (to identify which driver was in the car), round number (to check that the laps being calculated were run in the same race) and driver_stint_no (to ensure the calculated laps were run in the same stint(a term used for a drivers turn at the wheel)). To prevent NaN values being created when a driver has not yet run 5 laps in the stint the function will use the average of the number of laps run up to 5 laps and then continue to roll-over the most recent 5 laps. 

The same driver name cleaning operations are applied to the original dataset using Unidecode, .strip(), and .lower() operations to allow matching with the all_driver_ratings CSV. The driver_rating column from the table is added to the main dataset using a pd.merge() function matched on the driver name and year columns from both tables.

Finally the circuit names are converted from the original extended format to the common usage shorthand names and changed to all lower case. 
Ex: 'SPA FRANCORCHAMPS' changed to simply 'spa'.

The column 'crossing_finish_line_in_pit' holds Nan values for any laps that crossed start-finish on track and a 'B' character for a lap finished in pitlane. The values are replaced with 0 for laps on track and 1 for laps in pit.

Finally the 'flag_at_fl' column was dropped as data only exists starting with the 2022 season.

                


