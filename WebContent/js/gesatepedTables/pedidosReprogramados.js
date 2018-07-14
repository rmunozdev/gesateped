/**
 * 
 */
function crearTablaPedidosReprogramados() {
	$('#tblPedidosReprogramados').dataTable(
			{
				'bPaginate':  false,
				 'bFilter'	: false,
				 'bInfo': false,
				 'bSort': false,
				 'bAutoWidth': false,
				 'aaData'   : {},
		        'aoColumns': [
			        { 'mData': 'codigoPedido'},
			        { 'mData': 'descripcionMotivoPedidoPE',"defaultContent":"<i>--</i>"}
				],
				'fnRowCallback': function( nRow, aData, iDataIndex ) {
				}, 
		         "fnDrawCallback": function () {
		          },
		          "oLanguage": {
		              "sEmptyTable":     "No se encontraron pedidos reprogramados"
		          }
		    });
}

function actualizarTablaPedidosReprogramados(data) {
	var oTable = $('#tblPedidosReprogramados').dataTable();
	oTable.fnClearTable();
	if(data.length>0) {
		oTable.fnAddData(data);
	}
	oTable.fnDraw();
	oTable.fnPageChange('first');
}
