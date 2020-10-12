SELECT mark as "Оценка", count(mark)/*, COALESCE(mark, 'Total furniture price') AS mark*/
    from feedback
    group by rollup(mark)
    order by mark ASC;





