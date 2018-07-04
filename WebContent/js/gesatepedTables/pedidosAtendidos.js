/**
 * 
 */
function crearTablaPedidosAtendidos() {
	$('#tblPedidosAtendidos').dataTable(
			$.extend( true, {}, null,{
			 'aaData'   : {},
	         'aoColumnDefs': [ {
	              'aTargets': [3],
	              'mData': null, 
	              'mRender' : function (data, type, row) {
	            	  if(type === 'display'){
	            		  console.log(JSON.stringify(data));
	                      data = '<input type="radio" name="unidad" value="' + data.codigoPedido + '">';
	                   }
	            	  return data;
	              }
	          } ],
	        'aoColumns': [
		        { 'mData': 'codigoPedido'},
		        { 'mData': 'horaInicioVentana'},
		        { 'mData': 'fechaPactadaDespacho',"defaultContent":"<i>Unset</i>"},
		        {}
			],
			'fnRowCallback': function( nRow, aData, iDataIndex ) {
				
				
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
