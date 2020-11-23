

select sale_id,
       sum,
       sum_with_out_nds,
       staff_id,
       quarter_id,
       room_id,
       client_id,
       status_contract_id
from sale_fact;


select quarter_id, sum_cost, cost_with_out_nds, type_service_id, client_id, sale_fact_id
from service_fact;


select booking_id, quarter_id, id_status_booking, room_id, count_booking, client_id
from repo_hotel.booking;