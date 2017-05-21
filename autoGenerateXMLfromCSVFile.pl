#!/usr/bin/perl
#=======================================================================
# autoGenerateXMLfromCSVFile.pl 
#=======================================================================
# Description: Perl script to create XML files for a select "grouping by". 
# The script considers a specified grouping field "AREA" in the input file 
# as the select group by field and will create XML data based on that 
# grouping field ID. The script uses a sample input file called input.csv and
# creates XML files by the AREA field group. The output file will be one XML
# for each group by field "AREA" with child XML nodes that correspond to 
# records pulled from a database in each group by XML file AND that meet
# the SQL select by criteria (see bonus).  
#
# Bonus: There is an example of how to query, select, and order by specific
# fields (COLOR and MODE in this example) DBI and SQL commands. 
# select AREA,MEMBER,COLOR,MODE from input.csv where COLOR like 'GREEN%' AND MODE like 'AUTO%' ORDER BY AREA,MEMBER
#
# How to Use
#
# >> autoGenerateXMLfromCSVFile.pl
# Example: autoGenerateXMLfromCSVFile.pl
#
# Input files: 
#					input.csv located in same directory
#
# Output Directory: $outdir
# 					Default: output_XML
# Output files:
# 					_AREA_%area%.xml
#
#======================================================================== 
# Case Example
#
# input.csv
#
# RECORD_ID,MEMBER,COMPANY,AREA,COLOR,MODE
# 788,Q,ABC_COMPANY,SOUTH,BLUE,MANUAL
# 1120,Q,ABC_COMPANY,SOUTH,GREEN,AUTO
# 1849,A,ABC_COMPANY,EAST,BLUE,MANUAL
# 1862,B,ABC_COMPANY,EAST,GREEN,AUTO
# ...
# 
# Output Directory (created)
#
# output_XML
# ======================
# _AREA_EAST.xml
# _AREA_SOUTH.xml
#
# FILE:  _AREA_EAST.xml (note: select criteria: COLOR = GREEN, Mode = AUTO)
#
#<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>
#<group>
#<group_header>
#<id>AREA_EAST</id>
#<text>This XML file contains only the group AREA records (members) that are related (in the same group AREA) </text>
#<southeast>false</southeast>
#<south>false</south>
#<north>false</north>
#<east>true</east>
#<west>false</west>
#<createdby>USER YOUR NAME HERE</createdby>
#<createdtime>2017_05_21_00_39_44</createdtime>
#<modby>USER YOUR NAME HERE</modby>
#<modtime>2017_05_21_00_39_44</modtime>
#</group_header>
#<group_member>
#<id>B</id>
#<color>GREEN</color>
#<mode>AUTO</mode>
#<text>Member belongs to group AREA EAST</text>
#<flags>
#<flag1>false</flag1>
#<flag2>false</flag2>
#</flags>
#</group_member>
#<group_member>
#<id>C</id>
#<color>GREEN</color>
#<mode>AUTO</mode>
#<text>Member belongs to group AREA EAST</text>
#<flags>
#<flag1>false</flag1>
#<flag2>false</flag2>
#</flags>
#</group_member>
#<group_member>
#<id>D</id>
#<color>GREEN</color>
#<mode>AUTO</mode>
#<text>Member belongs to group AREA EAST</text>
#<flags>
#<flag1>false</flag1>
#<flag2>false</flag2>
#</flags>
#</group_member>
#<group_member>
#<id>F</id>
#<color>GREEN</color>
#<mode>AUTO</mode>
#<text>Member belongs to group AREA EAST</text>
#<flags>
#<flag1>false</flag1>
#<flag2>false</flag2>
#</flags>
#</group_member>
#...
#....
#<group_footer>
#<id>MESSAGE</id>
#<text>Group AREA EAST Sequence Complete</text>
#</group_footer>
#</group>
#
#
# 
#========================================================================
# About 		  
#
# Author: Kathleen West # SUPPORT WOMEN IN TECH #
# https://www.linkedin.com/in/kathleenewest
#
# FAQ's
#===========================
# Why Did You Make This?
#
# I made this project to demonstrate my PERL coding skills and that YES, when I say
# I have 15+ years work experience in industry, I really do know how to make a 
# project work. I have made many more PERL scripts for my employers and consulting
# clients to download data from databases, manipulate, report, and or transmit to
# other databases, the Internet, and computer modeling applications. I achieved this
# project working independently as the sole developer and IT solutions engineer.
# 
# I See Code Improvments and Ideas, Can I Contribute?
#
# Yes, there are a plenty ways to make this script better. I do not have time
# or interest to discuss and address every comment. I do not plan to
# make frequent, if any, updates to this project. You may make your own code
# project sites and grow the knowledge community. 
#
# License, Terms of Use?
#
# You may use, modify, or learn from this script to help you with your next PERL project 
# either for school or company projects. 
# Be fruitful with your PERL, prosper, and contribute to the knowledge community.
#========================================================================

