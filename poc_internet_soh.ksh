#!/bin/ksh
####################################################################
# Workfile      : poc_internet_soh.ksh
# Description   : Internet SOH comparison before and After the batch
# Created By    : Devesh Kumar Shrivastav
# Created On    : 2nd April 2018
# Modified By   : Devesh Kumar Shrivastav
# Modified On   : 14th April 2018
# Reviewed By   : Kavita Venkatesan/Bhuwan Prasad Bhatt
# Reviewed On   : 
####################################################################

################BOF This is part of the Internet SOH################

# To retrieve the required variables for poc_internet_soh.ksh.
. $MMHOME/poc_internet_soh/poc_environment.ksh

# To Log the Department Store Inventory Comparison RA vs RMS (excluding today's adjustment in RMS) - Before snapshot
if [[ "$execution_mode" -eq 1 ]]; then

# To log the file name Before snapshot.
date=$(date +"%d%m%Y")
file_name="$MMHOME/poc_internet_soh/soh_validation/Before_SOH_Validation_by_Department_Store_Inventory_Comparison_RA_vs_RMS_"

# To connect with RA Database for Before snapshot of SOH
query=$($oracle_home/bin/sqlplus -s $db_name/$db_password@$server_ip:$oracle_port/$oracle_sid  << EOF
SET COLSEP ,
SET ECHO OFF
SET VERIFY OFF
SET FEEDBACK OFF
SET PAGESIZE 5000
SET LINESIZE 300
SET UNDERLINE OFF
SET HEADING OFF
SET TRIMSPOOL ON

-- To create the backup table on daily basis
CREATE TABLE item_master_bk_before PARALLEL COMPRESS NOLOGGING TABLESPACE TABLE_BACKUP AS SELECT * FROM item_master@ra_to_mom;
CREATE TABLE deps_bk_before PARALLEL COMPRESS NOLOGGING TABLESPACE TABLE_BACKUP AS SELECT * FROM deps@ra_to_mom;
CREATE TABLE period_bk_before PARALLEL COMPRESS NOLOGGING TABLESPACE TABLE_BACKUP AS SELECT * FROM period@ra_to_mom;
CREATE TABLE tran_data_bk_before PARALLEL COMPRESS NOLOGGING TABLESPACE TABLE_BACKUP AS SELECT * FROM tran_data@ra_to_mom;

SPOOL $file_name$date.csv

SELECT 'Comparison by Store and Brand'||CHR(10) soh_validation_type from dual;

SPOOL $file_name$date.csv append

WITH rms
AS
(
 SELECT
      ils.loc                                         loc,
      itm.item                                        item,
      itm.dept                                        dept,
      deps.dept_name                                  dept_name,
      (NVL(pack_comp_soh, 0) + NVL(stock_on_hand, 0)) rms_soh_qty
 FROM
     item_loc_soh@ra_to_mom ils,
     item_master_bk_before  itm,
     deps_bk_before         deps
 WHERE (1 = 1)
 AND ils.item            = itm.item
 AND itm.dept            = deps.dept
 AND itm.item_xform_ind != 'Y'
 AND itm.inventory_ind   = 'Y'
 AND itm.pack_ind        = 'N'
 AND itm.status          = 'A'
 AND ils.loc IN (4490,5990,4500,2100)
 AND NOT EXISTS (SELECT 
                      1
                 FROM
                      tran_data_bk_before td
                 WHERE
                     ils.item     = td.item
                 AND itm.item     = td.item
                 AND itm.dept     = td.dept
                 AND deps.dept    = td.dept
                 AND ils.loc      = td.location
                 AND td.tran_code IN ('22','23'))
),
ra
AS
(
 SELECT
      inv.prod_it_num       item,
      inv.prod_dp_num       dept,
      TO_NUMBER(org_num)    loc,
      inv_soh_qty           ra_soh_qty
 FROM
      w_rtl_inv_it_lc_g inv,
      w_product_d       d
 WHERE
     (inv_soh_qty <> 0
      OR inv_on_ord_qty <> 0
      OR inv_in_tran_qty <> 0)
 AND d.row_wid = inv.prod_wid
 AND current_flg = 'Y'
)
SELECT 
     'DEPT_NAME,LOC,FISCAL_DATE,DEPT,RA_SOH_QTY,RMS_SOH_QTY,DIFF_BEFORE_BATCH'
FROM dual
UNION ALL
SELECT
     a.dept_name||','||a.loc||','||a.fiscal_date||','||a.dept||','||a.ra_soh_qty||','||a.rms_soh_qty||','||diff_before_batch
FROM (
      SELECT
           '"'||rms.dept_name||'"'                                 dept_name,
           rms.loc                                                 loc,
           (SELECT vdate FROM period_bk_before)                    fiscal_date,
           rms.dept                                                dept,
           NVL(SUM(ra.ra_soh_qty),0)                               ra_soh_qty,
           NVL(SUM(rms.rms_soh_qty),0)                             rms_soh_qty,
           (NVL(SUM(ra.ra_soh_qty),0)-NVL(SUM(rms.rms_soh_qty),0)) diff_before_batch
      FROM 
          rms JOIN ra
      ON (ra.item = rms.item AND ra.loc = rms.loc)
      GROUP BY
           rms.loc,
           rms.dept,
           rms.dept_name
      ORDER BY
           rms.loc,
           rms.dept
     ) a ;

SPOOL $file_name$date.csv append

SELECT 'Comparison by Brand'||CHR(10) soh_validation_type from dual;

SPOOL $file_name$date.csv append

WITH rms
AS
(
 SELECT
      ils.loc                                         loc,
      itm.item                                        item,
      itm.dept                                        dept,
      deps.dept_name                                  dept_name,
      (NVL(pack_comp_soh, 0) + NVL(stock_on_hand, 0)) rms_soh_qty
 FROM
      item_loc_soh@ra_to_mom ils,
      item_master_bk_before  itm,
      deps_bk_before         deps
 WHERE (1 = 1)
 AND ils.item            = itm.item
 AND itm.dept            = deps.dept
 AND itm.item_xform_ind != 'Y'
 AND itm.inventory_ind   = 'Y'
 AND itm.pack_ind        = 'N'
 AND itm.status          = 'A'
 AND NOT EXISTS (SELECT 
                     1
                FROM
                     tran_data_bk_before td
                WHERE
                    ils.item     = td.item
                AND itm.item     = td.item
                AND itm.dept     = td.dept
                AND deps.dept    = td.dept
                AND ils.loc      = td.location
                AND td.tran_code IN ('22','23'))
),
ra
AS
(
 SELECT
      inv.prod_it_num    item,
      inv.prod_dp_num    dept,
      TO_NUMBER(org_num) loc,
      inv_soh_qty        ra_soh_qty
 FROM
      w_rtl_inv_it_lc_g inv,
      w_product_d       d
 WHERE
     (inv_soh_qty <> 0
      OR inv_on_ord_qty  <> 0
      OR inv_in_tran_qty <> 0)
 AND d.row_wid   = inv.prod_wid
 AND current_flg = 'Y'
)
SELECT 
     'DEPT,DEPT_NAME,FISCAL_DATE,RA_SOH_QTY,RMS_SOH_QTY,DIFF_BEFORE_BATCH'
FROM dual
UNION ALL
SELECT
     a.dept||','||a.dept_name||','||a.fiscal_date||','||a.ra_soh_qty||','||a.rms_soh_qty||','||a.diff_before_batch
FROM (
      SELECT
           rms.dept                                                dept,
           '"'||rms.dept_name||'"'                                 dept_name,
           (SELECT vdate FROM period_bk_before)                    fiscal_date,
           NVL(SUM(ra.ra_soh_qty),0)                               ra_soh_qty,
           NVL(SUM(rms.rms_soh_qty),0)                             rms_soh_qty,
           (NVL(SUM(ra.ra_soh_qty),0)-NVL(SUM(rms.rms_soh_qty),0)) diff_before_batch
      FROM
           rms JOIN ra
      ON ( ra.item = rms.item AND ra.loc = rms.loc)
      GROUP BY
          rms.dept,
          rms.dept_name
      ORDER BY
        rms.dept
    ) a ;

SPOOL OFF

-- To drop the backup table on daily basis
DROP TABLE item_master_bk_before PURGE;
DROP TABLE deps_bk_before        PURGE;
DROP TABLE tran_data_bk_before   PURGE;

EXIT
EOF)

