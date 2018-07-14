/**
 * 
 */
function crearTablaUnidades() {
	$('#tblUnidades').dataTable(
			{
				 'bPaginate':  false,
				 'bFilter'	: false,
				 'bInfo': false,
				 'bSort': false,
				 'bAutoWidth': false,
				 'aaData'   : {},
		         'aoColumnDefs': [ {
		              'aTargets': [0],
		              'mData': null, 
		              'mRender' : function (data, type, row) {
		            	  if(type === 'display'){
		            		  localforage.setItem(data.codigoHojaRuta,
		            				  new UnidadSeleccionada(data.codigoHojaRuta,data.numeroPlaca)
		            		  );
		                      data = '<input type="radio" name="unidad" value="' + data.codigoHojaRuta + '">';
		                   }
		            	  return data;
		              }
		         	},{
		         		'aTargets': [2],
			              'mData': null, 
			              'mRender' : function (data, type, row) {
			            	  if(type === 'display'){
			            		  return data.nombreChofer + " " + data.apellidoChofer;
			                   }
			            	  return data;
			              }
		         	},
		         	
		         	{
		         		'aTargets': [4],
		         		'mData': null,
		         		'mRender' : function(data, type, row){
		         			if(type === 'display') {
		         				console.log(JSON.stringify(data));
		         				let atendidos = data.totalPedidosAtendidos;
		         				let total = data.totalPedidos;
		         				
		         				let porcentajeBase = ((atendidos*100)/total).toFixed(2);
		         				let porcentajeDefecto = 100 - porcentajeBase;
		         				let content = `<div class="bar-chart-bar">
		         					<span>
		         					<div class="bar bar1" style="width:${porcentajeBase*0.8}%"></div>
		         					<div class="bar bar2" style="width:${porcentajeDefecto*0.8}%"></div>
		         					</span>
		         					<span class="per-label">${porcentajeBase}%</span>
		         					</div>`
		         				data = content;
		         			}
		         			return data;
		         		}
		         		
		         	}
		         ],
		        'aoColumns': [
		        	{ },
			        { 'mData': 'numeroPlaca'},
			        { },
			        { 'mData': 'telefonoChofer'},
			        { }
			        
				],
				'fnRowCallback': function( nRow, aData, iDataIndex ) {
				}, 
		         "fnDrawCallback": function () {
		          }
		          
		    });
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
