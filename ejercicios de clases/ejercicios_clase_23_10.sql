use baseDeDatosDelCuatri
-- Ejercicio 1

create procedure diaDeFacturasNoPagadas as
begin
	
	set @dia = datepart(weekday, @fecha=)
	select  factura_num, fecha_emision, dia
	from facturas
end