/**
 * 
 */
function crearTablaUnidades() {
	$('#tblUnidades').dataTable(
			$.extend( true, {}, null,{
			 'aaData'   : {},
	         'aoColumnDefs': [ {
	              'aTargets': [0],
	              'mData': null, 
	              'mRender' : function (data, type, row) {
	            	  if(type === 'display'){
	            		  console.log(JSON.stringify(data));
	            		  localforage.setItem(data.codigoHojaRuta,new UnidadSeleccionada(data.codigoHojaRuta,data.numeroPlaca));
	                      data = '<input type="radio" name="unidad" value="' + data.codigoHojaRuta + '">';
	                   }
	            	  return data;
	              }
	          } ],
	        'aoColumns': [
	        	{ },
		        { 'mData': 'numeroPlaca'},
		        { 'mData': 'nombreChofer'},
		        { 'mData': 'telefonoChofer'}
			],
			'fnRowCallback': function( nRow, aData, iDataIndex ) {
				
				
			}, 
	         "fnDrawCallback": function () {
	 			
	          }
	    }));
}

function actualizarTablaUnidades(data) {
	var oTable = $('#tblUnidades').dataTable();
	oTable.fnClearTable();
	oTable.fnAddData(data);
	oTable.fnDraw();
	oTable.fnPageChange('first');
	$('input:radio[name=unidad]').click(function() { 
		console.log($(this).val());
		verDashBoardUnidad($(this).val());
	});
}
