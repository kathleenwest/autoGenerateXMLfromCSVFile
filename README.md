# autoGenerateXMLfromCSVFile
Description: Perl script to create XML files for a select "grouping by". The script considers a specified grouping field "AREA" in the input file as the select group by field and will create XML data based on that grouping field ID. The script uses a sample input file called input.csv and creates XML files by the AREA field group. The output file will be one XML for each group by field "AREA" with child XML nodes that correspond to records pulled from a database in each group by XML file AND that meet the SQL select by criteria (see bonus).  

Bonus: There is an example of how to query, select, and order by specific
fields (COLOR and MODE in this example) DBI and SQL commands. 
select AREA,MEMBER,COLOR,MODE from input.csv where COLOR like 'GREEN%' AND MODE like 'AUTO%' ORDER BY AREA,MEMBER
 
Instructions on how to use are in the PERL script file. 

  About 		  
 
  Author: Kathleen West   *SUPPORT WOMEN IN TECH*  
  https://www.linkedin.com/in/kathleenewest
 
  FAQ's

  Why Did You Make This?
 
  I made this project to demonstrate my PERL coding skills and that YES, when I say
  I have 15+ years work experience in industry, I really do know how to make a 
  project work. I have made many more PERL scripts for my employers and consulting
  clients to download data from databases, manipulate, report, and or transmit to
  other databases, the Internet, and computer modeling applications. I achieved this
  project working independently as the sole developer and IT solutions engineer.
  
  I See Code Improvments and Ideas, Can I Contribute?
 
  Yes, there are a plenty ways to make this script better. I do not have time
  or interest to discuss and address every comment. I do not plan to
  make frequent, if any, updates to this project. You may make your own code
  project sites and grow the knowledge community. 
 
  License, Terms of Use?
 
  You may use, modify, or learn from this script to help you with your next PERL project 
  either for school or company projects. 
  Be fruitful with your PERL, prosper, and contribute to the knowledge community.
 
