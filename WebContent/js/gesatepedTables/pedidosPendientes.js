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
		            		  var cadenaBoton = "&nbsp;<img src='"+paths.marker+"' title='Abrir Popup' class='location-marker'>";
		            		  return cadenaBoton;
		            	  } else {
		            		  return "";
		            	  }
		              }
		          	}, {
		          		'aTargets' : [1],
		          		'mData': null,
		          		'mRender': function (data,type,row) {
		          			return tConvert(data.horaInicioVentana) + " a " + tConvert(data.horaFinVentana);
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
	var direccion = aData.direccionDespacho + ' ' + aData.distritoDespacho;
	//Se establece panel:
	document.getElementById('endLbl').innerHTML = direccion;
	//Requerido por simulador.js
	localforage.setItem("destinoSeleccionado",{
		pedido: aData.codigoPedido,
		destino: direccion
	}).then(()=>{
		const geocoder = new google.maps.Geocoder();
		geocoder.geocode({address: direccion + " Peru"}, (results, status) =>{
			if (status === 'OK') {
				const map = new google.maps.Map(document.getElementById('monitoreoMap'), {
					zoom: 16,
					disableDefaultUI: true,
					disableDoubleClickZoom: true,
					center: results[0].geometry.location,
					styles: [
				          {
				            featureType: "transit.station.bus",
				            stylers: [
				              { visibility: "off" }
				            ]
				          },
				          {
				        	  featureType: "poi.business",
				        	  stylers: [
				        		  { visibility: "off" }
				        		  ]
				          }
				    ]
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
							
							let destinoLat = results[0].geometry.location.lat();
							let destinoLng = results[0].geometry.location.lng();
							if(origen.lat == destinoLat && origen.lng == destinoLng) {
								$("#iniciarSimBtn").hide();
								$("#unavailableSimBtn").show();
								$('#distanceLbl').html("0 m");
								$('#timeLbl').html("0 minutos");
								console.log("Destino y origen coinciden!!!!");
								createMarker(origen.lat,origen.lng,map,aData.codigoPedido,aData.codigoPedido,11, 50);
								showDialog(null);
							} else {
								$("#unavailableSimBtn").hide();
								$("#iniciarSimBtn").show();
								createMarker(origen.lat,origen.lng,map,'Partida','Partida',50, 25);
								createMarker(destinoLat,destinoLng,map,'Destino',aData.codigoPedido,11, 50);
								initTracking(map,direccion);
								//Se detiene autorefresh
								stopAutoRefresh();
								let simulador = new Simulador($("#iniciarSimBtn"),$("#detenerSimBtn"),$("#continuarSimBtn"));
								showDialog(simulador);
							}
							
						});
				});
			} else {
				console.log(
						'Geocode was not successful for the following reason: ' + status
				);
			}
		});
	});
}

function createMarker(lat,lng,map,title,label,labelOffsetX,labelOffsetY) {
	return new google.maps.Marker({
        position:  {
        	lat: lat, 
        	lng: lng
        },
        map: map,
        title: title,
        label: {
		    color: 'red',
		    fontWeight: 'bold',
		    text: label
		},
        icon: {
        	  labelOrigin: new google.maps.Point(labelOffsetX, labelOffsetY),
			  url: 'https://maps.gstatic.com/mapfiles/api-3/images/spotlight-poi-dotless2.png',
			  size: new google.maps.Size(32, 40),
			  origin: new google.maps.Point(0, 0),
			  anchor: new google.maps.Point(11,40)
		
		},
 });
}

function showDialog(simulador) {
	var title = `<div>
		<img src="${_globalContextPath}/images/sodimaclogo-title.jpg" class="dialog-sodimac">
			<span class="dialog-sodimac-title">UBICACIÓN ACTUAL DE LA UNIDAD</span>
			</div>`;
	$('div#dialogMap').dialog({
		title: title,
		maxWidth:600,
        maxHeight: 600,
		width: 550,
        height: 580,
        modal: true,
        closeOnEscape: false,
        close: function() {
        	console.log("Se detiene simulación(si se inicio)");
        	if(simulador) {
        		simulador.cancelar();
        	}
        	//Se inicia autorefresh al cerrar
        	localforage.getItem("unidadSeleccionada").then(unidadSeleccionada=>{
        		startAutoRefresh(unidadSeleccionada.codigoHojaRuta);
        	});
        	$('div#dialogMap#monitoreoMap').html("");
        }
    });
}