# To change the execution mode for after snapshot.
sed -i -e 's/execution_mode=1/execution_mode=2/g' ${MMHOME}/poc_internet_soh/poc_environment.ksh

# To Log the Department Store Inventory Comparison RA vs RMS (excluding today's adjustment in RMS) - After snapshot
elif [[ "$execution_mode" -eq 2 ]]; then

# To log the file name for After snapshot.
date=$(date +"%d%m%Y")
file_name="$MMHOME/poc_internet_soh/soh_validation/After_SOH_Validation_by_Department_Store_Inventory_Comparison_RA_vs_RMS_"

# To connect with RA Database for After snapshot of SOH
query=$($oracle_home/bin/sqlplus -s $db_name/$db_password@$server_ip:$oracle_port/$oracle_sid  << EOF
SET COLSEP ,
SET ECHO OFF
SET VERIFY OFF
SET FEEDBACK OFF
SET PAGESIZE 5000
SET LINESIZE 300
SET UNDERLINE OFF
SET HEADING OFF
SET TRIMSPOOL ON

-- To create the backup table on daily basis
CREATE TABLE item_master_bk_after PARALLEL COMPRESS NOLOGGING TABLESPACE TABLE_BACKUP AS SELECT * FROM item_master@ra_to_mom;
CREATE TABLE deps_bk_after PARALLEL COMPRESS NOLOGGING TABLESPACE TABLE_BACKUP AS SELECT * FROM deps@ra_to_mom;
CREATE TABLE tran_data_bk_after PARALLEL COMPRESS NOLOGGING TABLESPACE TABLE_BACKUP AS SELECT * FROM tran_data@ra_to_mom;

SPOOL $file_name$date.csv

SELECT 'Comparison by Store and Brand'||CHR(10) soh_validation_type from dual;

SPOOL $file_name$date.csv append

WITH rms
AS
(
 SELECT
      ils.loc                                         loc,
      itm.item                                        item,
      itm.dept                                        dept,
      deps.dept_name                                  dept_name,
      (NVL(pack_comp_soh, 0) + NVL(stock_on_hand, 0)) rms_soh_qty
 FROM
      item_loc_soh@ra_to_mom ils,
      item_master_bk_after   itm,
      deps_bk_after          deps
 WHERE (1 = 1)
 AND ils.item            = itm.item
 AND itm.dept            = deps.dept
 AND itm.item_xform_ind != 'Y'
 AND itm.inventory_ind   = 'Y'
 AND itm.pack_ind        = 'N'
 AND itm.status          = 'A'
 AND ils.loc IN (4490,5990,4500,2100)
 AND NOT EXISTS (SELECT 
                      1
                 FROM
                      tran_data_bk_after td
                 WHERE
                     ils.item     = td.item
                 AND itm.item     = td.item
                 AND itm.dept     = td.dept
                 AND deps.dept    = td.dept
                 AND ils.loc      = td.location
                 AND td.tran_code IN ('22','23'))
),
ra
AS
(
 SELECT
      inv.prod_it_num       item,
      inv.prod_dp_num       dept,
      TO_NUMBER(org_num)    loc,
      inv_soh_qty           ra_soh_qty
 FROM
      w_rtl_inv_it_lc_g inv,
      w_product_d       d
 WHERE
     (inv_soh_qty <> 0
      OR inv_on_ord_qty <> 0
      OR inv_in_tran_qty <> 0)
 AND d.row_wid   = inv.prod_wid
 AND current_flg = 'Y'
)
SELECT 
     'DEPT_NAME,LOC,FISCAL_DATE,DEPT,RA_SOH_QTY,RMS_SOH_QTY,DIFF_AFTER_BATCH'
FROM dual
UNION ALL
SELECT
     a.dept_name||','||a.loc||','||a.fiscal_date||','||a.dept||','||a.ra_soh_qty||','||a.rms_soh_qty||','||a.diff_after_batch  
FROM (
      SELECT
           '"'||rms.dept_name||'"'                                 dept_name,
           rms.loc                                                 loc,
           (SELECT vdate FROM period_bk_before)                    fiscal_date,
           rms.dept                                                dept,
           NVL(SUM(ra.ra_soh_qty),0)                               ra_soh_qty,
           NVL(SUM(rms.rms_soh_qty),0)                             rms_soh_qty,
           (NVL(SUM(ra.ra_soh_qty),0)-NVL(SUM(rms.rms_soh_qty),0)) diff_after_batch
      FROM 
          rms JOIN ra
      ON (ra.item = rms.item AND ra.loc = rms.loc)
      GROUP BY
           rms.loc,
           rms.dept,
           rms.dept_name
      ORDER BY
           rms.loc,
           rms.dept
     ) a;

SPOOL $file_name$date.csv append

SELECT 'Comparison by Brand'||CHR(10) soh_validation_type from dual;

SPOOL $file_name$date.csv append

WITH rms
AS
(
 SELECT
      ils.loc                                       loc,
      itm.item                                      item,
      itm.dept                                      dept,
      deps.dept_name                                dept_name,
      (NVL(pack_comp_soh,0) + NVL(stock_on_hand,0)) rms_soh_qty
 FROM
      item_loc_soh@ra_to_mom ils,
      item_master_bk_after   itm,
      deps_bk_after          deps
 WHERE (1 = 1)
 AND ils.item            = itm.item
 AND itm.dept            = deps.dept
 AND itm.item_xform_ind != 'Y'
 AND itm.inventory_ind   = 'Y'
 AND itm.pack_ind        = 'N'
 AND itm.status          = 'A'
 AND NOT EXISTS (SELECT 
                     1
                FROM
                     tran_data_bk_after td
                WHERE
                    ils.item      = td.item
                AND itm.item      = td.item
                AND itm.dept      = td.dept
                AND deps.dept     = td.dept
                AND ils.loc       = td.location
                AND td.tran_code IN ('22','23'))
),
ra
AS
(
 SELECT
      inv.prod_it_num    item,
      inv.prod_dp_num    dept,
      TO_NUMBER(org_num) loc,
      inv_soh_qty        ra_soh_qty
 FROM
      w_rtl_inv_it_lc_g inv,
      w_product_d       d
 WHERE
     (inv_soh_qty <> 0
      OR inv_on_ord_qty  <> 0
      OR inv_in_tran_qty <> 0)
 AND d.row_wid   = inv.prod_wid
 AND current_flg = 'Y'
)
SELECT 
     'DEPT,DEPT_NAME,FISCAL_DATE,RA_SOH_QTY,RMS_SOH_QTY,DIFF_AFTER_BATCH'
FROM dual
UNION ALL
SELECT
     a.dept||','||a.dept_name||','||a.fiscal_date||','||a.ra_soh_qty||','||a.rms_soh_qty||','||a.diff_after_batch  
FROM (
      SELECT
           rms.dept                                         dept,
           '"'||rms.dept_name||'"'                          dept_name,
           (SELECT vdate FROM period_bk_before)             fiscal_date,
           NVL(SUM(ra.ra_soh_qty),0)                        ra_soh_qty,
           NVL(SUM(rms.rms_soh_qty),0)                      rms_soh_qty,
           (NVL(SUM(ra.ra_soh_qty),0)-NVL(SUM(rms.rms_soh_qty),0)) diff_after_batch
      FROM
           rms JOIN ra
      ON ( ra.item = rms.item AND ra.loc = rms.loc)
      GROUP BY
          rms.dept,
          rms.dept_name
      ORDER BY
          rms.dept
     ) a ;

SPOOL $file_name$date.csv append

SELECT 'Discrepancies that were found for the departments and items due to today''s adjustment in RMS'||CHR(10) soh_validation_type from dual;

SPOOL $file_name$date.csv append

WITH rms
AS
(
 SELECT
      ils.loc                                         loc,
      itm.item                                        item,
      itm.dept                                        dept,
      deps.dept_name                                  dept_name,
      (NVL(pack_comp_soh, 0) + NVL(stock_on_hand, 0)) rms_soh_qty
 FROM 
     item_loc_soh@ra_to_mom ils,
     item_master_bk_after   itm,
     deps_bk_after          deps
 WHERE (1 = 1)
 AND ils.item            = itm.item
 AND itm.dept            = deps.dept
 AND itm.item_xform_ind != 'Y'
 AND itm.inventory_ind   = 'Y'
 AND itm.pack_ind        = 'N'
 AND itm.status          = 'A'
 AND EXISTS (SELECT 
                  1
             FROM
                  tran_data_bk_after td
             WHERE
                 ils.item     = td.item
             AND itm.item     = td.item
             AND itm.dept     = td.dept
             AND deps.dept    = td.dept
             AND ils.loc      = td.location
             AND td.tran_code IN ('22','23'))
),
ra
AS
(
 SELECT
      inv.prod_it_num       item,
      inv.prod_dp_num       dept,
      TO_NUMBER(ORg_num)    loc,
      inv_soh_qty           ra_soh_qty
 FROM
      w_rtl_inv_it_lc_g inv,
      w_product_d       d
 WHERE
     (inv_soh_qty <> 0
      OR inv_on_ord_qty <> 0
      OR inv_in_tran_qty <> 0)
 AND d.row_wid   = inv.prod_wid
 AND current_flg = 'Y'
)
SELECT 
     'LOC,DEPT,DEPT_NAME,ITEM,SOH_QTY_DIFF,TODAY'
FROM dual
UNION ALL
SELECT
     a.loc||','||a.dept||','||a.dept_name||','||a.item||','||a.soh_qty_diff||','||a.today
FROM (
      SELECT
           a.loc                           loc, 
           a.dept                          dept,
           '"'||a.dept_name||'"'           dept_name,
           a.item                          item,
           (a.ra_soh_qty - a.rms_soh_qty)  soh_qty_diff
           ,a.today                        today
      FROM (
            SELECT
                 ra.item                                item,
                 rms.loc                                loc,
                 rms.dept                               dept,
                 rms.dept_name                          dept_name,
                 (SELECT vdate+1 FROM period_bk_before) today,
                 NVL(SUM(ra.ra_soh_qty),0)              ra_soh_qty,
                 NVL(SUM(rms.rms_soh_qty),0)            rms_soh_qty
            FROM 
                rms JOIN ra
            ON (ra.item = rms.item AND ra.loc = rms.loc)
            GROUP BY
                 ra.item,
                 rms.loc,
                 rms.dept,
                 rms.dept_name
            ) a
            ORDER BY
                 a.loc,
                 a.dept,
                 a.item
     ) a
WHERE a.soh_qty_diff <> 0
;

SPOOL OFF

-- To drop the backup table on daily basis
DROP TABLE item_master_bk_after PURGE;
DROP TABLE deps_bk_after        PURGE;
DROP TABLE period_bk_before     PURGE;
DROP TABLE tran_data_bk_after   PURGE;

EXIT
EOF)

