--- chicago_socioeconomic_data
--- COMMUNITY_AREA_NUMBER	COMMUNITY_AREA_NAME	PERCENT_OF_HOUSING_CROWDED	PERCENT_HOUSEHOLDS_BELOW_POVERTY	PERCENT_AGED_16__UNEMPLOYED	PERCENT_AGED_25__WITHOUT_HIGH_SCHOOL_DIPLOMA	PERCENT_AGED_UNDER_18_OR_OVER_64	PER_CAPITA_INCOME	HARDSHIP_INDEX	

--- chicago_public_schools
--- School_ID	NAME_OF_SCHOOL	Elementary, Middle, or High School	Street_Address	City	State	ZIP_Code	Phone_Number	Link	Network_Manager	Collaborative_Name	Adequate_Yearly_Progress_Made_	Track_Schedule	CPS_Performance_Policy_Status	CPS_Performance_Policy_Level	HEALTHY_SCHOOL_CERTIFIED	Safety_Icon	SAFETY_SCORE	Family_Involvement_Icon	Family_Involvement_Score	Environment_Icon	Environment_Score	Instruction_Icon	Instruction_Score	Leaders_Icon	Leaders_Score	Teachers_Icon	Teachers_Score	Parent_Engagement_Icon	Parent_Engagement_Score	Parent_Environment_Icon	Parent_Environment_Score	AVERAGE_STUDENT_ATTENDANCE	Rate_of_Misconducts__per_100_students_	Average_Teacher_Attendance	Individualized_Education_Program_Compliance_Rate	Pk_2_Literacy__	Pk_2_Math__	Gr3_5_Grade_Level_Math__	Gr3_5_Grade_Level_Read__	Gr3_5_Keep_Pace_Read__	Gr3_5_Keep_Pace_Math__	Gr6_8_Grade_Level_Math__	Gr6_8_Grade_Level_Read__	Gr6_8_Keep_Pace_Math_	Gr6_8_Keep_Pace_Read__	Gr_8_Explore_Math__	Gr_8_Explore_Read__	ISAT_Exceeding_Math__	ISAT_Exceeding_Reading__	ISAT_Value_Add_Math	ISAT_Value_Add_Read	ISAT_Value_Add_Color_Math	ISAT_Value_Add_Color_Read	Students_Taking__Algebra__	Students_Passing__Algebra__	9th Grade EXPLORE (2009)	9th Grade EXPLORE (2010)	10th Grade PLAN (2009)	10th Grade PLAN (2010)	Net_Change_EXPLORE_and_PLAN	11th Grade Average ACT (2011)	Net_Change_PLAN_and_ACT	College_Eligibility__	Graduation_Rate__	College_Enrollment_Rate__	COLLEGE_ENROLLMENT	General_Services_Route	Freshman_on_Track_Rate__	X_COORDINATE	Y_COORDINATE	Latitude	Longitude	COMMUNITY_AREA_NUMBER	COMMUNITY_AREA_NAME	Ward	Police_District	Location

--- chicago_crime
--- ID	CASE_NUMBER	DATE	BLOCK	IUCR	PRIMARY_TYPE	DESCRIPTION	LOCATION_DESCRIPTION	ARREST	DOMESTIC	BEAT	DISTRICT	WARD	COMMUNITY_AREA_NUMBER	FBICODE	X_COORDINATE	Y_COORDINATE	YEAR	LATITUDE	LONGITUDE	LOCATION


--- list the school names, community names and average attendance for communities with a hardship index of 98.
SELECT
    s.NAME_OF_SCHOOL,
    s.COMMUNITY_AREA_NAME,
    s.AVERAGE_STUDENT_ATTENDANCE
FROM
    chicago_public_schools s
LEFT OUTER JOIN chicago_socioeconomic_data e ON
    s.COMMUNITY_AREA_NAME = e.COMMUNITY_AREA_NAME
WHERE
    e.HARDSHIP_INDEX = 98;


--- list all crimes that took place at a school. Include case number, crime type and community name

SELECT
    c.CASE_NUMBER,
    c.PRIMARY_TYPE,
    e.COMMUNITY_AREA_NAME
FROM
    chicago_crime c
LEFT OUTER JOIN chicago_socioeconomic_data e ON
    c.COMMUNITY_AREA_NUMBER = e.COMMUNITY_AREA_NUMBER
WHERE
    LOCATION_DESCRIPTION LIKE "%school%";


--- create a view showing the columns listed in the following table, with new column names as shown in the second column.

CREATE VIEW school_view AS
SELECT 
NAME_OF_SCHOOL	AS "School_Name",
Safety_Icon	AS "Safety_Rating",
Family_Involvement_Icon AS	"Family_Rating",
Environment_Icon	AS "Environment_Rating",
Instruction_Icon	AS "Instruction_Rating",
Leaders_Icon	AS "Leaders_Rating",
Teachers_Icon	AS "Teachers_Rating"
FROM chicago_public_schools;

--- statement that returns all of the columns from the view.
SELECT * FROM school_view;

--- statement that returns just the school name and leaders rating from the view.
SELECT School_Name, Leaders_Rating FROM school_view;


--- a stored procedure called UPDATE_LEADERS_SCORE that takes a in_School_ID parameter as an integer and a in_Leader_Score parameter as an integer.


DELIMITER @
CREATE PROCEDURE UPDATE_LEADERS_SCORE (
    IN in_School_ID INTEGER, 
    IN in_Leader_Score INTEGER
    )
  
LANGUAGE SQL
MODIFIES SQL DATA

BEGIN

END  @
DELIMITER ;

--- to update the Leaders_Score field in the CHICAGO_PUBLIC_SCHOOLS table for the school identified by in_School_ID to the value in the in_Leader_Score parameter.

DELIMITER@
CREATE PROCEDURE UPDATE_LEADERS_SCORE (
    IN in_School_ID INTEGER, 
    IN in_Leader_Score INTEGER
    )
  
LANGUAGE SQL
MODIFIES SQL DATA

BEGIN
	UPDATE CHICAGO_PUBLIC_SCHOOLS
	SET LEADERS_SCORE = in_Leader_Score
	WHERE SCHOOL_ID = in_School_ID;
END 
@

DELIMITER;


--- SQL IF statement to update the Leaders_Icon field in the CHICAGO_PUBLIC_SCHOOLS table for the school identified by in_School_ID using the following information.



