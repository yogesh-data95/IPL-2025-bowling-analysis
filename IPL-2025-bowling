# IPL 2025 SQL Analysis — Bowling Performance

This is part of my ongoing IPL 2025 ball-by-ball SQL analysis project. After completing the batting analysis, I wanted to dig into bowling because wickets alone don't tell the
full story in T20 cricket. A bowler with 20 wickets but an economy of 11 can actually hurt the team more than help.

Dataset: [Kaggle — IPL 2025 Ball by Ball Data](https://www.kaggle.com/datasets/sahiltailor/cricket-ball-by-ball-dataset)  
Tool: MySQL  
Rows: ~17,000 deliveries across 74 matches

---
# What I was trying to answer

- Who took the most wickets? (Purple Cap)
- But more importantly — who was actually effective? Wickets + economy + average together
- Which bowlers are powerplay specialists vs death over specialists?
- Is there a bowler who impacts the game without showing up in the wicket column?

---

# Edge Cases I Had to Solve

Before writing any query I had to think carefully about what "runs conceded" and "balls bowled" actually mean in cricket.

Balls bowled — you can't just use COUNT(*). Wides and no-balls are not legitimate deliveries so they shouldn't count as balls bowled. The correct approach:

```sql
COUNT(CASE WHEN wide = 0 AND noballs = 0 THEN 1 END) AS ball_bowled
```

Wickets** — run outs don't belong to the bowler. Neither do retired hurt or retired out. So COUNT(wicket_type) straight up gives wrong numbers. Fixed with:

```sql
COUNT(CASE WHEN wicket_type NOT IN ('runout', 'retired out', 'retired hurt', '') THEN 1 END)
```

Runs conceded — leg byes and byes are not the bowler's fault, they are charged to the fielding side. So the formula is:

```sql
SUM(runs_of_bat + wide + noballs) AS run_conceded
```

I verified this online and found minor deviations of 1-3 runs on some players exist due to penalty runs captured in the dataset's `extras` column that cannot be isolated 
without a dedicated column. This is a data quality limitation of the Kaggle dataset, not a calculation error.

---

# Results

# Purple Cap — Most Wickets in IPL 2025

| Bowler | Wickets |
|---|---|
| Prasidh | 26 |
| Noor Ahmad | 24 |
| Boult | 23 |
| Hazlewood | 22 |
| Arshdeep Singh | 22 |

Prasidh tops the chart but I wanted to know who was genuinely effective — so I added economy and average filters next.

---

# Overall Bowling Performance
Filters applied: Wickets > 10, Economy < 8.5, Bowling Average < 22

| Bowler | Economy | Overs | Wickets | Average |
|---|---|---|---|---|
| Prasidh | 8.25 | 59.0 | 25 | 19.48 |
| Noor Ahmad | 8.00 | 50.0 | 24 | 16.67 |
| Bumrah | 6.68 | 47.2 | 18 | 17.56 |
| Unadkat | 7.34 | 23.5 | 11 | 15.91 |

Only 4 bowlers passed all three filters across the entire tournament. Bumrah stands out with an economy of 6.68 — significantly better than everyone else. Noor Ahmad was 
the most consistent wicket taker with the best average among high-volume bowlers.

---

# Powerplay Bowling (Overs 1–6) — Top 5 by Wickets

| Bowler | Economy | Overs | Wickets | Average |
|---|---|---|---|---|
| Khaleel Ahmed | 8.92 | 37.0 | 10 | 33.00 |
| Hazlewood | 7.27 | 22.0 | 10 | 16.00 |
| Boult | 8.47 | 30.0 | 10 | 25.40 |
| Siraj | 8.32 | 40.0 | 9 | 37.00 |
| Chahar | 8.52 | 33.0 | 8 | 35.13 |

Hazlewood is the clear powerplay specialist here. Same wicket count as Khaleel but in fewer overs with a significantly better average (16 vs 33). Quality over quantity.

---

# Middle Overs Bowling (Overs 7–15) — Top 5 by Wickets

| Bowler | Economy | Overs | Wickets | Average |
|---|---|---|---|---|
| Noor Ahmad | 7.91 | 33.0 | 15 | 17.40 |
| Sai Kishore | 9.13 | 32.0 | 14 | 20.86 |
| Varun Chakaravarthy | 8.10 | 30.0 | 10 | 24.30 |
| Kuldeep Yadav | 7.41 | 41.0 | 10 | 30.40 |
| Krunal Pandya | 8.00 | 32.0 | 10 | 25.60 |

Noor Ahmad dominated the middle overs — 15 wickets with an economy under 8 and average of 17.40 is exceptional for this phase. What surprised me here is Krunal Pandya 
— he is not a specialist bowler, he is an allrounder, yet he finished among the top 5 middle overs performers in the tournament.

---

# Death Overs Bowling (Overs 16–20) — Top 5 by Wickets

| Bowler | Economy | Overs | Wickets | Average |
|---|---|---|---|---|
| Prasidh | 9.94 | 18.0 | 15 | 11.93 |
| Arshdeep Singh | 9.57 | 19.2 | 11 | 16.82 |
| Pathirana | 10.49 | 23.5 | 10 | 25.00 |
| Bumrah | 6.98 | 16.2 | 10 | 11.40 |
| Boult | 9.19 | 15.4 | 10 | 14.40 |

This is where it gets interesting. Prasidh has the most death over wickets but Bumrah has an economy of 6.98 while every other bowler in this list is above 9. 
That is a massive difference in T20 cricket.

Bumrah may have fewer wickets than Prasidh, but an economy under 7 in death overs creates enormous pressure on batsmen. When teams can only score at 7 per over off
Bumrah, they are forced to attack the other end — which is likely why Prasidh and Arshdeep's wicket counts are inflated. Bumrah's impact doesn't show up fully in the 
wicket column but it shows up in how the team performs around him.

---

# Key Takeaways

- Prasidh was the highest wicket taker but Bumrah was the most economical bowler in the tournament by a significant margin
- Noor Ahmad was the standout middle overs bowler — consistent, economical, and effective
- Hazlewood was the best powerplay option when you balance wickets and economy together
- Only 4 bowlers in the entire tournament passed all three quality filters — shows how hard it is to be consistently effective across a full IPL season
