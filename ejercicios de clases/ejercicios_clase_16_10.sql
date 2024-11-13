-- EJERCICIO 1
create trigger borrar_cliente_trigger
	on clientes
	instead of delete as
		begin
			update clientes
			set estado = 'I'
			where cliente_num in (select cliente_num from deleted)
		end

go

-- EJERCICIO 2
 create trigger borrar_detalle_trigger
	on facturas
	instead of delete as
		begin
			if (select count(factura_num) from deleted) > 1
				begin 
					print 'Nro. Error: ' + cast(error_number() as varchar);
					print 'mensaje: ' + error_message();
					print 'estado: ' + cast(error_state() as varchar);
					throw 50000, 'Se intentó borrar mas de una factura', 1
				end

			declare @factura_num_borrar int
			select @factura_num_borrar = factura_num from deleted

			delete from facturas_det
			where factura_num = @factura_num_borrar

			delete from facturas
			where factura_num = @factura_num_borrar
		end

go

-- EJERCICIO 3
create view ProductosFabricanteV as
	select prod.producto_cod, prod.producto_desc, prod.precio_unit, prod.fabricante_cod, fab.fabricante_nom, fab.provincia_cod 
	from productos prod
		join fabricantes fab
			on prod.fabricante_cod = fab.fabricante_cod

go

create trigger insertar_en_view_trigger
	on ProductosFabricanteV
	instead of insert as
	begin
		-- se declara el cursor
		declare curIns cursor for
			SELECT producto_cod, producto_desc, precio_unit, fabricante_cod, fabricante_nom, provincia_cod
			from inserted;

		-- se declaran las variables que almacenaran cada iteracion del cursor
		declare @producto_cod smallint, @producto_desc varchar(30), @precio_unit decimal(10,2), @fabricante_cod varchar(5), @fabricante_nom varchar(59), @provincia_cod varchar(2)
 
		--abrir cursor
		OPEN curIns

		-- primera iteracion, guardo la primer fila en las variables
		fetch curIns into @producto_cod, @producto_desc, @precio_unit, @fabricante_cod, @fabricante_nom, @provincia_cod;

		While (@@FETCH_STATUS=0) --mientras haya filas por leer en la tabla de inserted
			begin
				--valida que exista la provincia, sino lanza error
				if not exists (select provincia_cod from provincias
								where provincia_cod = @provincia_cod)
					begin
						print 'Nro. Error: ' + cast(error_number() as varchar);
						print 'mensaje: ' + error_message();
						print 'estado: ' + cast(error_state() as varchar);
						throw 50000, 'La provincia no existe', 1
					end
				--valida que exista el fabricante, sino lo agrega
				if not exists (select fabricante_cod from fabricantes
								where fabricante_cod = @fabricante_cod)
					begin
						insert into fabricantes (fabricante_cod, fabricante_nom, tiempo_entrega, provincia_cod)
						values (@fabricante_cod, @fabricante_nom,1, @provincia_cod);
					end
				---post validar que exista la provincia y agregar o validar los fabricantes, agrega el producto
				insert into productos (producto_cod, producto_desc, precio_unit, fabricante_cod)
				values(@producto_cod, @producto_desc, @precio_unit, @fabricante_cod);
				-- busca la fila siguiente
				fetch curIns into @producto_cod, @producto_desc, @precio_unit, @fabricante_cod, @fabricante_nom, @provincia_cod;
			end
		--cerrar y liberar cursor
		close curIns
		DEALLOCATE curIns
	end

go

-- EJERCICIO 4
create trigger cambio_precio_trigger
	on productos
	after update as
	begin 
		if exists (select producto_cod from Precios_hist 
					where producto_cod = (select producto_cod from deleted) and
					      fechaDde = (select ))
			begin
				update Precios_hist
				set precio_unit = (select precio_unit from deleted),
					fechaDde = (select fechaHta from Precios_hist 
								where producto_cod = (select producto_cod from deleted) and
									  fechaDde = (select fechaDde from deleted)

			end
	end