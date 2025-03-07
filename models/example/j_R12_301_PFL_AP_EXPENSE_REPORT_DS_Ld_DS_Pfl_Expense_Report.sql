{{
	config(
		materialized='incremental',
		table='DS_Pfl_Expense_Report',
		schema='',
		incremental_strategy='append'
	)
}}

With Oci_Tmp_Ods_Ap_Exp_Rpt_Lines_AllOut as (
	/* SubQuery from Source ==>Oci_Tmp_Ods_Ap_Exp_Rpt_Lines_All */
Select 
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
TABLE_TXN_SEQ_NO,
DB_TXN_SEQ_NO,
OPERATION,
BATCH_ID,
REPORT_HEADER_ID,
EMPLOYEE_ID,
WEEK_END_DATE,
EXP_HEADER_VENDOR_SITE_ID,
INVOICE_NUM,
LEDGER_ID,
SOURCE,
MAXIMUM_AMOUNT_TO_APPLY,
PREPAY_NUM,
PAID_ON_BEHALF_EMPLOYEE_ID,
CODE_COMBINATION_ID,
EXPENSE_LINE_CO_CODE,
EXPENSE_LINE_COST_CENTRE,
EXPENSE_LINE_NOMINAL_ACCOUNT,
EXPENSE_LINE_BRANCH_CODE,
EXPENSE_LINE_PRODUCT_CODE,
CO_CODE,
PERSON_ID,
EMPLOYEE_NUMBER,
FULL_NAME,
ap_exp_header_supp_site_id,
OFFICE_HOME_FLAG,
REPORT_HEADER_ID_KEY,
ORG_ID_KEY,
CODE_COMBINATION_ID_KEY,
ORGANIZATION_ID_KEY,
REPROCESS_COUNTER,
SRLNO
 from 
(SELECT mainq.* FROM ( SELECT taerl.report_line_id AS report_line_id, taerl.distribution_line_number AS distribution_line_number, taerl.amount AS amount, taerl.currency_code AS currency_code, taerl.receipt_currency_amount AS receipt_currency_amount, taerl.daily_amount AS daily_amount, taerl.web_parameter_id AS web_parameter_id, taerl.category_code AS category_code, taerl.submitted_amount AS submitted_amount, taerl.org_id AS org_id, taerl.itemization_parent_id AS itemization_parent_id, taerl.table_txn_seq_no AS table_txn_seq_no, taerl.db_txn_seq_no AS db_txn_seq_no, taerl.operation AS operation, taerl.batch_id AS batch_id, aerh.report_header_id AS report_header_id, aerh.employee_id AS employee_id , aerh.week_end_date AS week_end_date, aerh.vendor_site_id AS exp_header_vendor_site_id, aerh.invoice_num AS invoice_num, aerh.set_of_books_id AS ledger_id, aerh.source AS source , aerh.maximum_amount_to_apply AS maximum_amount_to_apply, aerh.prepay_num AS prepay_num, aerh.paid_on_behalf_employee_id AS paid_on_behalf_employee_id, gcc.code_combination_id AS code_combination_id, gcc.segment1 AS expense_line_co_code, gcc.segment2 AS expense_line_cost_centre, gcc.segment3 AS expense_line_nominal_account, gcc.segment4 AS expense_line_branch_code, gcc.segment5 AS expense_line_product_code, gcc.segment1 AS co_code, aerh.employee_id AS person_id, pap.employee_number AS employee_number, pap.full_name AS full_name, aerh.vendor_site_id AS ap_exp_header_supp_site_id, (SELECT max (CASE WHEN vendor_site_code IN ('OFFICE','HOME') THEN 'Y' ELSE ' ' END) office_home_flag FROM ods_per_all_people_f a LEFT JOIN  ITSS_AP.ods_ap_suppliers b ON  a.person_id = b.employee_id LEFT JOIN ITSS_AP.ods_ap_supplier_sites_all c ON b.vendor_id = c.vendor_id WHERE (a.effective_end_date = to_date('31-Dec-4712' ,'DD-Mon-YYYY') OR a.effective_end_date IS NULL ) AND a.person_id=aerh.employee_id AND c.org_id=aerh.org_id ) office_home_flag, aerh.report_header_id AS report_header_id_key, aerh.org_id AS org_id_key, gcc.code_combination_id AS code_combination_id_key, hou.organization_id AS organization_id_key, taerl.reprocess_counter AS reprocess_counter, row_number () OVER (PARTITION BY taerl.report_line_id ORDER BY db_txn_seq_no DESC NULLS LAST) srlno FROM ITSS_AP.tmp_ods_ap_exp_rpt_lines_all taerl LEFT JOIN ITSS_AP.ods_ap_expense_rpt_headers_all aerh ON taerl.report_header_id = aerh.report_header_id AND (aerh.source <> 'NonValidatedWebExpense' OR aerh.workflow_approved_flag IS NULL) AND aerh.source <> 'Both Pay' AND taerl.org_id = aerh.org_id LEFT JOIN ITSS_AP.ods_gl_code_combinations gcc ON taerl.code_combination_id = gcc.code_combination_id LEFT JOIN ITSS_AP.ods_hr_operating_units hou ON hou.organization_id = aerh.org_id LEFT JOIN ITSS_AP.ods_per_all_people_f pap ON aerh.employee_id = pap.person_id AND (pap.effective_end_date = to_date ('31-Dec-4712' ,'DD-Mon-YYYY') OR pap.effective_end_date IS NULL ) WHERE NOT EXISTS (SELECT aerp.parameter_id FROM ITSS_AP.ods_ap_expense_rpt_params_all aerp, ITSS_AP.ods_ap_expense_reports_all aer WHERE aer.report_type = 'Seeded Personal Expense' AND aerp.expense_type_code = 'PERSONAL' AND aer.expense_report_id = aerp.expense_report_id AND taerl.web_parameter_id = aerp.parameter_id) AND ((taerl.itemization_parent_id IS NULL) OR (taerl.itemization_parent_id <> -1) ) ) mainq where srlno = 1)
 ),

