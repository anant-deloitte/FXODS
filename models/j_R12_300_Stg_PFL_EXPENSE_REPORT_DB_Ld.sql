WITH STG_PFL_EXP_RPT as 
(
    --j_R12_300_Stg_PFL_EXPENSE_REPORT_DB_Ld
    SELECT
        REPORT_LINE_ID,
        DISTRIBUTION_LINE_NUMBER,
        AMOUNT,
        CURRENCY_CODE,
        RECEIPT_CURRENCY_AMOUNT,
        DAILY_AMOUNT,
        WEB_PARAMETER_ID,
        CATEGORY_CODE,
        SUBMITTED_AMOUNT,
        ORG_ID,
        ITEMIZATION_PARENT_ID,
        CODE_COMBINATION_ID,
        REPORT_HEADER_ID 
        --TABLE_TXN_SEQ_NO,
        --DB_TXN_SEQ_NO,
        --LOAD_DT,
        --OPERATION,
        --DS_PROCESSED,
        --REPROCESS_COUNTER
        FROM  {{ ref('STG_ODS_AP_EXP_RPT_LINES_ALL') }} LIMIT 1000
      /*  ( SELECT STG.*,  row_number() over( order by DB_TXN_SEQ_NO) row_number FROM ODS.ITSS_AP.AP_EXPENSE_REPORT_LINES_ALL STG
        WHERE DS_PROCESSED = 0   and OPERATION <> 'NA'
        ) */
)

select * from STG_PFL_EXP_RPT