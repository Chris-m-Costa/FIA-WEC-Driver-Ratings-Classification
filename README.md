# FIA WEC Driver Ratings Analysis

### Final project for IronHack Data Analytics Bootcamp Course

This project is centered around an analysis of data from the FIA World Endurance Championship to predict the driver rating of each driver. The project will use multiple machine learning techniques and several python libraries for analysis as well as PDF scraping for feeature engineering.

### The dataset

The original dataset is found on [Kaggle](https://www.kaggle.com/datasets/tristenterracciano/fia-wec-lap-data-20122022) and includes lap by lap data for WEC races from the series inception in 2012 to mid-2022 season. The data made available on Kaggle originally comes from [the official WEC results portal](http://fiawec.alkamelsystems.com/) where .csv files can be downloaded for all events and session that have taken place. 

### The Sport

The [World Endurance Championship](fiawec.com) is sanctioned by the [FIA](fia.com) (Fédération Internationale de l'Automobile) and organized by the [ACO](https://www.lemans.org/en) (Automobile Club de l'Ouest) who trace their history back to 1906 and have organized the famous Le Mans 24 Hour motor race since it first ran in 1923. The Le Mans 24hr today forms the focal point of the WEC and will celebrate it's centenary this June in front of a sold-out crowd. 
A typical WEC season runs over 6-8 races with race lengths varying from 4 hours up to the full 24 hours and visits several of the most famous and prestigious motor racing circuits in the world. 

WEC races feature multiple car classes with different performance characteristics all racing amongst themselves, sharing the circuit at the same time. This forces drivers to not only navigate the circuit in the fastest possible lap time but also to negotiate faster and/or slower traffic driven by a range of experience and skill level drivers. Due to the long duration of the events cars will be shared by a team of up to 3 drivers alternating stints throughout the race with driver changes happening during the already frantic process of normal pit servcie for fuel and tires. Two of the car classes (LMP1/Hypercar and LMGTE-Pro) are the home of major automotive manufactuers competing with either high-performance, production derived GT cars or fully bespoke racing prototypes, the ultimate expression of what a racing can can achieve and driven by fully proffesional drivers. In addition there are the two pro-am categories: LMP2 which features a moderately lower performance level racing prototype in the vein of the LMP1/Hypercar chassis, and the LMGTE-Am class which features the same GT chassis as the Pro counterpart class but with cars mandated to be of the previous years specification or older. Driver lineups in the pro-am categories are restricted in the rating of the drivers eligible to allow parity for the lesser skilled or experienced drivers.

