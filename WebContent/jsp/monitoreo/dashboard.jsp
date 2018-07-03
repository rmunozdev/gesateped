<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<%-- <script type="text/javascript" src="${pageContext.request.contextPath}/js/dataTable/media/js/jquery.dataTables.js"></script> --%>
<link rel="stylesheet" type="text/css" href="//cdn.datatables.net/1.10.11/css/jquery.dataTables.css">
  
<script type="text/javascript" charset="utf8" src="//cdn.datatables.net/1.10.11/js/jquery.dataTables.js"></script>
  
<script>
(()=>{
	window.addEventListener('load',crearTabla);
})();


function crearTabla() {
	
	oTableBandejaProducto = $('#tblUnidades').dataTable(
			$.extend( true, {}, null,{
			'aaData'   : {},
	        'aoColumns': [
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


function actualizarUnidadesPorBodega(){
	$.ajaxSetup({
		cache : false
	});
	var form  = $('#frmBodega');
	var lUrl = '${pageContext.request.contextPath}/monitoreo/verUnidades';
	var oTable = $('#tblUnidades').dataTable();
	$.ajax({
		url: form.attr('action'),
		type: form.attr('method'),
		data: form.serialize(),
		Accept : 'application/json',
		success:function(data){
			oTable.fnClearTable();
			oTable.fnAddData(data);
			oTable.fnDraw();
			oTable.fnPageChange('first');
		}
	})
	
}

</script>
<div>
	<h1>MONITOREO DE DESPACHO DE PEDIDOS</h1>
	<h2>Control</h2>
	<div>
		<span>
			<form:form id="frmBodega" commandName="bodega" method="post" action="${pageContext.request.contextPath}/monitoreo/verUnidades">
				<form:select path="codigo" style="width: 200px" onchange="actualizarUnidadesPorBodega()" >
					<form:option value="0" label="-- Seleccione --" />
					<form:options items="${bodegas}" itemValue="codigo" itemLabel="nombre" />
				</form:select>
			</form:form>
		</span>
		
	</div>
	
	<div>
		<table id="tblUnidades" class="table">
			<thead>
				<tr>
					<th><label>Numero de Placa</label></th>
					<th><label>Chofer</label></th>
					<th><label>Telefono</label></th>
				</tr>
			</thead>
			<tbody id="tbodyUnidades">
			</tbody>		
		</table>
	</div>
</div>