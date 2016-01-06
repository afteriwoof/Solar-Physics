
CORIMP GUIDE TO CODES AND GAIL & ALSHAMESS SETUP


Crontab on gail:
00 00 * * * cd $HOME/work_on_gail && sh script.sh 2> $HOME/work_on_gail/error.out
30 */2 * * * cd $HOME/work_on_gail && sh script_latest.sh 2> $HOME/work_on_gail/error.out

where script.sh contains:
#!/bin/sh
touch temp_script_ran.txt
/usr/local/bin/idl < automated_cron.b

and script_latest.sh contains:
#!/bin/sh
touch temp_script_ran_latest.txt
/usr/local/bin/idl < automated_cron_latest.b

automated_cron.b calls lasco_realtime_jpb.pro
automated_cron_latest.b calls lasco_realtime_jpb_latest.pro


To run the past 

**************

To process automated detections from Huw’s separated files:

automated_gail, '2013/10/01','2013/12/31','/volumes/store/processed_data/soho/lasco/separated/fits','/volumes/store/processed_data/soho/lasco/detections'

automated_kins_gail, ‘yyyy/mm/dd’, ‘yyyy/mm/dd’, /originals

(^asks to delete previous kinematic runs before proceeding)

Set the in_dir with manually set loops over the startdate and enddate in this code if they run for more than one month, otherwise start and end dates can be input as follows:

create_html_gail, '/volumes/store/processed_data/soho/lasco/detections', ‘yyyy/mm/dd’, ‘yyyy/mm/dd’, /sav_gol

rsync to alshamess:

rsync -avnuSH —delete-after /volumes/store/processed_data/soho/lasco/detections/yyyy/mm/ alshamess:/volumes/data/data1/www/CORIMP/yyyy/mm/



To run the realtime:

cronjob of codes runs 
1) lasco_realtime_jpb_latest   (every few hours) <— including call /mail_alert in create_html_gail_realtime to send an email alert.
2) lasco_realtime_jpb   (every midnight)


lasco_realtime_jpb_latest.pro

	Downloads the fits files to /home/gail/jbyrne/soho/lasco/lastimage & bg_av_st/ & separated/
	(currently skips run_automated_realtime_alert.pro that performs single image detection alert.)
	STEPS:
	1)	Make folder 'latest/' or else empty current one.
	2)	Run the automated detections on the past day's separated fits files, saving the output to the 'detections/daily/' folder.
		Calls automated_gail_realtime, startdate, enddate, fits dir, latest dir, /check, /latest
			/check for already performed detections
			if keyword_set(latest) then call run_automated_realtime_alert on each file
				or else call run_automated_new_gail_realtime on all the files.
	3)	 Join up the pa_slices from the individual detections in folder latest.
	4)	Call the automated_kins_gail_realtime to run kinematics on the latest detections.
			automated_kins_gail_realtime, startdate, enddate, /originals, /latest
				saves out the kinematic info (cme_kins/ , cme_profs/ , cme_im*/ , etc) to /home/gail/jbyrne/reatlime/soho/lasco/detections/latest/
			 Calls (among others) clean_heights.pro, plot_kins_quartiles_gail, gather_gail_detections_inset_all_device
	5)	Create the htmls of the latest detections.
			Calls create_html_gail_realtime, ‘/home/gail/jbyrne/realtime/soho/lasco/detections/latest’, /type of fit, /latest (, /mail_alert)
	6)	Sync the latest detections to alshamess for online catalog:
			spawn, 'rsync -avuSH --delete-after -e "ssh -i /home/gail/jbyrne/.ssh/id_dsa_alshamess" /home/gail/jbyrne/realtime/soho/lasco/detections/latest alshamess:/volumes/data/data1/www/CORIMP/realtime/soho/lasco/detections/'	

lasco_realtime_jpb.pro

	Downloads the fits files to /home/gail/jbyrne/soho/lasco/lastimage & bg_av_st/ & separated/
	STEPS:
	1)	Since this code is running only once a day, delete the daily/ folder of all detection info and weekly/ folder of just the kinematics info to redo for the week’s new kinematics with the new day’s detections added on.
			e.g. spawn, 'rm -rf /home/gail/jbyrne/realtime/soho/lasco/detections/daily/*' 
        			   spawn, 'rm -rf /home/gail/jbyrne/realtime/soho/lasco/detections/weekly/*/*/*/cme_ims*'
	2)	Run the automated detections on the past day's separated fits files, saving the detection output to the 'detections/daily/' folder.
			automated_gail_realtime, startdate, enddate, fits dir, daily outdir
	3)	Sync those detections to the weekly folder and main realtime detections folder.
			spawn, 'rsync -avuSH /home/gail/jbyrne/realtime/soho/lasco/detections/daily/ /home/gail/jbyrne/realtime/soho/lasco/detections/weekly/'
			spawn, 'rsync -avuSH /home/gail/jbyrne/realtime/soho/lasco/detections/daily/ /home/gail/jbyrne/realtime/soho/lasco/detections/'
	skip to 7)	Run the kinematics for the past week: automated_kins_gail_realtime, kins_startdate, enddate, /originals, /weekly  from a week ago.
	8)	Create the htmls of the weekly detections folder.
			create_html_gail_realtime, ‘home/gail/jbyrne/realtime/soho/lasco/detections/weekly’, /type of fit, /weekly	9)	Sync the weekly detections to alshamess for online catalog.
			spawn, 'rsync -avuSH --delete-after -e "ssh -i /home/gail/jbyrne/.ssh/id_dsa_alshamess" /home/gail/jbyrne/realtime/soho/lasco/detections/weekly alshamess:/volumes/data/data1/www/CORIMP/realtime/soho/lasco/detections/'



*****
To add the monthly detections to the online catalog, after they have been populated with the weekly realtime detections:

(Open IDL in work_on_gail/ folder and run @idl_startup.b to run ssw)

On gail run (from start date to end date) *I think there might be an error with this if it’s run for more than a single month.

automated_kins_gail_realtime, ‘yyyy/mm/dd’,/yyyy/mm/dd’, /originals

Then on gail run

create_html_gail,'/home/gail/jbyrne/realtime/soho/lasco/detections’,’yyyy/mm/dd’,’yyyy/mm/‘dd, /sav_gol, /from_realtime
create_html_gail,'/home/gail/jbyrne/realtime/soho/lasco/detections','yyyy/mm/dd','yyyy/mm/dd', /quadratic, /from_realtime
create_html_gail,'/home/gail/jbyrne/realtime/soho/lasco/detections’,’yyyy/mm/dd’,’yyyy/mm/‘dd, /linear, /from_realtime

Then on gail rsync the output to alshamess

rsync -avnuSH —delete-after /home/gail/jbyrne/realtime/soho/lasco/detections/yyyy/mm/ alshamess:/volumes/data/data1/www/CORIMP/realtime/soho/lasco/detections/yyyy/mm/

Move the relevant parts of the realtime data on gail to the folders where it’s to be stored, e.g.:

mv realtime/soho/lasco/detections/yyyy/mm /volumes/store/processed_data/realtime/soho/lasco/detections/yyyy/


Then on alshamess edit the html file to link the new month: /volumes/data/data1/www/CORIMP/index.html

