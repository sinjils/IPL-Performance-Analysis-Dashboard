CREATE database
ipl_analysis;
use ipl_analysis;
show tables;
select count(*) from matches;
select count(*) from deliveries;
select *from matches limit 5;
select * from deliveries limit 5;

select count(*) as total_matches from matches;
SELECT COUNT(DISTINCT season) AS total_seasons
FROM matches;
SELECT team1,
       COUNT(*) AS matches_played
FROM matches
GROUP BY team1
ORDER BY matches_played DESC;
SELECT winner,
       COUNT(*) AS matches_won
FROM matches
WHERE winner IS NOT NULL
GROUP BY winner
ORDER BY matches_won DESC;
SELECT player_of_match,
       COUNT(*) AS awards
FROM matches
WHERE player_of_match IS NOT NULL
GROUP BY player_of_match
ORDER BY awards DESC
LIMIT 10;
SELECT venue,
       COUNT(*) AS matches_hosted
FROM matches
GROUP BY venue
ORDER BY matches_hosted DESC
LIMIT 10;
SELECT batter,
       SUM(batsman_runs) AS total_runs
FROM deliveries
GROUP BY batter
ORDER BY total_runs DESC
LIMIT 10;

SELECT *
FROM deliveries
LIMIT 5;
SELECT bowler,
       SUM(is_wicket) AS wickets
FROM deliveries
GROUP BY bowler
ORDER BY wickets DESC
LIMIT 10;
SELECT batter,
       COUNT(*) AS sixes
FROM deliveries
WHERE batsman_runs = 6
GROUP BY batter
ORDER BY sixes DESC
LIMIT 10;
SELECT batter,
       COUNT(*) AS fours
FROM deliveries
WHERE batsman_runs = 4
GROUP BY batter
ORDER BY fours DESC
LIMIT 10;
SELECT batter,
       SUM(batsman_runs) AS total_runs
FROM deliveries
GROUP BY batter
HAVING total_runs > 2000
ORDER BY total_runs DESC;
SELECT batter,
       AVG(batsman_runs) AS average_runs
FROM deliveries
GROUP BY batter
HAVING COUNT(*) >= 500
ORDER BY average_runs DESC
LIMIT 10;
SELECT
    m.season,
    COUNT(d.match_id) AS total_deliveries
FROM matches AS m
INNER JOIN deliveries AS d
ON m.id = d.match_id
GROUP BY m.season
ORDER BY m.season;
SELECT
    m.season,
    SUM(d.total_runs) AS total_runs
FROM matches AS m
INNER JOIN deliveries AS d
ON m.id = d.match_id
GROUP BY m.season
ORDER BY m.season;
SELECT
    winner,
    COUNT(*) AS matches_won
FROM matches
WHERE winner IS NOT NULL
GROUP BY winner
ORDER BY matches_won DESC;
SELECT
    m.batting_team,
    SUM(m.total_runs) AS total_runs
FROM deliveries AS m
GROUP BY m.batting_team
ORDER BY total_runs DESC;
SELECT
    team.team_name,
    COUNT(m.id) AS matches_played
FROM
(
    SELECT team1 AS team_name FROM matches
    UNION ALL
    SELECT team2 AS team_name FROM matches
) AS team
LEFT JOIN matches AS m
ON team.team_name = m.team1 OR team.team_name = m.team2
GROUP BY team.team_name
ORDER BY matches_played DESC;
SELECT
    m.venue,
    SUM(d.total_runs) AS total_runs
FROM matches AS m
INNER JOIN deliveries AS d
ON m.id = d.match_id
GROUP BY m.venue
ORDER BY total_runs DESC
LIMIT 10;
SELECT
    batter,
    CASE
        WHEN SUM(batsman_runs) >= 3000 THEN 'Legend'
        WHEN SUM(batsman_runs) >= 2000 THEN 'Star'
        ELSE 'Regular'
    END AS player_category
FROM deliveries
GROUP BY batter
ORDER BY SUM(batsman_runs) DESC
LIMIT 10;
SELECT batter,
       SUM(batsman_runs) AS total_runs
FROM deliveries
GROUP BY batter
HAVING SUM(batsman_runs) >
(
    SELECT AVG(player_runs)
    FROM
    (
        SELECT SUM(batsman_runs) AS player_runs
        FROM deliveries
        GROUP BY batter
    ) AS player_totals
)
ORDER BY total_runs DESC;
SELECT
    batter,
    SUM(batsman_runs) AS total_runs,
    RANK() OVER (ORDER BY SUM(batsman_runs) DESC) AS player_rank
FROM deliveries
GROUP BY batter;
SELECT
    batter,
    SUM(batsman_runs) AS total_runs,
    ROW_NUMBER() OVER (ORDER BY SUM(batsman_runs) DESC) AS row_num,
    RANK() OVER (ORDER BY SUM(batsman_runs) DESC) AS rank_num,
    DENSE_RANK() OVER (ORDER BY SUM(batsman_runs) DESC) AS dense_rank_num
