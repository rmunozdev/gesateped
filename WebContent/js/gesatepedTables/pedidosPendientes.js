/**
 * 
 */
function crearTablaPedidosPendientes(paths) {
	$('#tblPedidosPendientes').dataTable(
			{
				 'bPaginate':  false,
				 'bFilter'	: false,
				 'bInfo': false,
				 'bSort': false,
				 'bAutoWidth': false,
				 'aaData'   : {},
		         'aoColumnDefs': [ {
		              'aTargets': [2],
		              'mData': null, 
		              'mRender' : function (data, type, row,position) {
		            	  if(position.row == 0) {
		            		  var cadenaBoton = "&nbsp;<img src='"+paths.marker+"' title='Editar' class='location-marker'>";
		            		  return cadenaBoton;
		            	  } else {
		            		  return "";
		            	  }
		              }
		          	}, {
		          		'aTargets' : [1],
		          		'mData': null,
		          		'mRender': function (data,type,row) {
		          			return data.horaInicioVentana + " a " + data.horaFinVentana;
		          		}
		          	}
		         ],
		        'aoColumns': [
			        { 'mData': 'codigoPedido'},
			        {},
			        {}
				],
				'fnRowCallback': function( nRow, aData, iDataIndex ) {
					$(nRow).find('img.location-marker').unbind('click');
					$(nRow).find('img.location-marker').click(function(){
						iniciarMonitoreo(aData);
					});
				}, 
		         "fnDrawCallback": function () {
		 			
		          },
		          "oLanguage": {
		              "sEmptyTable": "No se encontraron pedidos pendientes"
		          }
		    });
}

function actualizarTablaPedidosPendientes(data,codigoHojaRuta) {
	var oTable = $('#tblPedidosPendientes').dataTable();
	oTable.fnClearTable();
	if(data.length>0) {
		oTable.fnAddData(data);
	}
	oTable.fnDraw();
	oTable.fnPageChange('first');
}

function iniciarMonitoreo(aData) {
	var direccion;
	//TODO rmunozdev Actualizar lógica
	if(aData.direccionCliente && aData.distritoCliente) {
		console.log("Se usara direccion de cliente");
		direccion = aData.direccionCliente +" "+ aData.distritoCliente + " Peru";
	} else if(aData.direccionTienda && aData.distritoTienda){
		console.log("Se usara direccion de tienda");
		direccion = aData.direccionTienda +" "+ aData.distritoTienda + " Peru";
	}
	
	//Requerido por simulador.js
	localforage.setItem("destinoSeleccionado",{
		pedido: aData.codigoPedido,
		destino: direccion
	}).then(()=>{
		const geocoder = new google.maps.Geocoder();
		geocoder.geocode({address: direccion}, (results, status) =>{
			if (status === 'OK') {
				const map = new google.maps.Map(document.getElementById('monitoreoMap'), {
					zoom: 16,
					disableDefaultUI: true,
					disableDoubleClickZoom: true,
					center: results[0].geometry.location
				});
				//Se crean marcas para origen y destino
				localforage.getItem("unidadSeleccionada")
					.then(unidadSeleccionada=>{
						let pedido = {
								codigoPedido: aData.codigoPedido,
								codigoHojaRuta: unidadSeleccionada.codigoHojaRuta,
								unidadAsignada: {
									numeroPlaca: unidadSeleccionada.unidad.placa
								}
						};
						obtenerPuntoDePartida(pedido).then(origen=>{
							
							const destinoMarker = new google.maps.Marker({
								  position: {
									  lat: results[0].geometry.location.lat(),
									  lng: results[0].geometry.location.lng()
								  },
								  map: map,
								  title: "Destino",
								  optimized: false,
								  label: {
									    color: 'red',
									    fontWeight: 'bold',
									    text: aData.codigoPedido
									  },
								  icon: {
									  labelOrigin: new google.maps.Point(11, 50),
									    url: 'https://maps.gstatic.com/mapfiles/api-3/images/spotlight-poi-dotless2.png',
									    size: new google.maps.Size(32, 40),
									    origin: new google.maps.Point(0, 0),
									    anchor: new google.maps.Point(11, 40)
								  }
							 });
							
							var origenMarker = new google.maps.Marker({
						        position:  new google.maps.LatLng(origen.lat, origen.lng),
						        map: map,
						        title: 'Partida',
						        label: {
								    color: 'red',
								    fontWeight: 'bold',
								    text: "Partida"
								},
						        icon: {
						        	  labelOrigin: new google.maps.Point(50, 25),
									  url: 'https://maps.gstatic.com/mapfiles/api-3/images/spotlight-poi-dotless2.png',
									  size: new google.maps.Size(32, 40),
									  origin: new google.maps.Point(0, 0),
									  anchor: new google.maps.Point(11,40)
								
								},
						 });
							
							initTracking(map,direccion);
						});
				});
			} else {
				console.log(
						'Geocode was not successful for the following reason: ' + status
				);
			}
			
			//Se activan opciones para simular
			
			
			var title = `<div>
			<img src="${_globalContextPath}/images/sodimaclogo-title.jpg" class="dialog-sodimac">
				<span class="dialog-sodimac-title">UBICACIÓN ACTUAL DE LA UNIDAD</span>
				</div>`;
			//Se detiene autorefresh
			stopAutoRefresh();
			let simulador = new Simulador($("#iniciarSimBtn"),$("#detenerSimBtn"),$("#continuarSimBtn"));
			
			
			$('div#dialogMap').dialog({
				title: title,
				maxWidth:600,
		        maxHeight: 612,
				width: 550,
		        height: 590,
		        modal: true,
		        closeOnEscape: false,
		        close: function() {
		        	console.log("Se detiene simulacion(si se inicio)");
		        	simulador.cancelar();
		        	//Se inicia autorefresh al cerrar
		        	localforage.getItem("unidadSeleccionada").then(unidadSeleccionada=>{
		        		startAutoRefresh(unidadSeleccionada.codigoHojaRuta);
		        	});
		        }
		    });
		});
	});
}
