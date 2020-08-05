project_name: "campaign_manager_block"


# **** Please insert CM Network ID below. *****
constant: cm_network_id {
  value: ""
}

### DV360 Constants

constant: dv360_partner_id {
  ## This is used for links
  value: ""
}

constant: historical_data_dv360 {
  ### This is where you can decide how much data to feed into the dashboards. By default, it is 60 days
  value: "60"
}

constant: number_of_clusters {
  ### This is where you can decide number of clusters for BQML. Default is 3
  value: "3"
}

constant: minimum_spend_cluster {
  ### This is where you can decide minimum spend (exclusive) for campaigns to include in clustering model. Default is >0, so all campaigns with spend >0
  ## To include all, make value: ""
  value: ">0"
}

constant: minimum_conversions_cluster {
  ### This is where you can decide minimum number of conversions (exclusive) for campaigns to include in clustering model. Default is 0, so all campaigns with conversions >0
   ## To include all, make value: ""
  value: ">0"
}
