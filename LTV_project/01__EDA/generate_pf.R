library(lubridate)

kHomeDirectory <- Sys.getenv("HOME")

source(file.path(kHomeDirectory, "work/data_analysis/rscripts/predictions/pre_processing/pre_processing.R"))
source(file.path(kHomeDirectory, "work/data_analysis/rscripts/UtilityFunctions.R"))
source(file.path(kHomeDirectory, "work/data_analysis/rscripts/predictions/PredictionFrame.R"))
source(file.path(kHomeDirectory, "work/data_analysis/rscripts/intermediate_representation/UtilityFunctions.R"))

irSchema <- kCANDYWRITER_LS_IOS


predictionStartJoinDateTime <- strptime('2017-06-07 00:00:00',format='%Y-%m-%d %H:%M:%S')
predictionEndJoinDateTime <- strptime('2017-08-09 00:00:00',format='%Y-%m-%d %H:%M:%S')

Candy_d1PredictionFrame <- GenerateHourNPredictionFrame(
  schema = irSchema, 
  segments = 'Everyone', 
  assigned_identity = TRUE,
  join_start_datetime_utc = predictionStartJoinDateTime, 
  join_end_datetime_utc = predictionEndJoinDateTime,
  attributes = ALL_ATTRIBUTES,
  ambient_device_info = TRUE, 
  dma_info = TRUE, 
  first_n_hours_history = 24,
  first_n_days = 30,
  max_users = 1000000,
  payment_wall_views_outcome = FALSE, 
  remove_users_without_payment_wall_views = FALSE, 
  remove_non_returning_users = FALSE, 
  number_cores = 8
)


response <- "out_ltv"
treatment <- 'treatment'

Candy_d1_clean <- TransformCleanData(Candy_d1PredictionFrame, response = response, 
                                                                     treatment = treatment,
                                                                     factors_to_binary = TRUE, 
                                                                     common_prop = 0.01,
                                                                     include_column_info = TRUE)

Candy_d1_clean_rm_whale <- RemoveOutliers(Candy_d1_clean, response = response, 
                                          treatment = treatment, 
                                          by_treatment = TRUE,
                                          truncate = TRUE,
                                          top_percent_to_remove = 0.02)

write.csv(Candy_d1_clean_rm_whale, file = "~/work/data/clean_testing_Candy.csv")

# write.csv(candy_d1PredictionFrame, file = "~/work/data/testing_candy.csv")