#================================================================================================
# START OF MAIN SCRIPT
#================================================================================================
use Time::Piece;
use strict;
use warnings;
use DBI;

#=================================================================================================
# Custom User Variables
#=================================================================================================
my $outdir = "output_XML"; # Output directory for all group by XML files

#-----------------------------------------------------------------------------------------------
# Group By AREA Designations
# Used for conditional write of XML elements in this example
#
my $area_south = "SOUTH"; 
my $area_southeast = "SOUTHEAST"; 
my $area_north = "NORTH"; 
my $area_east = "EAST"; 
my $area_west = "WEST"; 
#-----------------------------------------------------------------------------------------------
# Additional Header Information for the XML
#
my $createdby = "USER YOUR NAME HERE";
my $modifiedby = "USER YOUR NAME HERE";
my $createdtime = localtime->strftime('%Y_%m_%d_%H_%M_%S');
my $modifiedtime = $createdtime; # GMT date and time


#========================================================
# Set-up Database Connection String to database input.csv
#========================================================
my $dbh = DBI->connect ("dbi:CSV:", undef, undef, 
{
      f_encoding => "utf-8",       
});

# Main SQL : Define and Execute SQL to select GREEN and AUTO points
my $sth = $dbh->prepare ("select AREA,MEMBER,COLOR,MODE from input.csv where COLOR like 'GREEN%' AND MODE like 'AUTO%' ORDER BY AREA,MEMBER");
$sth->execute;

# Secondary SQL: This is for referencing the first ROW ONLY in the script.
# This helps simplify the algorithm of the while loops and output correct results
my $sth2 = $dbh->prepare ("select AREA,MEMBER,COLOR,MODE from input.csv where COLOR like 'GREEN%' AND MODE like 'AUTO%' ORDER BY AREA,MEMBER");
$sth2->execute;

#=================================================================
# Delete Previous Output File Directory and Create New One
#=================================================================
system "rd /s /Q $outdir 2> nul";
system "md $outdir";

#==================================================================
# Global Definitions for Main Loop to Start (from SQL)
#==================================================================
my $row; # Main SQL ROW
my $row2 = $sth2->fetchrow_hashref; # SQL of First Row for Algorithm Reference

# First Row Variables Defined
my $station = $row2->{MEMBER}; #Global Definition and Assigned to Record 
my $color = $row2->{COLOR}; #Global Definition and Assigned to Record 
my $mode = $row2->{MODE}; #Global Definition and Assigned to Record 
my $station_ref = $station; # Global Definition and Assigned to First Record
my $area = $row2->{AREA}; # AREA 
my $area_ref = $area; # Global Definition and Assigned to First AREA
my $first_run = 1; # This is to turn off the first loop from printing XML

#=================================================================
# Main While Loop Begins
#=================================================================

