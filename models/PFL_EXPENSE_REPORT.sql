WITH PFL_EXPENSE_REPORT as 
(

    select * from {{ ref('j_R12_302_PFL_AP_EXPENSE_REPORT_INSERT_DB_Ld') }}
)
select * from PFL_EXPENSE_REPORT
