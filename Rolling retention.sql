
WITH tab as(
    SELECT
        ue.user_id, 
        to_char(date_joined, 'YYYY-MM') as cohort,
        /*Пользователей разбиваем по когортам - так намного показательней. 
        В качестве признака когорты берем месяц регистрации пользователя.*/
        extract(days from ue.entry_at-u.date_joined) as diff
    FROM users u join UserEntry ue
    ON u.id=ue.user_id
    where to_char(date_joined, 'YYYY') = '2022'
  )
SELECT cohort,
    count(DISTINCT CASE when diff>=0 then user_id end)*100.0/ count(DISTINCT case when diff>=0 then user_id end) as "0 day",
    round(count(DISTINCT CASE when diff>=1 then user_id end)*100.0/ 
count (DISTINCT CASE when diff>=0 then user_id end), 2) as "1 day",
    round(count(DISTINCT CASE when diff>=3 then user_id end)*100.0/ 
count (DISTINCT CASE when diff>=0 then user_id end), 2) as "3 day",
    round(count(DISTINCT CASE when diff>=7 then user_id end)*100.0/ 
count (DISTINCT CASE when diff>=0 then user_id end), 2) as "7 day",
    round(count(DISTINCT CASE when diff>=14 then user_id end)*100.0/ 
count (DISTINCT CASE when diff>=0 then user_id end), 2) as "14 day",
    round(count(DISTINCT CASE when diff>=30 then user_id end)*100.0/ 
count (DISTINCT CASE when diff>=0 then user_id end), 2) as "30 day",
    round(count(DISTINCT CASE when diff>=60 then user_id end)*100.0/ 
count (DISTINCT CASE when diff>=0 then user_id end), 2) as "60 day",
    round(count(DISTINCT CASE when diff>=90 then user_id end)*100.0/ 
count (DISTINCT CASE when diff>=0 then user_id end), 2) as "90 day"
FROM tab t
group by cohort
