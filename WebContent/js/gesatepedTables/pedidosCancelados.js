/**
 * 
 */
function crearTablaPedidosCancelados() {
	$('#tblPedidosCancelados').dataTable(
			{
				'bPaginate':  false,
				 'bFilter'	: false,
				 'bInfo': false,
				 'bSort': false,
				 'bAutoWidth': false,
				 'aaData'   : {},
		        'aoColumns': [
			        { 'mData': 'codigoPedido'},
			        { 'mData': 'descripcionMotivoPedido',"defaultContent":"<i>--</i>"}
				],
				'fnRowCallback': function( nRow, aData, iDataIndex ) {
					
				}, 
		         "fnDrawCallback": function () {
		 			
		          },
		          "oLanguage": {
		              "sEmptyTable":     "No se encontraron pedidos cancelados"
		          }
		    });
}

function actualizarTablaPedidosCancelados(data) {
	if(data.length>0) {
		var oTable = $('#tblPedidosCancelados').dataTable();
		oTable.fnClearTable();
		oTable.fnAddData(data);
		oTable.fnDraw();
		oTable.fnPageChange('first');
	}
}
