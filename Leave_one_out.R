# Leave one out function (taking inputs of movie-user pair: to compute 
# efficiency of our model

Leave_one<- function(final_movie_id,final_user_id){
  
  Movie_Summary_temp<- Movie_Summary
  user_info_summary_temp<- user_info_summary
  
  setwd("C:/Users/Kartikeya/Desktop/ALDA Project/Dataset/training_set_small/")
  files_list<- list.files()
  i<-1
  
# Running through the training data to remove form the summary tables of users
# and movies to remove their entries from the tables. After which new clusters
# are formed which excludes them
  
  for(file in files_list){
    
    if(i==final_movie_id){
      dataset<-read.table(text=readLines(file)[-1],header=FALSE,sep=",")
      
      temp<-match(final_user_id,dataset[,c(1)],nomatch = -1)
      
      if(temp != -1){
        user_ratings<-dataset[,c(2)]
        user_ratings1<-user_ratings[temp]
        
        col<-dataset[,c(3)]
        date_temp<-col[temp]
        release_year<- Movie_Titles[,c(2)]
        rating_year<- substr(date_temp,1,4)
        difference=strtoi(rating_year)-release_year[i]
        
        
        user_info_summary_temp$Number_of_ratings[user_info_summary_temp$User_ID==final_user_id]<-(user_info_summary_temp$Number_of_ratings[user_info_summary_temp$User_ID==final_user_id])-1
        user_info_summary_temp$Sum_of_Ratings[user_info_summary_temp$User_ID==final_user_id]<-(user_info_summary_temp$Sum_of_Ratings[user_info_summary_temp$User_ID==final_user_id])-user_ratings1
        
        user_info_summary_temp$Square_Sum_Ratings[user_info_summary_temp$User_ID==final_user_id]<-(user_info_summary_temp$Square_Sum_Ratings[user_info_summary_temp$User_ID==final_user_id])-(user_ratings1^2)
        user_info_summary_temp$Date_Difference[user_info_summary_temp$User_ID==final_user_id]<-(user_info_summary_temp$Date_Difference[user_info_summary_temp$User_ID==final_user_id])-difference
        user_info_summary_temp$Avg_User_Rating[user_info_summary_temp$User_ID==final_user_id]<-(user_info_summary_temp$Sum_of_Ratings[user_info_summary_temp$User_ID==final_user_id])/(user_info_summary_temp$Number_of_ratings[user_info_summary_temp$User_ID==final_user_id])
        user_info_summary_temp$Std_Rating[user_info_summary_temp$User_ID==final_user_id]<-sqrt(((user_info_summary_temp$Square_Sum_Ratings[user_info_summary_temp$User_ID==final_user_id])-((user_info_summary_temp$Number_of_ratings[user_info_summary_temp$User_ID==final_user_id])*((user_info_summary_temp$Avg_User_Rating[user_info_summary_temp$User_ID==final_user_id])^2)))/((user_info_summary_temp$Number_of_ratings[user_info_summary_temp$User_ID==final_user_id])-1))
        user_info_summary_temp$Avg_Date_Difference[user_info_summary_temp$User_ID==final_user_id]<-(user_info_summary_temp$Date_Difference[user_info_summary_temp$User_ID==final_user_id])/(user_info_summary_temp$Number_of_ratings[user_info_summary_temp$User_ID==final_user_id])
        
        dataset<- dataset[-temp,]  
        ratings<-dataset[,c(2)]
        number<-length(ratings)
        average<-mean(ratings)
        standard_deviation<-sd(ratings)
        
        
        Movie_Summary_temp$Average_Movie_Rating[Movie_Summary_temp$Movie_ID==i]<-average
        Movie_Summary_temp$Standard_Deviation[Movie_Summary_temp$Movie_ID==i]<-standard_deviation
        Movie_Summary_temp$Number_of_Ratings[Movie_Summary_temp$Movie_ID==i]<-number
        
        
      }
      
    }
    
    i<-i+1
  }
  
# K-Means Clustering: After removing the current user and movie
  
  (Movie_cluster<-kmeans(Movie_Summary_temp[,c(2,3,4)],10))
  (User_cluster<-kmeans(user_info_summary_temp[,c(2,6,7,8)],1000, iter.max = 100))
  
# Removing temporary variables 
  
  rm(Movie_Summary_temp)
  rm(user_info_summary_temp)
}
