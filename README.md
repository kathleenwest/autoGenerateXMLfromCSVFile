# autoGenerateXMLfromCSVFile
Description: Perl script to create XML files for a select "grouping by". The script considers a specified grouping field "AREA" in the input file as the select group by field and will create XML data based on that grouping field ID. The script uses a sample input file called input.csv and creates XML files by the AREA field group. The output file will be one XML for each group by field "AREA" with child XML nodes that correspond to records pulled from a database in each group by XML file AND that meet the SQL select by criteria (see bonus).  

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
