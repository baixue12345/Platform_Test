set @mobile = '13525253434';

delete from schema_component where schema_id in (

select id from custom_schema where base_schema_id in (

select id from base_schema where customer_id in (

select id from customer where mobile = @mobile

)

)

);



delete from schema_component where schema_id in (

select id from base_schema where customer_id in (

select id from customer where mobile = @mobile

)

);



delete from custom_schema where base_schema_id in (

select id from base_schema where customer_id in (

select id from customer where mobile = @mobile

)

);



delete from base_schema where customer_id in (

select id from customer where mobile = @mobile

);
