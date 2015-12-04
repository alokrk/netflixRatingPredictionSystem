# netflixRatingPredictionSystem
Creation of a prediction system to predict rating of a movie by a user.
## To run the code:
###1.Download the dataset from the google drive.
In Clustering.R 
and Prediction.R
chang the path to your local path to movie_titles_small.xls and training_set_small.
###2.Install perl on your computer  
In Clustering.R,the 9th line:

**Movie_Titles<-read.xls("C:/Users/Kartikeya/Desktop/ALDA Project/movie_titles_small.xls",header= F,perl = "C:/Perl64/bin/perl.exe")**

Change the path for perl to your local path.
###3. Run Clustering.R
###4. Test_RMSE.R
