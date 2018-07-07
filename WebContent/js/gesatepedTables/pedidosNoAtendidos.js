/**
 * 
 */
function crearTablaPedidosNoAtendidos(paths) {
	$('#tblPedidosNoAtendidos').dataTable(
			{
				'bPaginate':  false,
				 'bFilter'	: false,
				 'bInfo': false,
				 'bSort': false,
				 'bAutoWidth': false,
				 'aaData'   : {},
		         'aoColumnDefs': [ {
		              'aTargets': [4],
		              'mData': null, 
		              'mRender' : function (data, type, row) {
		            	  var cadenaBoton = "&nbsp;<img src='"+
		            	  	paths.marker +
		            	  	"' title='Editar' class='location-marker'>";
		                  return cadenaBoton;
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
			        { 'mData': 'fechaNoCumplimientoDespacho',"defaultContent":"<i>--</i>"},
			        { 'mData': 'descripcionMotivoPedido',"defaultContent":"<i>--</i>"},
			        {}
				],
				'fnRowCallback': function( nRow, aData, iDataIndex ) {
					$(nRow).find('img.location-marker').unbind('click');
					$(nRow).find('img.location-marker').click(function(){
						localizarNoAtendido(aData);
					});
					
				}, 
		         "fnDrawCallback": function () {
		 			
		          },
		          "oLanguage": {
		              "sEmptyTable":     "No se encontraron pedidos no atendidos"
		          }
		    });
}

function actualizarTablaPedidosNoAtendidos(data) {
	if(data.length>0) {
		var oTable = $('#tblPedidosNoAtendidos').dataTable();
		oTable.fnClearTable();
		oTable.fnAddData(data);
		oTable.fnDraw();
		oTable.fnPageChange('first');
	}
}

function localizarNoAtendido(aData) {
	console.log("Localizando..",aData);
	var direccion;
	
	//TODO rmunozdev Actualizar lógica
	if(aData.direccionCliente && aData.distritoCliente) {
		console.log("Se usara direccion de cliente");
		direccion = aData.direccionCliente +" "+ aData.distritoCliente + " Peru";
	} else if(aData.direccionTienda && aData.distritoTienda){
		console.log("Se usara direccion de tienda");
		direccion = aData.direccionTienda +" "+ aData.distritoTienda + " Peru";
	}
	console.log("direccion",direccion);
	const geocoder = new google.maps.Geocoder();
	geocoder.geocode({address: direccion}, (results, status) =>{
		if (status === 'OK') {
			const url = _globalContextPath + colorToUnidadMarker('FFAD00');
			const map = new google.maps.Map(document.getElementById('pedidoMap'), {
				zoom: 15,
				disableDefaultUI: true,
				disableDoubleClickZoom: true,
				center: results[0].geometry.location
			});
			
			 const pedidoMarker = new google.maps.Marker({
				  position: {
					  lat: results[0].geometry.location.lat(),
					  lng: results[0].geometry.location.lng()
				  },
				  map: map,
				  title: aData.codigoPedido,
				  optimized: false,
				  label: {
					    color: 'blue',
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
			 
			 localforage.getItem("unidadSeleccionada").then((unidadSeleccionada)=>{
				 var unidadMarker = new google.maps.Marker({
				        position:  new google.maps.LatLng(aData.latitudGpsDespacho, aData.longitudGpsDespacho),
				        map: map,
				        title: 'Posicion de unidad',
				        label: {
						    color: 'blue',
						    fontWeight: 'bold',
						    text: unidadSeleccionada.unidad.placa
						},
				        icon: {
				        	  labelOrigin: new google.maps.Point(11, 50),
							  url: url,
							  size: new google.maps.Size(50, 50),
							  origin: new google.maps.Point(0, 0),
							  anchor: new google.maps.Point(30,30)
						
						},
				 });
			 });
		} else {
		      console.log(
		        'Geocode was not successful for the following reason: ' + status
		      );
		}
	});
	$('div#pedidoMap').dialog({
		maxWidth:600,
        maxHeight: 500,
		width: 600,
        height: 500,
        modal: true
    });
	
	
	
	/*
	map.fitBounds({
	      east: -76.998048,
	      north: -12.141659,
	      south: -12.145605,
	      west: -76.998328
	 });
	
	
	var marker = new google.maps.Marker({
        position:  new google.maps.LatLng(-12.142629, -76.998248),
        map: map,
        title: 'Hello World!'
    });
	*/
	
}