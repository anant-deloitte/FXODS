{{ config(materialized='table') }}

with source_data as (

    select * from ITSS_AP.AP_EXPENSE_REPORT_LINES_ALL

)