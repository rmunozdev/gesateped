/**
 * 
 */
function crearTablaPedidosPendientes(paths) {
	$('#tblPedidosPendientes').dataTable(
			$.extend( true, {}, null,{
			 'aaData'   : {},
	         'aoColumnDefs': [ {
	              'aTargets': [3],
	              'mData': null, 
	              'mRender' : function (data, type, row) {
	            	  var cadenaBoton = "&nbsp;<img src='"+paths.marker+"' title='Editar' class='location-marker'>";
	                  return cadenaBoton;
	              }
	          } ],
	        'aoColumns': [
		        { 'mData': 'codigoPedido'},
		        { 'mData': 'horaInicioVentana'},
		        { 'mData': 'fechaPactadaDespacho',"defaultContent":"<i>Unset</i>"},
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
	    }));
}

function actualizarTablaPedidosPendientes(data,codigoHojaRuta) {
	if(data.length>0) {
		var oTable = $('#tblPedidosPendientes').dataTable();
		oTable.fnClearTable();
		oTable.fnAddData(data);
		oTable.fnDraw();
		oTable.fnPageChange('first');
		localforage.getItem(codigoHojaRuta)
			.then(unidad => {
				console.log("Estableciendo unidad: " ,unidad);
				localforage.setItem("unidadSeleccionada",unidad);
		});
	}
}

function iniciarMonitoreo(aData) {
	console.log(aData);
	localforage.getItem("unidadSeleccionada").then((unidadSeleccionada)=>{
		console.log(unidadSeleccionada);
	});
	
	var direccion;
	if(aData.direccionCliente && aData.distritoCliente) {
		console.log("Se usara direccion de cliente");
		direccion = aData.direccionCliente +" "+ aData.distritoCliente + " Peru";
	} else if(aData.direccionTienda && aData.distritoTienda){
		console.log("Se usara direccion de tienda");
		direccion = aData.direccionTienda +" "+ aData.distritoTienda + " Peru";
	}
	
	
	const geocoder = new google.maps.Geocoder();
	geocoder.geocode({address: direccion}, (results, status) =>{
		if (status === 'OK') {
			const map = new google.maps.Map(document.getElementById('pedidoMap'), {
				zoom: 16,
				disableDefaultUI: true,
				disableDoubleClickZoom: true,
				center: results[0].geometry.location
			});
			
		    const marker = new google.maps.Marker({
		        map: map,
		        position: results[0].geometry.location,
		        title: "Google I/O",
		        optimized: false
		      });
		    initTracking(map,direccion);
		} else {
		      console.log(
		        'Geocode was not successful for the following reason: ' + status
		      );
		}
	});
	$('div#pedidoMap').dialog();
}
