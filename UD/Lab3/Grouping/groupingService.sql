/*
UTF-8
Вбрать клиентов у которых была скидка  в какой либо позиции счета b gjcxbnfnm cevve
ALERT
*/



    select c.id_client, (d.diss_person / 100) * s.service_cost as disc, c.name as client, grouping(c.id_client), sum(s.service_cost )  from contract
        inner join client c on c.id_client = contract.id_client
        inner join bilt_position bp on contract.id_contract = bp.id_contract
        inner join disscount d on d.id_disscount = bp.id_disscount
        inner join service s on bp.id_service = s.id_service
        group by  rollup(c.id_client, c.name, d.diss_person, s.service_cost)

