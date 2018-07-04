/**
 * 
 */
function crearTablaPedidosAtendidos(paths) {
	$('#tblPedidosAtendidos').dataTable(
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
					localizarAtendido(aData);
				});
				
			}, 
	         "fnDrawCallback": function () {
	 			
	          },
	          "oLanguage": {
	              "sEmptyTable":     "My Custom Message On Empty Table"
	          }
	    }));
}

function actualizarTablaPedidosAtendidos(data) {
	if(data.length>0) {
		var oTable = $('#tblPedidosAtendidos').dataTable();
		oTable.fnClearTable();
		oTable.fnAddData(data);
		oTable.fnDraw();
		oTable.fnPageChange('first');
	}
}

function localizarAtendido(data) {
	console.log("Localizando..",data);
}
