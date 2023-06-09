# FIA WEC Driver Ratings Analysis

### Final project for IronHack Data Analytics Bootcamp Course

This project is centered around an analysis of data from the FIA World Endurance Championship to predict the driver rating of each driver. The project uses multiple machine learning techniques and several python libraries for analysis as well as PDF scraping for feature engineering.

## The dataset

The original dataset is found on Kaggle and includes lap by lap data for WEC races from the series inception in 2012 to mid-2022. The data available on Kaggle originates from the official WEC results portal where .csv files can be downloaded for all events and sessions that have taken place.

## The Sport

The World Endurance Championship is sanctioned by the FIA (Fédération Internationale de l'Automobile) and organized by the ACO (Automobile Club de l'Ouest) who trace their history back to 1906 and have organized the famous Le Mans 24 Hour motor race since it first ran in 1923. The Le Mans 24 Hour today forms the focal point of the WEC and will celebrate its centenary this June in front of a sold-out crowd. A typical WEC season runs over six to eight races with race lengths varying from 4 hours up to the full 24 hours and visits several of the most famous and prestigious motor racing circuits in the world.

WEC races feature multiple car classes with different performance characteristics all racing amongst themselves, yet sharing the circuit at the same time. This forces drivers to not only navigate the circuit in the fastest possible lap time but also to negotiate faster and/or slower traffic from other classes driven by a range of experience and skill level drivers.

Two of the car classes (LMP1/Hypercar and LMGTE-Pro) are the home of major automotive manufacturers competing with either high-performance production derived GT cars or fully bespoke racing prototypes, which are the ultimate expression of what a racing car can achieve and driven by fully professional drivers. In addition there are two pro-am categories; LMP2, which features a moderately lower performance level racing prototype in the vein of the LMP1/Hypercar chassis, and the LMGTE-Am class, which features the same GT chassis as the Pro counterpart class but with cars mandated to be of the previous years specification or older.

Due to the long duration of the events, cars will be shared by a team of up to 3 drivers who alternate stints throughout the race with driver changes happening during the already frantic process of normal pit service for fuel and tires. Driver lineups in the pro-am categories are restricted in the combination of driver ratings eligible to allow parity for the lesser skilled or experienced drivers.

## The Precious Metals Rating System 
### Our machine learning target

The drivers in the WEC (and other similar racing series) are rated by the FIA into Bronze, Silver, Gold, and Platinum categories based on their experience level, career achievements, on-track performances and age. The Platinum rating is reserved for the most experienced and highly decorated professional drivers. The Gold ranking is attainable by any driver who has achieved significant success and experience in their career but not yet reached the upper echelon of career achievements. The Silver rating is primarily for the most talented/accomplished amateurs and for young and aspiring pros in the early stages of their careers. The Bronze rating is the lowest level of the FIA rating system and is applied to the lowest levels of experienced drivers allowed to compete in the series. There are also age levels involved, with ages of 50 and 55 bringing an automatic step down in driver rating regardless of experience or achievements.

The driver rating system was devised in 2016 to help ensure fair balance of driver talent in pro-am racing categories. In the LMP2 class each car must feature at least one Bronze or Silver rated driver, and no more than one Platinum rated driver. The other driver(s) in the car may be rated either Silver or Gold. In the GTE-Am class at least one Bronze rated driver is required, no more than one Platinum-rated driver is permitted, the remaining drivers may be Bronze, Silver, or Gold rated.

## The Project

### PDF Scraping

The target for the machine learning project is the driver rating information, unfortunately this was not available in the Kaggle provided dataset. To acquire this data I went looking into the materials available in the WEC results portal. Here, official entry lists for each event show each car with all driver names and their corresponding rating. The data is available only in PDF form (as can be found in the wec_entry_lists folder here in the repo) and so it had to be scraped. To that end, I found a python library known as Tabula-py, a python wrapper for the Tabula-Java package that can read tables from a PDF document into a pandas DataFrame or a CSV file. Several steps needed to be taken to scrape the wanted driver name and ratings data cleanly into DataFrames. Several PDF's had minor differences which necessitated slightly different functions for each table.

For most seasons the Le Mans 24 entry list was used. Since Le Mans is the biggest event of the season, it often brings additional one-off entries, as well as additional drivers added to some cars. These lists were used to pull in ratings for as many drivers as possible. For the 2021 season all PDFs for Le Mans were in the form of scanned physical documents and would not scrape using Tabula. For this season, the PDF for the Spa-Francorchamps event was used as this was the first event of the season and allowed us to at least acquire the data for all full season drivers.

