# # Here are some potentially good features for this model.
# # For now the goal will be to cluster the user information to see what kinds of users are actually seeing our ads.
# # For user information:
# # DBM_Site_ID, DBM_Language, DBM_Adx_Page_Categories, DBM_Country_Code,
# # DBM_Designated_Market_Area_DMA_ID, DBM_ZIP_Postal_Code, DBM_State_Region_ID, DBM_City_ID,
# # DBM_Operating_System_ID, DBM_Browser_Platform_ID, DBM_Device_Type

# # For impression information:
# # DBM_Bid_Price_USD (bid), DBM_Media_Cost_USD (actual),
# # DBM_Revenue_USD,DBM_Total_Media_Cost_USD, DBM_Exchange_ID,
# # DBM_Attributed_Inventory_Source_Is_Public, DBM_Ad_Position

# datagroup: bqml_datagroup {
#   sql_trigger: select CURRENT_DATE() ;;
#   max_cache_age: "24 hours"
# }


# view: user_clustering_data {
#   derived_table: {
#     # This table needs a unique primary key for us to be able to join upon.
#     #Would be nice to have this in LookML format
#     #I would recommend using some of the time-based information (day of week, hour of day, etc.) in the model, and perhaps removing some other categorical fields.
#     sql: Select TIMESTAMP_MICROS(Event_Time) as event_time
#             ,DBM_Site_ID
#             , DBM_Language
#             , DBM_Adx_Page_Categories
#             , DBM_Country_Code
#             , DBM_Designated_Market_Area_DMA_ID
#             , DBM_ZIP_Postal_Code
#             , DBM_State_Region_ID
#             , DBM_City_ID
#             , DBM_Operating_System_ID
#             , DBM_Browser_Platform_ID
#             , DBM_Device_Type
#           FROM ${impression.SQL_TABLE_NAME}
#           WHERE DBM_Line_Item_ID is not null
#           limit 10000;;
#   }
#   # NEED TO Add metrics on averages of values used in the model
#   measure: count {
#     type: count
#     drill_fields: [detail*]
#   }

#   dimension_group: event {
#     type: time
#     #This might come in handy later.
#     timeframes: [raw,time,date,day_of_week_index, hour_of_day]
#     sql: ${TABLE}.event_time ;;
#   }

#   dimension: dbm_site_id {
#     type: string
#     sql: ${TABLE}.DBM_Site_ID ;;
#   }

#   dimension: dbm_language {
#     type: string
#     sql: ${TABLE}.DBM_Language ;;
#   }

#   dimension: dbm_adx_page_categories {
#     type: string
#     sql: ${TABLE}.DBM_Adx_Page_Categories ;;
#   }

#   dimension: dbm_country_code {
#     type: string
#     sql: ${TABLE}.DBM_Country_Code ;;
#   }

#   dimension: dbm_designated_market_area_dma_id {
#     type: string
#     sql: ${TABLE}.DBM_Designated_Market_Area_DMA_ID ;;
#   }

#   dimension: dbm_zip_postal_code {
#     type: string
#     sql: ${TABLE}.DBM_ZIP_Postal_Code ;;
#   }

#   dimension: dbm_state_region_id {
#     type: string
#     sql: ${TABLE}.DBM_State_Region_ID ;;
#   }

#   dimension: dbm_city_id {
#     type: string
#     sql: ${TABLE}.DBM_City_ID ;;
#   }

#   dimension: dbm_operating_system_id {
#     type: string
#     sql: ${TABLE}.DBM_Operating_System_ID ;;
#   }

#   dimension: dbm_browser_platform_id {
#     type: string
#     sql: ${TABLE}.DBM_Browser_Platform_ID ;;
#   }

#   dimension: dbm_device_type {
#     type: number
#     sql: ${TABLE}.DBM_Device_Type ;;
#   }

#   set: detail {
#     fields: [
#       dbm_site_id,
#       dbm_language,
#       dbm_adx_page_categories,
#       dbm_country_code,
#       dbm_designated_market_area_dma_id,
#       dbm_zip_postal_code,
#       dbm_state_region_id,
#       dbm_city_id,
#       dbm_operating_system_id,
#       dbm_browser_platform_id,
#       dbm_device_type
#     ]
#   }
# }


# view: user_clustering_model {
#   derived_table: {
#     datagroup_trigger: bqml_datagroup
#     sql_create:
#       CREATE OR REPLACE MODEL
#       ${SQL_TABLE_NAME} OPTIONS(model_type='kmeans', num_clusters=4) AS
#       SELECT
#         *  EXCEPT(event_time)
#       FROM ${user_clustering_data.SQL_TABLE_NAME};;
#   }
# }

