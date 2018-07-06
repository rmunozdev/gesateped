/**
 * 
 */
function crearTablaPedidosCancelados() {
	$('#tblPedidosCancelados').dataTable(
			{
				'bPaginate':  false,
				 'bFilter'	: false,
				 'bInfo': false,
				 'aaData'   : {},
		        'aoColumns': [
			        { 'mData': 'codigoPedido'},
			        { 'mData': 'descripcionMotivoPedido',"defaultContent":"<i>Unset</i>"}
				],
				'fnRowCallback': function( nRow, aData, iDataIndex ) {
					
				}, 
		         "fnDrawCallback": function () {
		 			
		          },
		          "oLanguage": {
		              "sEmptyTable":     "My Custom Message On Empty Table"
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