A regex function was used to trim the driver names of any excess punctuation marks (and country abbreviations) before exporting each year's data into separate CSV files. In another notebook these individual CSV files were read into a DateFrame, had a year column added to each, and concatenated together. The Python Unidecode library was used to remove any accents, tildes, or umlaut characters from driver names, change all names to lowercase, and strip any trailing or leading white spaces. The clean, combined driver_names dateframe was then exported to a new CSV.

### Feature Engineering

The original dataset included a column for the season in which the lap took place. Most seasons are simple years, i.e. 2012, 2013, 2014, etc... Starting in 2018, the ACO decided to run the series on a winter based calendar meaning the season would run from 2018-2019. This was continued for the following season running from 2019-2020. The COVID-19 pandemic caused a delay in the planned calendar for 2020 pushing the end of the season much later in the year, close to a normal season’s end date. The winter season was abandoned after this point. For easier use in the model and for other feature engineering steps, this season column was replaced with a year column. A function was devised to replace the season with the corresponding year. For the two winter based seasons the round number was checked against known historic series calendars and placed in the correct year.
Ex: elif row['season'] == '2018-2019': if row['round'] <= 5: new_column_values.append(2018) elif row['round'] > 5: new_column_values.append(2019)

The same driver name cleaning operations were applied to the original dataset using Unidecode, .strip(), and .lower() operations to allow matching with the all_driver_ratings CSV. Once the year column was added The driver_rating column from the scraped pdf table was added to the main dataset using a pd.merge() function matched on the driver name and year columns from both tables.

In endurance racing, a car's average lap time throughout a race is a much more important factor in overall performance than a single lap pace. To this end a new column was derived to show a rolling 5-lap average for each driver. To make this function calculate correctly and show accurate values, the function had to group by car number, driver number (to identify which driver was in the car), round number (to check that the laps being calculated were run in the same race) and driver_stint_no (to ensure the calculated laps were run in the same stint(a term used for a drivers turn at the wheel)). To prevent NaN values from being created when a driver has not yet run 5 laps in the stint, the function uses the average of the number of laps run up to 5 laps and then continues to roll-over the most recent 5 laps.


Finally the circuit names were converted from the original extended format to the common usage shorthand names and changed to all lower case. For example, changing ‘SPA FRANCORCHAMPS’ to simply ‘spa’..

The column 'crossing_finish_line_in_pit' holds NaN values for any laps that crossed start-finish on track and a 'B' character for a lap finished in pitlane. The values are replaced with 0 for laps on track and 1 for laps in pit.

Finally the 'flag_at_fl' column was dropped as data only exists starting with the 2022 season.

## The Machine Learning Notebook
### Data Cleaning

The data included many columns that would not be usable by the machine learning models. Some were eliminated based on redundancy (ex: multiple format versions of laptimes and sector times), others based on the type of data not being needed (driver, team, and car manufacturer names for example). All data for years prior to 2017 was also dropped since our target data for these years does not exist.

The percentage of NaN values in all columns was checked, as well as the percentage of laps finished in pitlane (commonly known as in-laps). Only a small percentage of NaNs were found and it was determined they could be safely dropped from the working data. The in-lap data unfortunately complicates the process of trimming outliers from the lap time data and so the choice was taken to drop these records. In theory, the in-lap data could be useful to a model. Under normal circumstances an in-lap would be run on old tires, and a driver who can run a faster in-lap than their rivals may be able to gain positions or time on a competitor, thus suggesting they are a more skilled driver. However a car that has had an issue on track will also have an abnormally slow in-lap as it limps back to the pitlane. 

Next the data was checked for outliers in the laptime data. First the shortest laptime existing in the data was checked to ensure that it was a realistic time and not some errant value of an impossibly short lap. Then the IQR (interquartile range) was calculated and an upper limit was set; all laptimes above this limit were removed. In this process the data was grouped by both circuit and class, as laptimes vary by several minutes between the longest and shortest circuits and faster or slower classes. The record containing the remaining longest laptime was checked to ensure that we are not dropping too many records from the data. The longest remaining laptime was 261 seconds or a laptime of 4:35.000 for a GTE at Le Mans, a slow lap to be sure but not one that indicates an artificial delay (such as a significant accident).

### Transforming and Encoding

The data was now split into several DataFrames separating the continuous and discrete numerical columns, the object value columns, and the target data columns to allow for transformations and encoding. Each of the feature columns would be re-joined together at a later step in the process.