while ($area_ref eq $area) 
{
	# Create Individual AREA XML File
	open (DAT_OUTPUT,">./$outdir/\_AREA\_$area.xml");
	
	#================================================================
	# Begin of AREA " Group" Header XML
	#================================================================

	print DAT_OUTPUT "<\?xml version=\"1.0\" encoding=\"UTF\-8\" standalone\=\"yes\" \?\>\n";
	print DAT_OUTPUT "<group>\n";
	print DAT_OUTPUT "<group_header>\n";
	print DAT_OUTPUT "<id>AREA\_$area</id>\n";
	print DAT_OUTPUT "<text>This XML file contains only the group AREA records (members) that are related (in the same group AREA) </text>\n";


	# Determines which AREA XML tag to print out true or false	
	if ($area eq $area_southeast) 
	{
		print DAT_OUTPUT	"<southeast>true</southeast>\n";
	} 
	else 
	{
		print DAT_OUTPUT	"<southeast>false</southeast>\n";
	}
	if ($area eq $area_south) 
	{
		print DAT_OUTPUT	"<south>true</south>\n";
	} 
	else 
	{
		print DAT_OUTPUT	"<south>false</south>\n";
	}
	if ($area eq $area_north) 
	{
		print DAT_OUTPUT	"<north>true</north>\n";
	} 
	else 
	{
		print DAT_OUTPUT	"<north>false</north>\n";
	}	
	if ($area eq $area_east) 
	{
		print DAT_OUTPUT	"<east>true</east>\n";
	} 
	else 
	{
		print DAT_OUTPUT	"<east>false</east>\n";
	}	
	if ($area eq $area_west) 
	{
		print DAT_OUTPUT	"<west>true</west>\n";
	} 
	else 
	{
		print DAT_OUTPUT	"<west>false</west>\n";
	}	

	print DAT_OUTPUT "<createdby>$createdby</createdby>\n";
	print DAT_OUTPUT "<createdtime>$createdtime</createdtime>\n";
	print DAT_OUTPUT "<modby>$modifiedby</modby>\n";
	print DAT_OUTPUT "<modtime>$modifiedtime</modtime>\n";
	print DAT_OUTPUT "</group_header>\n";

	#================================================================
	# End of AREA "Group" Header XML
	#================================================================

	#======================================================================
	# Begin of Nested While Loop
	#======================================================================
	
	while($area_ref eq $area)
	{
	
	# Skips the first nest loop on the first run of the script	
	if (($station ne $station_ref) || $first_run eq 1)
	{	
		
		#=====================================================================
		# Begin of members XML for individual belonging to group AREA
		#=====================================================================

		print DAT_OUTPUT	"<group_member>\n";
		print DAT_OUTPUT	"<id>$station</id>\n";
		print DAT_OUTPUT	"<color>$color</color>\n";
		print DAT_OUTPUT	"<mode>$mode</mode>\n";
		print DAT_OUTPUT	"<text>Member belongs to group AREA $area</text>\n";
		print DAT_OUTPUT	"<flags>\n";
		print DAT_OUTPUT  	"<flag1>false</flag1>\n";
		print DAT_OUTPUT  	"<flag2>false</flag2>\n";
		print DAT_OUTPUT	"</flags>\n";
		print DAT_OUTPUT	"</group_member>\n";

		#=====================================================================
		# END of members XML for individual records belonging to group AREA
		#=====================================================================
		
		$station_ref = $station;
		$first_run=0;
		
	}

	else
	{
			# Skip Duplicate Station
	}
	
		# Fetch the Next Row
		$row = $sth->fetchrow_hashref;
	
		# Terminates Inner While Loop if there are no more records		
		if(!($row->{MEMBER}))
		{
			last;
		}
		else
		{
			# Updates variables for Next Row
			$station = $row->{MEMBER};
			$area = $row->{AREA};
			$color = $row->{COLOR};
			$mode = $row->{MODE};
		}	

	}

	
	#====================================================================================
	# End of AREA Sequence XML 
	#====================================================================================
	
	print DAT_OUTPUT  "<group_footer>\n";
	print DAT_OUTPUT    "<id>MESSAGE</id>\n";
	print DAT_OUTPUT    "<text>Group AREA $area_ref Sequence Complete</text>\n";
	print DAT_OUTPUT  "</group_footer>\n";
	print DAT_OUTPUT"</group>\n";

	# Close individual station file stream and close Area XML file
	close DAT_OUTPUT;

	# Terminates Outer While Loop if there are no more records		
	if(!($row->{MEMBER}))
	{
		last;
	}
	else
	{
		$area_ref = $area;
	}
	
}

print "All group XML files by AREA field in file input.csv were written into directory $outdir";