DSstgVar_Xfm_ColumnsOut1 as (
	Select 
	CASE WHEN (((CODE_COMBINATION_ID_KEY Is Null) or (ORG_ID_KEY Is Null) or (ORGANIZATION_ID_KEY Is Null) or (REPORT_HEADER_ID_KEY Is Null)) and OPERATION <> 'D') Then 1 Else 0 END  as SvarReject,
	CASE WHEN SvarReject = 1 Then ( CASE WHEN (CODE_COMBINATION_ID_KEY Is Null) Then ' ODS_GL_CODE_COMBINATIONS_KFV.CODE_COMBINATION_ID ' Else '' END) Else NULL  END as SvarCODE,
	CASE WHEN SvarReject = 1 Then ( CASE WHEN (REPORT_HEADER_ID_KEY Is Null) Then ' ODS_AP_EXPENSE_RPT_HEADERS_ALL.REPORT_HEADER_ID WITH FILTER COLUMNS SOURCE <> "NonValidatedWebExpense" OR WORKFLOW_APPROVED_FLAG IS NULL AND SOURCE <> "Both Pay" ' Else '' END) Else NULL END as SvarREPORT,
	CASE WHEN SvarReject = 1 Then ( CASE WHEN (ORG_ID_KEY Is Null) Then ' ODS_AP_EXPENSE_RPT_HEADERS_ALL.ORG_ID ' Else '' END) Else NULL END as SvarORG,
	CASE WHEN SvarReject = 1 Then ( CASE WHEN (ORGANIZATION_ID_KEY Is Null) Then ' ODS_HR_OPERATING_UNITS.ORGANIZATION_ID WITH FILTER COLUMN ODS_PER_ALL_PEOPLE_F.EFFECTIVE_END_DATE = "31-Dec-4712" OR ODS_PER_ALL_PEOPLE_F.EFFECTIVE_END_DATE IS NULL AND ODS_AP_EXP_RPT_LINES_ALL.ITEMIZATION_PARENT_ID IS NULL OR ODS_AP_EXP_RPT_LINES_ALL.ITEMIZATION_PARENT_ID <> -1' Else '' END) Else NULL END as SvarORGANIZATION ,
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
	 TABLE_TXN_SEQ_NO,
	 DB_TXN_SEQ_NO,
	 OPERATION,
	 BATCH_ID,
	 REPORT_HEADER_ID,
	 EMPLOYEE_ID,
	 WEEK_END_DATE,
	 EXP_HEADER_VENDOR_SITE_ID,
	 INVOICE_NUM,
	 LEDGER_ID,
	 SOURCE,
	 MAXIMUM_AMOUNT_TO_APPLY,
	 PREPAY_NUM,
	 PAID_ON_BEHALF_EMPLOYEE_ID,
	 CODE_COMBINATION_ID,
	 EXPENSE_LINE_CO_CODE,
	 EXPENSE_LINE_COST_CENTRE,
	 EXPENSE_LINE_NOMINAL_ACCOUNT,
	 EXPENSE_LINE_BRANCH_CODE,
	 EXPENSE_LINE_PRODUCT_CODE,
	 CO_CODE,
	 PERSON_ID,
	 EMPLOYEE_NUMBER,
	 FULL_NAME,
	 ap_exp_header_supp_site_id,
	 OFFICE_HOME_FLAG,
	 REPORT_HEADER_ID_KEY,
	 ORG_ID_KEY,
	 CODE_COMBINATION_ID_KEY,
	 ORGANIZATION_ID_KEY,
	 REPROCESS_COUNTER,
	 SRLNO 
From Oci_Tmp_Ods_Ap_Exp_Rpt_Lines_AllOut as Oci_Tmp_Ods_Ap_Exp_Rpt_Lines_AllOut),

