view: match_table_operating_systems_8667 {
#   sql_table_name: `db-platform-sol.Comcast8667.match_table_operating_systems_8667` ;;
# De-Duping
  derived_table: {
    sql: SELECT
          CAST(Operating_System_ID AS INT64) AS Operating_System_ID_key,
          Operating_System
        FROM `db-platform-sol.Comcast8667.match_table_operating_systems_8667`
        GROUP BY Operating_System_ID_key,Operating_System ;;
  }

#   dimension_group: _data {
#     type: time
#     timeframes: [
#       raw,
#       date,
#       week,
#       month,
#       quarter,
#       year
#     ]
#     convert_tz: no
#     datatype: date
#     sql: ${TABLE}._DATA_DATE ;;
#   }

#   dimension_group: _latest {
#     type: time
#     timeframes: [
#       raw,
#       date,
#       week,
#       month,
#       quarter,
#       year
#     ]
#     convert_tz: no
#     datatype: date
#     sql: ${TABLE}._LATEST_DATE ;;
#   }

  dimension: operating_system {
    type: string
    sql: ${TABLE}.Operating_System ;;
  }

  dimension: operating_system_id_key {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.Operating_System_ID_key ;;
  }

}