# To trigger the email with attachments, sends the mail to the respective persons.
sendemail_mod="1"

fi

if [[ "$sendemail_mod" -eq 1 ]]; then

# File names for attachment
file_location="$MMHOME/poc_internet_soh/soh_validation"
before_file_name="Before_SOH_Validation_by_Department_Store_Inventory_Comparison_RA_vs_RMS_$date.csv"
after_file_name="After_SOH_Validation_by_Department_Store_Inventory_Comparison_RA_vs_RMS_$date.csv"

cd $file_location
email_subject='Internet SOH Comparison Before and After the Batch'
email_body='Hello All,\n
Please find the attached SOH validation for internet stores.\n
  Before file contains:
   1.Comparison by Store and Brand.
   2.Comparison by Brand.\n
  After file contains:
   1.Comparison by Store and Brand.
   2.Comparison by Brand.
   3.Discrepancies that were found for the departments and items due to today`s adjustment in RMS.\n
Thank You,
Devesh Kumar Shrivastav.'
email_recepients='devesh.shrivastav@logicinfo.com,bhuwan.bhatt@logicinfo.com'
echo "$email_body" | mail -a "$before_file_name" -a "$after_file_name" -s "$email_subject" "$email_recepients"

# To Change the execution mode variable for Before Snapshot.
sed -i -e 's/execution_mode=2/execution_mode=1/g' ${MMHOME}/poc_internet_soh/poc_environment.ksh

fi
####################################################################
#                       End of Script                              #
####################################################################