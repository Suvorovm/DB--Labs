select   DISTINCT  EXTRACT(YEAR FROM  end_date) from contract;





select * from client
 where client.id_ur_person <> 1;


select count(*), * from client
    where client.id_ur_person <> 1;


select * from year;

select * from repository_hotel.repo_hotel.year