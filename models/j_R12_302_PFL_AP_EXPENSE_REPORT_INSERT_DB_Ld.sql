WITH PFL_EXPENSE_RPT_INSERT_DB as 
(

    select * from {{ ref('j_R12_301_PFL_AP_EXPENSE_REPORT_DS_Ld_DS_Pfl_Expense_Report') }}
)
select * from PFL_EXPENSE_RPT_INSERT_DB