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
		            	  	"' title='Abrir Popup' class='location-marker'>";
		                  return cadenaBoton;
		              }
		          	}, {
		          		'aTargets' : [1],
		          		'mData': null,
		          		'mRender': function (data,type,row) {
		          			return tConvert(data.horaInicioVentana) + " a " + tConvert(data.horaFinVentana);
		          		}
		          	}, {
		          		'aTargets' : [2],
		          		'mData': null,
		          		'mRender': function (data,type,row) {
		          			if(data.fechaNoCumplimientoDespacho) {
		          				return tConvert(data.fechaNoCumplimientoDespacho);
		          			} else {
		          				return "<i>--</i>";
		          			}
		          			
		          		}
		          	}
		         ],
		        'aoColumns': [
			        { 'mData': 'codigoPedido'},
			        {},
			        {},
			        { 'mData': 'descripcionMotivoPedidoHR',"defaultContent":"<i>--</i>"},
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
	var oTable = $('#tblPedidosNoAtendidos').dataTable();
	oTable.fnClearTable();
	if(data.length>0) {
		oTable.fnAddData(data);
	}
	oTable.fnDraw();
	oTable.fnPageChange('first');
}

function localizarNoAtendido(aData) {
	var direccion = aData.direccionDespacho + ' ' + aData.distritoDespacho;
	console.log("direccion",direccion);
	const geocoder = new google.maps.Geocoder();
	geocoder.geocode({address: direccion + " Peru"}, (results, status) =>{
		if (status === 'OK') {
			const url = _globalContextPath + colorToUnidadMarker('FFAD00');
			const map = new google.maps.Map(document.getElementById('noAtendidoMap'), {
				zoom: 15,
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
			
			 const pedidoMarker = new google.maps.Marker({
				  position: {
					  lat: results[0].geometry.location.lat(),
					  lng: results[0].geometry.location.lng()
				  },
				  map: map,
				  title: `${aData.apellidosCliente}, ${aData.nombresCliente}  \n${direccion}\n${tConvert(aData.fechaNoCumplimientoDespacho)}`,
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
			 
			//Label div
			 /*
			 $("#noAtendidoMap").append(`<div class='map-panel'>
			 	<span class="map-panel-title">${aData.codigoPedido}</span><br>
			 	${direccion}</div>`);
			 */
			 localforage.getItem("unidadSeleccionada").then((unidadSeleccionada)=>{
				 var unidadMarker = new google.maps.Marker({
				        position:  new google.maps.LatLng(aData.latitudGpsDespacho, aData.longitudGpsDespacho),
				        map: map,
				        title: 'Posición de unidad',
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
	
	var title = `<div>
		<img src="${_globalContextPath}/images/sodimaclogo-title.jpg" class="dialog-sodimac">
			<span class="dialog-sodimac-title">UBICACIÓN ACTUAL DE PEDIDO ${aData.codigoPedido}</span>
			</div>`;
	
	$('div#noAtendidoMap').dialog({
		title : title,
		maxWidth:600,
        maxHeight: 500,
		width: 600,
        height: 500,
        modal: true,
        close: function(event,ui) {
        	$('div#noAtendidoMap').html("");
        }
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