The object columns were one-hot encoded using the pandas get_dummies() function, which adds a new column for each unique value in the original column. A value of 1 is entered for rows where the column value is present, and the other 'dummy' columns are filled with a 0 value for that row. The .get_dummies()/OneHotEncoder method can lead to dimensionality issues in some datasets where there are many unique values in encoded columns; in thiscase with only 5 possible classes and 12 different circuits the number of new columns created is acceptable.

The continuous numerical features werescaled to allow the ML models to more accurately interpret the values. When feature columns have different scales, the features with larger scales can be interpreted by the model to have a greater importance and a greater impact on the model output. This can result in biased model performance and lead to poor model accuracy. In an attempt to find the best possible scaling method for this purpose, I devised a function to apply several different methods (MinMaxScaler, StandardScaler, and MaxABSScaler) and return a list (scales) of the three different scaled DataFrames. The discrete numerical features require no transformations and can be left alone to be concatenated with the encoded and scaled data. At this point I will concatenate the features using the StandardScaled data for baseline model testing purposes.

### Fitting and Evaluating Models

With the initially assembled features DataFrame we will next perform a train_test_split function. This will randomly divide both the feature and target DataFrames into a set for training the model and a separate set for testing the accuracy of the model. In this case we have used the default values which reserves 25% of the data for the testing set, the remaining 75% will be used for training the model. The train_test function was used with the random_state argument, which controls the random shuffling of the data when splitting. Using the same random_state value ensures that subsequent splitting operations (such as when we test the models with other versions of the scaled data) will result in the same selection of records going to each side of the split. This allows for accurate comparison of multiple model runs as they are trained and tested on the same selections of data.

In this project we will be testing two different classification algorithms; the Random Forest Classifier (RFC) and the K Nearest Neighbors Classifier (KNN). The Random Forest Classifier is an ensemble learning method that creates multiple decision trees, each trained on a random subset of the training data. The predictions of the model are based on the most popular result across all of the individual trees in the ensemble. The K Nearest Neighbors classifier works by grouping data points based on the K value of nearest neighboring points. The classifier operates on a distance metric to determine the similarity between data points.
The next step taken was fitting an initial run of both model types with default model hyperparameters and using the initial train_test_split made in the previous step. The scores of these initial runs informed further steps taken to increase accuracy.

The RFC baseline model returned an accuracy score of 0.8933548182107031 or 89% accurate predictions. The KNN models returns an accuracy score of 0.8300349507512143 or 83%.

With the intent of further increasing the model accuracy I performed hyper parameter tuning on both models. Hyper parameter tuning (using the GridSearchCV function) runs multiple iterations of the given model to determine the optimal set of hyperparameters for the model type. The Grid Search function takes a parameter grid argument with a range of values for each of the model's hyperparameters and runs a version of the model with each hyperparameter combination. The Grid Search  checks the accuracy of each iteration and eventually returns  the maximum accuracy score and the specific set of hyperparameters used to attain it. The returned dictionary of hyperparameter values can then be called in further functions to train a final version of our model for eventual production use.
With our returned sets of hyperparameter values we can now run our final tests which leads to the final version of the model. The test_models_scales function takes as arguments: The scales list containing three versions of scaled continuous features, the models list containing RandomForest and KNeighbors model items, the knn_best_params dictionary, and finally the rfc_best_params dictionary. 

The function runs each model (with its best parameters) once for each of the three scaled data sets and prints out the model name and each scaler name with the reported accuracy score.

We now have the optimal model type, its optimal parameters, and the scaler type that returns the best possible accuracy for our training data. Using these features we can fit a final version of the model for serialization and deployment. This model will be stored and saved to be applied against future data.

### What we have learned

The high accuracy results of our model have shown that the FIA ratings system has been overall very effective at its intended task, the system has successfully grouped drivers of similar skill levels into the Bronze, Silver, Gold and Platinum classes. While there has been some debate among race competitors and organizers about the implementation of this rating system, and the assignment of individual ratings, the high level of accuracy achieved by the model provides strong evidence that it can be a valuable tool to create fair competition in the pro-am racing world. Ultimately, the success of the rating system in accurately categorizing drivers should help to promote greater fairness and transparency in racing competitions going forward. Perhaps by applying a similar model into their judgements the FIA can lend greater transparency and consistency to the ratings assignment in the future in addition to the primarily achievements based system that is currently in use today. 










