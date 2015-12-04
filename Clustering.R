# Netflix Rating Prediction 
# Clustering of sets of similar users and sets of similar movies 

# Import the gdata library to extract excel file in R
library(gdata)
help("read.xls")

# Import data from Movie titles file and store in Movie_Titles
Movie_Titles<-read.xls("C:/Users/Kartikeya/Desktop/ALDA Project/movie_titles_small.xls",header= F,perl = "C:/Perl64/bin/perl.exe")
names(Movie_Titles)<- c("Movie_ID","Release_Year","Movie_Title")

# Import data from training set to achieve a summary table of user and
# movie information. The parameters chosen for clustering of similar
# movie include - Average, Standard Deviation, Number of Ratings. Similarly,
# the parameters chosen for clustering similar users include - Average
# user rating, standard deviation of rating and Average date difference (On
# an average when the user rates a movie afters its release)
setwd("C:/Users/Kartikeya/Desktop/ALDA Project/Dataset/training_set_small/")
files_list<- list.files()

# Counter initialized for movie IDs 
i<-1

# Empty array for storing IDs of all the users who have rated the movie
user_summary<-c()

# A dataframe to store the values of user summary table 
user_info_summary<-data.frame(User_ID=double(),Number_of_ratings=double(),Sum_of_Ratings=double(),Square_Sum_Ratings=double(),Date_Difference=double())

# Iterating through each file in the training data
for(file in files_list)
{
  
# Computation for movie summary starts here
  
# Initializing variables
# dataset: skipping the first line of txt file which contains the movie id
# ratings: extract column 2 of the excel
# average: take average of ratings- average movie rating
# standard deviation: calculate standard deviation of rating for movie
# calculate popularity of the movie, by calculating number of ratings

  dataset<-read.table(text=readLines(file)[-1],header=FALSE,sep=",")
  ratings<-dataset[,c(2)]
  average<-mean(ratings)
  standard_deviation<-sd(ratings)
  number<-length(ratings)
  
# If no Movie_Summary table exists, create one with the current values  
  if(!exists("Movie_Summary"))
  {
    Movie_Summary<-data.frame(Movie_ID=i,Average_Movie_Rating=average,Standard_Deviation=standard_deviation,Number_of_Ratings=number)
  }
  
# If there exists a Movie_Summary table bind the next movie row to the dataframe
  else if(exists("Movie_Summary"))
  {
    
    Movie_Summary_temp<-data.frame(Movie_ID=i,Average_Movie_Rating=average,Standard_Deviation=standard_deviation,Number_of_Ratings=number)
    Movie_Summary<-rbind(Movie_Summary,Movie_Summary_temp)
    rm(Movie_Summary_temp)
  }
  

# Computation for User Summary starts here
  
# taking into consideration all the users who have rated the current movie
# extracting the column 1 for the txt movie file
  user_id<-dataset[,c(1)]

# running a loop going through all the users
  for(j in 1:number){
    
# checking to see if that user is already present in the user summary data frame
    if(!is.element(user_id[j],user_summary)){
      
# difference of dates calculated: when the user has rated the movie after its 
# release
      release_year<- Movie_Titles[,c(2)]
      rating_year<- substr(dataset[,c(3)],1,4)
      difference=strtoi(rating_year[j])-release_year[i]

# Appending to user summary array and the user information table      
      user_summary<-append(user_summary,user_id[j])
      user_info_summary_temp<-data.frame(User_ID=user_id[j],Number_of_ratings=1,Sum_of_Ratings=ratings[j],Square_Sum_Ratings=ratings[j]^2,Date_Difference=difference)
      user_info_summary<-rbind(user_info_summary,user_info_summary_temp)
      rm(user_info_summary_temp)

    }
    
# the user exists in the summary table update the values for theat row in 
# the table
    else{
    
      release_year<- Movie_Titles[,c(2)]
      rating_year<- substr(dataset[,c(3)],1,4)
      difference=strtoi(rating_year[j])-release_year[i]
      
      user_info_summary$Number_of_ratings[user_info_summary$User_ID == user_id[j]]<- user_info_summary$Number_of_ratings[user_info_summary$User_ID == user_id[j]]+1
      user_info_summary$Sum_of_Ratings[user_info_summary$User_ID == user_id[j]]<- user_info_summary$Sum_of_Ratings[user_info_summary$User_ID == user_id[j]] + ratings[j]
      user_info_summary$Square_Sum_Ratings[user_info_summary$User_ID == user_id[j]]<- user_info_summary$Square_Sum_Ratings[user_info_summary$User_ID == user_id[j]] + ratings[j]^2
      user_info_summary$Date_Difference[user_info_summary$User_ID == user_id[j]]<- user_info_summary$Date_Difference[user_info_summary$User_ID == user_id[j]] + difference
      
    }
    
  }
  
# Incrementing to move to the next movie in the file
  i<-i+1

# Removing all the temporary variables
  rm(dataset)
  rm(ratings)
  rm(average)
  rm(standard_deviation)
  rm(number)
  rm(release_year)
  rm(rating_year)
  rm(difference)
}


# Adding three columns to the table: Average user rating, standard Deviation,
# and Average date difference

user_info_summary[c("Avg_User_Rating","Std_Rating","Avg_Date_Difference")]<-NA
length_user_info_summary<-length(user_summary)

# Running through the user info summary table to append these three columns,
# after computation

for(i in 1:length_user_info_summary){
  
  no_of_ratings<-user_info_summary[i,"Number_of_ratings"]
  sum_of_ratings<-user_info_summary[i,"Sum_of_Ratings"]
  square_sum<-user_info_summary[i,"Square_Sum_Ratings"]
  date_diff<-user_info_summary[i,"Date_Difference"]
  
  avg_user_rating<- sum_of_ratings/no_of_ratings

# Setting Standard Deviation to 0 if there is only one rating by the user  
  if(no_of_ratings==1){
    std_rating=0
  }
  
  else{
    std_rating<-sqrt((square_sum-(no_of_ratings*((avg_user_rating)^2)))/(no_of_ratings-1))
  }
  
  avg_date_diff<- date_diff/no_of_ratings
  
  user_info_summary$Avg_User_Rating[user_info_summary$User_ID == user_summary[i]]<- avg_user_rating
  user_info_summary$Std_Rating[user_info_summary$User_ID == user_summary[i]]<- std_rating
  user_info_summary$Avg_Date_Difference[user_info_summary$User_ID == user_summary[i]]<- avg_date_diff
  

# Removing all temporary variables
  rm(no_of_ratings)
  rm(sum_of_ratings)
  rm(square_sum)
  rm(date_diff)
  rm(avg_date_diff)
}

# K- means clustering: Choosing cluster size for movies as 10 and for users
# is 1000

(Movie_cluster<-kmeans(Movie_Summary[,c(2,3,4)],10))

(User_cluster<-kmeans(user_info_summary[,c(2,6,7,8)],1000, iter.max = 100))


