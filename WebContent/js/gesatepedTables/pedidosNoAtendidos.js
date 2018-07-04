/**
 * 
 */
function crearTablaPedidosNoAtendidos(paths) {
	$('#tblPedidosNoAtendidos').dataTable(
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
					localizarNoAtendido(aData);
				});
				
			}, 
	         "fnDrawCallback": function () {
	 			
	          },
	          "oLanguage": {
	              "sEmptyTable":     "My Custom Message On Empty Table"
	          }
	    }));
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

function localizarNoAtendido(data) {
	console.log("Localizando..",data);
	const map = new google.maps.Map(document.getElementById('pedidoMap'), {
		zoom: 4,
	    disableDefaultUI: true,
	    disableDoubleClickZoom: true,
	    center: new google.maps.LatLng(-12.142629, -76.998248)
	});
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
	$('div#pedidoMap').dialog();
}