DSfilr_Lnk_Ds_Pfl_Expense_Report_Insert_2Out as (
	Select 
	SvarReject,
	 SvarCODE,
	 SvarREPORT,
	 SvarORG,
	 SvarORGANIZATION,
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
	 TABLE_TXN_SEQ_NO,
	 DB_TXN_SEQ_NO,
	 OPERATION,
	 BATCH_ID,
	 REPORT_HEADER_ID,
	 EMPLOYEE_ID,
	 WEEK_END_DATE,
	 EXP_HEADER_VENDOR_SITE_ID,
	 INVOICE_NUM,
	 LEDGER_ID,
	 SOURCE,
	 MAXIMUM_AMOUNT_TO_APPLY,
	 PREPAY_NUM,
	 PAID_ON_BEHALF_EMPLOYEE_ID,
	 CODE_COMBINATION_ID,
	 EXPENSE_LINE_CO_CODE,
	 EXPENSE_LINE_COST_CENTRE,
	 EXPENSE_LINE_NOMINAL_ACCOUNT,
	 EXPENSE_LINE_BRANCH_CODE,
	 EXPENSE_LINE_PRODUCT_CODE,
	 CO_CODE,
	 PERSON_ID,
	 EMPLOYEE_NUMBER,
	 FULL_NAME,
	 ap_exp_header_supp_site_id,
	 OFFICE_HOME_FLAG,
	 REPORT_HEADER_ID_KEY,
	 ORG_ID_KEY,
	 CODE_COMBINATION_ID_KEY,
	 ORGANIZATION_ID_KEY,
	 REPROCESS_COUNTER,
	 SRLNO 
From DSstgVar_Xfm_ColumnsOut1 as DSstgVar_Xfm_ColumnsOut1 Where SvarReject = 0),

