select *
from {{ source('ITSS_AP', 'AP_EXPENSE_REPORT_LINES_ALL') }}
