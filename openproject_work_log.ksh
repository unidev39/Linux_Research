#!/bin/sh
####################################################################
# Workfile      : openproject_work_log.ksh
# Description   : To find the employees work log
# Created By    : Devesh Kumar Shrivastav
# Created On    : July 04, 2019
# Modified By   : Devesh Kumar Shrivastav
# Reviewed By   : Suman Pantha
# Reviewed On   : July 04, 2019
####################################################################

################BOF This is part of the openproject work log################

# To connection string with Mysql Database
export user_name='root'
export user_password='RootAdmin@2019#@!'
export server_host='localhost'
export database_name='openproject'

# To log the file name.i
date=$(date +"%d%m%Y")
file_name="/var/lib/mysql-files/Openproject_Status/OpenprojectStatus_"


# To Connect with database.
query=$(mysql $database_name -h $server_host -u $user_name -p$user_password -se "(SELECT 
     'ID,PROJECT_NAME,TYPE_NAME,VERSIONS_NAME,FIXED_VERSION_ID,STATUS_NAME,ASSIGNED,SUBJECT,START_DATE,DUE_DATE,ESTIMATED_HOURS,RESPONSIBLE,REMAINING_HOURS,TYPE_ID,TO_ID,FROM_ID,HIERARCHY'
FROM dual)
UNION ALL
(SELECT
     CONCAT(a.id,',',a.project_name,',',a.type_name,',',a.versions_name,',',a.fixed_version_id,',',a.status_name,',',a.assigned,',',a.subject,',',a.start_date,',',a.due_date,',',a.estimated_hours,',',a.responsible,',',a.remaining_hours,',',a.type_id,',',a.to_id,',',a.from_id,',',a.hierarchy)
FROM (SELECT                         
           IFNULL(w.id,'')                                    id,
           IFNULL(p.name,'')                                  project_name,
           IFNULL(t.name,'')                                  type_name,
           IFNULL(v.name,'')                                  versions_name,
           IFNULL(w.fixed_version_id,'')                      fixed_version_id,       
           IFNULL(s.name,'')                                  status_name,
           IFNULL(CONCAT_WS(' ',u.firstname,u.lastname),'')   assigned,
	   IFNULL(replace(replace(replace(replace(subject,',',''),char(9),''),char(13),''),char(10),''),'')                 subject,
           IFNULL(w.start_date,'')                            start_date,
           IFNULL(w.due_date,'')                              due_date, 
           IFNULL(w.estimated_hours,'')                       estimated_hours,
           IFNULL(CONCAT_WS(' ',u1.firstname,u1.lastname),'') responsible,
		   IFNULL(remaining_hours,'')                         remaining_hours,
           IFNULL(w.type_id,'')                               type_id,
           IFNULL(r.to_id,'')                                 to_id,
           IFNULL(r.from_id,'')                               from_id,
           IFNULL(r.hierarchy,'')                             hierarchy
      from (select 
                   distinct wp.id, 
                   project_id,
                   status_id,
                   type_id,
                   fixed_version_id,
                   assigned_to_id,
                   responsible_id,
                   start_date,
                   due_date,
                   estimated_hours
            from work_packages wp 
            inner join relations r on wp.id = r.to_id
            order by project_id) w
      inner join projects p on p.id = w.project_id
      left join users u on u.id=w.assigned_to_id  
      inner join types t on t.id=w.type_id
      left join users u1 on u1.id=w.responsible_id 
      left join versions v on v.id=w.fixed_version_id
      left join statuses s on s.id=w.status_id
      inner join relations r on r.from_id = w.id
      inner join work_packages wp on wp.id = r.to_id
      where p.id not in (1,2) ) a
      order by 
          a.project_name,
	  a.id) "
)
echo "$query" > $file_name$date.csv

# To trigger the email with attachments, sends the mail to the respective persons.

# File names for attachment
#file_location="/var/lib/mysql-files/Openproject_Status/"
#attachment_file_name="OpenprojectStatus_$date.csv"
#cd $file_location

#email_subject='Openproject Daily Status'
#email_body='Hello Kenny,\n
#Please find the attached Open Project Status for today.\n
#\n
#Thank You,
#DBA Team'
#email_recepients='kenny.kuan@8squarei.com,devesh@8squarei.com,suman@8squarei.com'
#echo "$email_body" | mail -A "$attachment_file_name" -s "$email_subject" "$email_recepients" < /dev/null

####################################################################
#                       End of Script                              #
####################################################################
