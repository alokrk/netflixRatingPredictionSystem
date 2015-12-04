# Sample code to test accuracy of model by calculation of RMSE

source("Leave_one_out.R")
source("Rating_Prediction.R")

# sample movie and and user arrays
id_list<-c(1488844,699878,2625420, 2173336, 950515, 41412, 1224344,846887,1265764,1624421)

m_ids<-c(1,10,20,30,40,50,60,70,80,90)

original_ratings<-c(3,2,2,5,4,3,1,1,1,3)

prediction_array<-c()

#computing prediction made after executing Leave one out and Rating Prediction
for(i in 1:10)
{
  Leave_one(m_ids[i],id_list[i])
  temp<-Rating_Prediction(m_ids[i],id_list[i])
  prediction_array<-c(prediction_array,(round(temp)))
}

rmse<-0

for(j in 1:10)
{
  rmse<-rmse+((prediction_array[j]- original_ratings[j])*(prediction_array[j]- original_ratings[j]))
}

final_rmse<- sqrt(rmse/10)