FROM deliveries
GROUP BY batter;
SELECT season,
       batter,
       total_runs
FROM
(
    SELECT
        m.season,
        d.batter,
        SUM(d.batsman_runs) AS total_runs,
        DENSE_RANK() OVER
        (
            PARTITION BY m.season
            ORDER BY SUM(d.batsman_runs) DESC
        ) AS player_rank
    FROM matches AS m
    INNER JOIN deliveries AS d
        ON m.id = d.match_id
    GROUP BY m.season, d.batter
) AS ranked_players
WHERE player_rank <= 3
ORDER BY season, player_rank;
SELECT
    season,
    bowler,
    wickets
FROM
(
    SELECT
        m.season,
        d.bowler,
        SUM(d.is_wicket) AS wickets,
        DENSE_RANK() OVER
        (
            PARTITION BY m.season
            ORDER BY SUM(d.is_wicket) DESC
        ) AS bowler_rank
    FROM matches AS m
    INNER JOIN deliveries AS d
        ON m.id = d.match_id
    GROUP BY m.season, d.bowler
) AS ranked_bowlers
WHERE bowler_rank = 1
ORDER BY season;
SELECT
    winner,
    COUNT(*) AS matches_won,
    ROUND(
        COUNT(*) * 100.0 /
        (
            SELECT COUNT(*)
            FROM matches m2
            WHERE m2.team1 = m1.winner
               OR m2.team2 = m1.winner
        ),
        2
    ) AS win_percentage
FROM matches m1
WHERE winner IS NOT NULL
GROUP BY winner
ORDER BY win_percentage DESC;
SELECT
    winner,
    COUNT(*) AS matches_won
FROM matches
GROUP BY winner;
SELECT
    m.id AS match_id,
    m.season,
    m.team1,
    m.team2,
    SUM(d.total_runs) AS total_match_runs
FROM matches AS m
INNER JOIN deliveries AS d
ON m.id = d.match_id
GROUP BY m.id, m.season, m.team1, m.team2
ORDER BY total_match_runs DESC
LIMIT 10;
SELECT
    batter,
    SUM(batsman_runs) AS total_runs
FROM deliveries
GROUP BY batter
ORDER BY total_runs DESC;
SELECT
    batter,
    SUM(batsman_runs) AS total_runs
FROM deliveries
GROUP BY batter
ORDER BY total_runs DESC;
SELECT
    bowler,
    SUM(is_wicket) AS total_wickets
FROM deliveries
GROUP BY bowler
ORDER BY total_wickets DESC;
SELECT
    batter,
    COUNT(*) AS sixes
FROM deliveries
WHERE batsman_runs = 6
GROUP BY batter
ORDER BY sixes DESC;
SELECT
    batter,
    COUNT(*) AS fours
FROM deliveries
WHERE batsman_runs = 4
GROUP BY batter
ORDER BY fours DESC;
SELECT
    winner,
    COUNT(*) AS wins,
    ROUND(
        COUNT(*) * 100.0 /
        (
            SELECT COUNT(*)
            FROM matches m2
            WHERE m2.team1 = matches.winner
               OR m2.team2 = matches.winner
        ),
        2
    ) AS win_percentage
FROM matches
WHERE winner IS NOT NULL
GROUP BY winner
ORDER BY win_percentage DESC;
SELECT
    m.id,
    m.season,
    m.team1,
    m.team2,
    SUM(d.total_runs) AS total_match_runs
FROM matches m
JOIN deliveries d
ON m.id = d.match_id
GROUP BY m.id, m.season, m.team1, m.team2
ORDER BY total_match_runs DESC
LIMIT 10;
SELECT
    season,
    batter,
    total_runs
FROM
(
    SELECT
        m.season,
        d.batter,
        SUM(d.batsman_runs) AS total_runs,
        DENSE_RANK() OVER (
            PARTITION BY m.season
            ORDER BY SUM(d.batsman_runs) DESC
        ) AS player_rank
    FROM matches m
    JOIN deliveries d
        ON m.id = d.match_id
    GROUP BY m.season, d.batter
) ranked_players
WHERE player_rank <= 3
ORDER BY season, player_rank;
SELECT
    season,
    bowler,
    total_wickets
FROM
(
    SELECT
        m.season,
        d.bowler,
        SUM(d.is_wicket) AS total_wickets,
        DENSE_RANK() OVER (
            PARTITION BY m.season
            ORDER BY SUM(d.is_wicket) DESC
        ) AS bowler_rank
    FROM matches m
    JOIN deliveries d
        ON m.id = d.match_id
    GROUP BY m.season, d.bowler
) ranked_bowlers
WHERE bowler_rank <= 3
ORDER BY season, bowler_rank;

SELECT
    bowler,
    ROUND((SUM(total_runs) * 6.0) / COUNT(*), 2) AS economy
FROM deliveries
GROUP BY bowler
HAVING COUNT(*) >= 1800
ORDER BY economy ASC
LIMIT 10;