Lnk_Ds_Pfl_Expense_Report_Insert_2Out as (
	Select 
	REPORT_HEADER_ID as REPORT_HEADER_ID,
	 REPORT_LINE_ID as REPORT_LINE_ID,
	 DISTRIBUTION_LINE_NUMBER as DISTRIBUTION_LINE_NUMBER,
	 AMOUNT as AMOUNT,
	 CURRENCY_CODE as CURRENCY_CODE,
	 RECEIPT_CURRENCY_AMOUNT as RECEIPT_CURRENCY_AMOUNT,
	 DAILY_AMOUNT as DAILY_AMOUNT,
	 WEB_PARAMETER_ID as WEB_PARAMETER_ID,
	 CATEGORY_CODE as CATEGORY_CODE,
	 SUBMITTED_AMOUNT as SUBMITTED_AMOUNT,
	 ORG_ID as ORG_ID,
	 ITEMIZATION_PARENT_ID as ITEMIZATION_PARENT_ID,
	 EMPLOYEE_ID as EMPLOYEE_ID,
	 PAID_ON_BEHALF_EMPLOYEE_ID as PAID_ON_BEHALF_EMPLOYEE_ID,
	 WEEK_END_DATE as WEEK_END_DATE,
	 INVOICE_NUM as INVOICE_NUM,
	 MAXIMUM_AMOUNT_TO_APPLY as MAXIMUM_AMOUNT_TO_APPLY,
	 PREPAY_NUM as PREPAY_NUM,
	 EXP_HEADER_VENDOR_SITE_ID as EXP_HEADER_VENDOR_SITE_ID,
	 LEDGER_ID as LEDGER_ID,
	 SOURCE as SOURCE,
	 EXPENSE_LINE_CO_CODE as EXPENSE_LINE_CO_CODE,
	 EXPENSE_LINE_COST_CENTRE as EXPENSE_LINE_COST_CENTRE,
	 EXPENSE_LINE_NOMINAL_ACCOUNT as EXPENSE_LINE_NOMINAL_ACCOUNT,
	 EXPENSE_LINE_BRANCH_CODE as EXPENSE_LINE_BRANCH_CODE,
	 EXPENSE_LINE_PRODUCT_CODE as EXPENSE_LINE_PRODUCT_CODE,
	 CODE_COMBINATION_ID as CODE_COMBINATION_ID,
	 CO_CODE as COMPANY_CODE,
	 PERSON_ID as PERSON_ID,
	 EMPLOYEE_NUMBER as EMPLOYEE_NUMBER,
	 FULL_NAME as FULL_NAME,
	 ap_exp_header_supp_site_id as SUPPLIER_VENDOR_SITE_ID,
	 CASE WHEN OPERATION = 'D' THEN 'Y' ELSE 'N' END as DELETION_FLAG,
	 ROW_NUMBER()OVER (ORDER BY ORG_ID) as EXPENSE_REPORT_S,
	 OFFICE_HOME_FLAG as OFFICE_HOME_FLAG,
	 Null as FILE_ID,
	 CURRENT_TIMESTAMP as RECORD_CREATE_DATETIME,
	 CASE WHEN OPERATION = 'U' OR OPERATION = 'D' THEN CURRENT_TIMESTAMP ELSE Null END as RECORD_LAST_UPDATE_DATETIME,
	 TO_DECIMAL ( '{{ var("p_Batch_ID") }}' ,38 ,10 ) as BATCH_LOAD_ID,
	 'ITSSLIVE' as SOURCE_SYSTEM_CODE,
	 DB_TXN_SEQ_NO as DB_TXN_SEQ_NUM,
	 TABLE_TXN_SEQ_NO as TABLE_TXN_SEQ_NUM,
	 REPROCESS_COUNTER as REPROCESS_COUNTER 
From DSfilr_Lnk_Ds_Pfl_Expense_Report_Insert_2Out as DSfilr_Lnk_Ds_Pfl_Expense_Report_Insert_2Out)


select 
	REPORT_HEADER_ID
	,REPORT_LINE_ID
	,DISTRIBUTION_LINE_NUMBER
	,AMOUNT
	,CURRENCY_CODE
	,RECEIPT_CURRENCY_AMOUNT
	,DAILY_AMOUNT
	,WEB_PARAMETER_ID
	,CATEGORY_CODE
	,SUBMITTED_AMOUNT
	,ORG_ID
	,ITEMIZATION_PARENT_ID
	,EMPLOYEE_ID
	,PAID_ON_BEHALF_EMPLOYEE_ID
	,WEEK_END_DATE
	,INVOICE_NUM
	,MAXIMUM_AMOUNT_TO_APPLY
	,PREPAY_NUM
	,EXP_HEADER_VENDOR_SITE_ID
	,LEDGER_ID
	,SOURCE
	,EXPENSE_LINE_CO_CODE
	,EXPENSE_LINE_COST_CENTRE
	,EXPENSE_LINE_NOMINAL_ACCOUNT
	,EXPENSE_LINE_BRANCH_CODE
	,EXPENSE_LINE_PRODUCT_CODE
	,CODE_COMBINATION_ID
	,COMPANY_CODE
	,PERSON_ID
	,EMPLOYEE_NUMBER
	,FULL_NAME
	,SUPPLIER_VENDOR_SITE_ID
	,DELETION_FLAG
	,EXPENSE_REPORT_S
	,OFFICE_HOME_FLAG
	,FILE_ID
	,RECORD_CREATE_DATETIME
	,RECORD_LAST_UPDATE_DATETIME
	,BATCH_LOAD_ID
	,SOURCE_SYSTEM_CODE
	,DB_TXN_SEQ_NUM
	,TABLE_TXN_SEQ_NUM
	,REPROCESS_COUNTER
from Lnk_Ds_Pfl_Expense_Report_Insert_2Out