# netflixRatingPredictionSystem
Creation of a prediction system to predict rating of a movie by a user.
## To run the code:
###1.Download the dataset [training_set_small] and [movie_titles_small] from the google drive.
Change the path to your local path to movie_titles_small.xls and training_set_small in the following places.
In Clustering.R  9th line:

**Movie_Titles<-read.xls("C:/Users/Kartikeya/Desktop/ALDA Project/movie_titles_small.xls",header= F,perl = "C:/Perl64/bin/perl.exe")**

18th line:

**setwd("C:/Users/Kartikeya/Desktop/ALDA Project/Dataset/training_set_small/")**

In Leave_one_out.R 9th line:

**setwd("C:/Users/Kartikeya/Desktop/ALDA Project/Dataset/training_set_small/")**

In Rating_prediction.R, 44th line:

**setwd("C:/Users/Kartikeya/Desktop/ALDA Project/Dataset/training_set_small/")**

###2.Install perl on your computer  
In Clustering.R,the 9th line:

**Movie_Titles<-read.xls("C:/Users/Kartikeya/Desktop/ALDA Project/movie_titles_small.xls",header= F,perl = "C:/Perl64/bin/perl.exe")**

Change the path for perl to your local path.
###3. Run Clustering.R
###4. Run Test_RMSE.R
