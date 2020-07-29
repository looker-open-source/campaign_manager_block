view: match_table_cities {
  sql_table_name: (select * from `db-platform-sol.Comcast8667.match_table_cities_8667` where _LATEST_DATE = _DATA_DATE) ;;

    dimension: city {
      type: string
      sql: ${TABLE}.City ;;
    }

    dimension: city_id {
      type: string
      sql: ${TABLE}.City_ID ;;
    }

    measure: count {
      type: count
      approximate_threshold: 100000
      drill_fields: []
    }
  }
