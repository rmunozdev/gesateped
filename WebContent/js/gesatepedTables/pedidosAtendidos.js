/**
 * 
 */
function crearTablaPedidosAtendidos(paths) {
	$('#tblPedidosAtendidos').dataTable(
			{
				'bPaginate':  false,
				 'bFilter'	: false,
				 'bInfo': false,
				 'bSort': false,
				 'bAutoWidth': false,
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
		              "sEmptyTable":     "No se encontraron pedidos atendidos"
		          }
		    });
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