# view: user_clustering_model_evaluate {
#   #This table only has one row with two numbers. Would be good on a dashboard with other metrics on the centroids.
#   derived_table: {
#     sql: SELECT * FROM ml.EVALUATE(
#       MODEL ${user_clustering_model.SQL_TABLE_NAME}) ;;
#   }
#   dimension: davies_bouldin_index {
#     description: "A measure of how good your clusters are: A smaller number indicates the clusters are more differentiated, meaning a good fit."
#     type: number
#     sql: ${TABLE}.davies_bouldin_index ;;
#   }
#   dimension: mean_squared_distance {
#     description: "A measure of how good your clusters are: A smaller number indicates the members of a cluster are more similar, meaning a good fit."
#     type: number
#     sql: ${TABLE}.mean_squared_distance ;;
#   }
# }

# explore: user_clustering_predict {}
# view: user_clustering_predict {
#   extends: [user_clustering_data]
#   #This table will have all the same dimensions as the original, plus what I've included below.
#   #While we could join it back to the original data, it also makes sense to just explore it on its own.
#   derived_table: {
#     sql: SELECT * FROM ml.PREDICT(
#           MODEL ${user_clustering_model.SQL_TABLE_NAME},
#           (SELECT *  EXCEPT(event_time)
#             FROM ${user_clustering_data.SQL_TABLE_NAME}));;
#   }
#   dimension: centroid_id {
#     description: "Which cluster this data point is closest to. In other words: to which 'group' does this data point belong?"
#     type: number
#     sql: ${TABLE}.centroid_id ;;
#   }

#   dimension: centroid_distance {
#     description: "What the distance is to the nearest cluster's center. In other words: how much like this 'group' is this data point? (lower is better fit)"
#     type: number
#     sql:  ${TABLE}.NEAREST_CENTROIDS_DISTANCE[OFFSET(0)].DISTANCE ;;
#   }

#   measure: average_centroid_distance {
#     description: "How close are these data points to their nearest clusters' centers. In other words: How well do these data points fit into their respective 'groups'? (lower is better fit) "
#     type: average
#     sql: ${centroid_distance} ;;
#   }

# }




# # JUST THE RAW SQL CODE SO THAT IT IS NOT LOST
# # -- Select  DBM_Site_ID
# # --             , DBM_Language
# # --             , DBM_Adx_Page_Categories
# # --             , DBM_Country_Code
# # --             , DBM_Designated_Market_Area_DMA_ID
# # --             , DBM_ZIP_Postal_Code
# # --             , DBM_State_Region_ID
# # --             , DBM_City_ID
# # --             , DBM_Operating_System_ID
# # --             , DBM_Browser_Platform_ID
# # --             , DBM_Device_Type
# # --           FROM  `db-platform-sol.Comcast8667.p_impression_8667`
# # --           WHERE DBM_Line_Item_ID is not null
# # --           limit 10000
# #
# #
# #
# #
# # -- CREATE OR REPLACE MODEL
# # --       `db-platform-sol.Comcast8667.user_clustering_model` OPTIONS(model_type='kmeans', num_clusters=4) AS
# # --       Select  DBM_Site_ID
# # --             , DBM_Language
# # --             , DBM_Adx_Page_Categories
# # --             , DBM_Country_Code
# # --             , DBM_Designated_Market_Area_DMA_ID
# # --             , DBM_ZIP_Postal_Code
# # --             , DBM_State_Region_ID
# # --             , DBM_City_ID
# # --             , DBM_Operating_System_ID
# # --             , DBM_Browser_Platform_ID
# # --             , DBM_Device_Type
# # --           FROM  `db-platform-sol.Comcast8667.p_impression_8667`
# # --           WHERE DBM_Line_Item_ID is not null
# # --           limit 10000
# #
# #
# # -- SELECT * FROM ml.EVALUATE(
# # --           MODEL `db-platform-sol.Comcast8667.user_clustering_model`)
# # --           limit 500
# #
# # -- SELECT * FROM ml.PREDICT(
# # --           MODEL `db-platform-sol.Comcast8667.user_clustering_model`,
# # --           (Select  DBM_Site_ID
# # --             , DBM_Language
# # --             , DBM_Adx_Page_Categories
# # --             , DBM_Country_Code
# # --             , DBM_Designated_Market_Area_DMA_ID
# # --             , DBM_ZIP_Postal_Code
# # --             , DBM_State_Region_ID
# # --             , DBM_City_ID
# # --             , DBM_Operating_System_ID
# # --             , DBM_Browser_Platform_ID
# # --             , DBM_Device_Type
# # --           FROM  `db-platform-sol.Comcast8667.p_impression_8667`
# # --           WHERE DBM_Line_Item_ID is not null
# # --           limit 10000))
# # --           limit 500
