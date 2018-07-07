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
		              "sEmptyTable":     "My Custom Message On Empty Table"
		          }
		    });
}

function actualizarTablaPedidosPendientes(data,codigoHojaRuta) {
	if(data.length>0) {
		var oTable = $('#tblPedidosPendientes').dataTable();
		oTable.fnClearTable();
		oTable.fnAddData(data);
		oTable.fnDraw();
		oTable.fnPageChange('first');
	}
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
				const map = new google.maps.Map(document.getElementById('pedidoMap'), {
					zoom: 16,
					disableDefaultUI: true,
					disableDoubleClickZoom: true,
					center: results[0].geometry.location
				});
				
				initTracking(map,direccion);
			} else {
				console.log(
						'Geocode was not successful for the following reason: ' + status
				);
			}
			
			$('div#pedidoMap').dialog({
				maxWidth:600,
		        maxHeight: 500,
				width: 600,
		        height: 500,
		        modal: true,
		        buttons: [
		        	{
		        		text : "Iniciar Simulación",
		        		click : function() {
		        			establecerParadasRuta().then(()=>{
		        				simularMovimiento();
		        			});
		        		} 
		        	}
		        ]
		    });
		});
	});
}
