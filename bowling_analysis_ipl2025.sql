USE sample;
SHOW tables;
SELECT * FROM ipl_2025_deliveries;

-- First We will find purple cap holder (most wicket taken) AND top 5 wicket taker in IPL_2025
-- In this we have to exclude run out from bowler wicket taken.

SELECT bowler, 
	COUNT(CASE WHEN wicket_type NOT IN ('RUNOUT', '') THEN 1 END) 
    AS Wicket_taken
FROM ipl_2025_deliveries
GROUP BY bowler
ORDER BY Wicket_taken desc
LIMIT 10;
-- So from Output Prasidh has most wicket 25 in IPL_2025, more insights in following query.


-- Second we will see total_over bowled, wickets taken and bowling_economy(Average run per over). 
-- this will give more about the bowling performance.
-- We applied 3 criteria Wickets > 10 (good number of wickets) AND total_over > 20 (bowled a sufficient overs throughout the tournament) 
-- bowling_economy < 8.5 (Considering a average economy in this format) and bowling average < 22 (reliable wicket taker)
WITH table1 AS 
	(SELECT bowler, match_id,
			COUNT(CASE WHEN wicket_type NOT IN ('runout', 'retired out', 'retired hurt','') THEN 1 END) AS Wicket_taken,
			SUM(runs_of_bat + wide + noballs) AS run_conceded,
            COUNT(CASE WHEN wide = 0 AND noballs = 0 THEN 1 END) AS ball_bowled
	FROM ipl_2025_deliveries
    GROUP BY bowler, match_id)
    
SELECT bowler, 
			ROUND(SUM(run_conceded)*6.0/NULLIF(SUM(ball_bowled),0),2) AS bowling_economy,
            CONCAT(FLOOR(SUM(ball_bowled)/6),'.',MOD(SUM(ball_bowled),6)) AS total_over,
            SUM(wicket_taken) AS wickets,
            ROUND((SUM(run_conceded)*1.0/SUM(wicket_taken)),2) AS bowling_average
	FROM table1
    GROUP BY bowler
    HAVING Wickets > 10 AND total_over > 20 AND bowling_economy < 8.5 AND bowling_average < 22
    ORDER BY Wickets DESC;
-- We can see difference in outcome of above and As a good bowler taking wickets with good ecanomy has more impact.
-- We can see 4 bowler comes under this. they have bowled really well in IPL 2025.
-- you will see some deviation from online data en bowling economy or in average. Minor deviations (1-3 runs) on some players which causing deviation in calculation 
-- due to penalty runs or data entry inconsistencies in Kaggle dataset This is a data quality limitation, not a calculation error.

-- Now we will see top bowling performer in power play 1-6 over.
WITH table1 AS 
	(SELECT bowler, match_id,
			COUNT(CASE WHEN wicket_type NOT IN ('runout', 'retired out', 'retired hurt','') THEN 1 END) AS Wicket_taken,
			SUM(runs_of_bat + wide + noballs) AS run_conceded,
            COUNT(CASE WHEN wide = 0 AND noballs = 0 THEN 1 END) AS ball_bowled
	FROM ipl_2025_deliveries
    WHERE `over` < 6
    GROUP BY bowler, match_id)
SELECT bowler,
			ROUND(SUM(run_conceded)*6.0/NULLIF(SUM(ball_bowled),0),2) AS bowling_economy,
            CONCAT(FLOOR(SUM(ball_bowled)/6),'.',MOD(SUM(ball_bowled),6)) AS total_over,
            SUM(wicket_taken) AS wickets,
            ROUND(SUM(run_conceded)*1.0/NULLIF(SUM(wicket_taken),0),2) AS bowling_average
	FROM table1
    GROUP BY bowler
    ORDER BY wickets DESC
    limit 5;
-- Result show that Hazlewood is phenomenal in power play. Boult also has done well keeping bowling_economy under 8.5 and avergae around 25. Others top bowlers 
-- have high bowling average means either bowler is not taking wickets frequently or is expensive, making them less effective.


-- similarly we can analyse for middle overs by just changing one condition taking over between 7-15.
WITH table1 AS 
	(SELECT bowler, match_id,
			COUNT(CASE WHEN wicket_type NOT IN ('runout', 'retired out', 'retired hurt','') THEN 1 END) AS Wicket_taken,
			SUM(runs_of_bat + wide + noballs) AS run_conceded,
            COUNT(CASE WHEN wide = 0 AND noballs = 0 THEN 1 END) AS ball_bowled
	FROM ipl_2025_deliveries
    WHERE `over` BETWEEN 7 AND 15
    GROUP BY bowler, match_id)
SELECT bowler,
			ROUND(SUM(run_conceded)*6.0/NULLIF(SUM(ball_bowled),0),2) AS bowling_economy,
            CONCAT(FLOOR(SUM(ball_bowled)/6),'.',MOD(SUM(ball_bowled),6)) AS total_over,
            SUM(wicket_taken) AS wickets,
            ROUND(SUM(run_conceded)*1.0/NULLIF(SUM(wicket_taken),0),2) AS bowling_average
	FROM table1
    GROUP BY bowler
    ORDER BY wickets DESC
    limit 5;
    -- FROM OUTPUT we can see Noor Ahmad top performer taking highst wicket in middele with economy under 8 and bowling average around 17 only
    -- Kunal Pandya underrated as we can say performed well keeping economy 8 and average around 25, similary Varun Chakaravarthy have done well as well. 
    -- But here is a catch Kunal Pandya is not a specilist bowler he is allrounder.
    
    
-- Now lets talk about death bowling 
WITH table1 AS 
	(SELECT bowler, match_id,
			COUNT(CASE WHEN wicket_type NOT IN ('runout', 'retired out', 'retired hurt','') THEN 1 END) AS Wicket_taken,
			SUM(runs_of_bat + wide + noballs) AS run_conceded,
            COUNT(CASE WHEN wide = 0 AND noballs = 0 THEN 1 END) AS ball_bowled
	FROM ipl_2025_deliveries
    WHERE `over` > 15
    GROUP BY bowler, match_id)
SELECT bowler,
			ROUND(SUM(run_conceded)*6.0/NULLIF(SUM(ball_bowled),0),2) AS bowling_economy,
            CONCAT(FLOOR(SUM(ball_bowled)/6),'.',MOD(SUM(ball_bowled),6)) AS total_over,
            SUM(wicket_taken) AS wickets,
            ROUND(SUM(run_conceded)*1.0/NULLIF(SUM(wicket_taken),0),2) AS bowling_average
	FROM table1
    GROUP BY bowler
    ORDER BY wickets DESC
    limit 5;
-- Prasidh has taken the most wickets overall, but looking at economy rate, Bumrah is the true death overs specialist with an economy under 7 
-- while all other top performers are above 9.
-- This creates significant pressure on batsmen, forcing them to take risks against other bowlers.
-- So while Bumrah may have fewer wickets, he builds pressure that leads to dismissals at the other end — an impact that pure wicket counts don't capture.


-- Lets see most expensive bowlers in ipl2025
SELECT bowler,
	SUM(runs_of_bat + extras - byes - legbyes) AS runs_conceded
FROM ipl_2025_deliveries
GROUP BY bowler
ORDER BY runs_conceded DESC
Limit 10;

-- Again one disclaimer you will see some deviation from online data, minor deviations (1-3 runs) on some players due to penalty runs or data entry 
-- inconsistencies in Kaggle dataset This is a data quality limitation, not a calculation error.

