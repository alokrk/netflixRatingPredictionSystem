# Function which can be used to predict the rating to one movie given by 
# one user.

Rating_Prediction <- function(final_movie_id,final_user_id){

# Retrieving index and clusters of the movies and users 
Movie_cluster_index<-Movie_cluster[[1]]
User_cluster_index<-User_cluster[[1]]

length_movie_index<-length(Movie_cluster_index)

# Initializing similar movie array
similar_movie<-c()

# Retrieving all the similar movies in one similar movie array
for(i in 1:length_movie_index ){

  if(Movie_cluster_index[[i]]== Movie_cluster_index[[final_movie_id]]){
    
    similar_movie<-append(similar_movie,i)
  }
}

length_user_index<-length(User_cluster_index)
similar_user<-c()

# Retrieving user id index to use later to compare with index in simlar user
# array
for(i in 1:length_user_index){
  if(user_summary[i]==final_user_id){
    Final_user<-i
  }
}

# Retrieving simlar users list in an array
for(j in 1:length_user_index){
  
  if(User_cluster_index[[j]]==User_cluster_index[[Final_user]]){
    
    similar_user<-append(similar_user,user_summary[j])
  }
}

setwd("C:/Users/Kartikeya/Desktop/ALDA Project/Dataset/training_set_small/")
files_list<- list.files()

i<-1
length_similar_movies<-length(similar_movie)
sum<-0
count<-0
length_similar_users<-length(similar_user)
Prediction_table<-data.frame(Movie_ID=double(),Sum_of_Ratings=double(),Number_of_Ratings=double(),Rating_Deviation=double())

# Running through all the files in the training dataset to implement 
# the prediction algorithm developed, as mentioned in the Report

for(file in files_list){

# Running through only the similar movies  
  for(j in 1:length_similar_movies){
   
    if(i==similar_movie[j]){
      dataset<-read.table(text=readLines(file)[-1],header=FALSE,sep=",")
      users<-dataset[,c(1)]
      ratings<-dataset[,c(2)]
      

      for(k in 1:length_similar_users){

# Computation done if there is match between users and the similar users  
        num<-match(similar_user[k],users, nomatch = -1)
        if(num != -1){
        sum<-sum+ratings[num]
        count<-count+1
        }
      }
      
      num1<-match(final_user_id,users,nomatch=-1)
      if(num1 != -1){
        diff<- ratings[num1]- (sum/count)
      }
      else
      {
        diff<-0
      }
      
      Prediction_table_temp<-data.frame(Movie_ID=i,Sum_of_Ratings=sum,Number_of_Ratings=count,Rating_Deviation=diff)
      Prediction_table<-rbind(Prediction_table,Prediction_table_temp)
      }
  }
  
  i<-i+1
  }


Length_Prediction_table<-length(Prediction_table[,c(1)])
Sum_Correction<-0

# Correction factor based on user behaviour
for(i in 1:Length_Prediction_table){

  Sum_Correction<- Sum_Correction + Prediction_table[i,"Number_of_Ratings"]* Prediction_table[i,"Rating_Deviation"]
}

Final_Rating<- (sum(Prediction_table[,c(2)])/sum(Prediction_table[,c(3)])) + (Sum_Correction/sum(Prediction_table[,c(3)]))

# returning the final rating of the movie by user
return (round(Final_Rating))
}