<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<%-- <script type="text/javascript" src="${pageContext.request.contextPath}/js/dataTable/media/js/jquery.dataTables.js"></script> --%>
<!-- <link rel="stylesheet" type="text/css" href="//cdn.datatables.net/1.10.11/css/jquery.dataTables.css"> -->
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/dashboard.css">

<!-- <script type="text/javascript" charset="utf8" src="//cdn.datatables.net/1.10.11/js/jquery.dataTables.js"></script> -->
<script type="text/javascript" charset="utf8" src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.bundle.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery/collapse/jquery.collapse.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery/collapse/jquery.collapse_storage.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery/collapse/jquery.collapse_cookie_storage.js"></script>

<script type="text/javascript" charset="utf8" src="https://cdnjs.cloudflare.com/ajax/libs/localforage/1.7.2/localforage.min.js"></script>
<script src="https://www.gstatic.com/firebasejs/3.8.0/firebase.js"></script>
<script async defer
    src="https://maps.googleapis.com/maps/api/js?key=AIzaSyC5zx6JgWVPftfjOPJybTKhKUwhN5zVxJI&libraries=geometry">
</script>


<style>
	.tbl-descripcion {
		
		background-color: #dce6ef;
	    padding: 10px 5px;
	    left: 0px;
	    position: relative;
	}
	
	.tbl-descripcion a {
		color: black !important;
	}
	.tbl-contenedor {
		left: 15px;
	    position: relative;
	    width: 750px;
	}
</style>

<div>
	<div class="jumbotron">
        <p class="lead">MONITOREO DE DESPACHO DE PEDIDOS.</p>
      </div>
      
     <c:choose>
     	<c:when test="${empty rutas}">
     		No hay rutas para despachar hoy.
     	</c:when>
     	<c:otherwise>
     		<script type="text/javascript" src="${pageContext.request.contextPath}/js/tracking/dashboard.js"></script>
			<script type="text/javascript" src="${pageContext.request.contextPath}/js/tracking/simulador.js"></script>
			<script type="text/javascript" src="${pageContext.request.contextPath}/js/tracking/unidad.js"></script>
			<script type="text/javascript" src="${pageContext.request.contextPath}/js/gesatepedTables/unidades.js"></script>
			<script type="text/javascript" src="${pageContext.request.contextPath}/js/gesatepedTables/pedidosAtendidos.js"></script>
			<script type="text/javascript" src="${pageContext.request.contextPath}/js/gesatepedTables/pedidosNoAtendidos.js"></script>
			<script type="text/javascript" src="${pageContext.request.contextPath}/js/gesatepedTables/pedidosPendientes.js"></script>
			<script type="text/javascript" src="${pageContext.request.contextPath}/js/gesatepedTables/pedidosReprogramados.js"></script>
			<script type="text/javascript" src="${pageContext.request.contextPath}/js/gesatepedTables/pedidosCancelados.js"></script>
     		<div class="row-fluid marketing">
	        <div class="span6">
	          <h4>Bodega</h4>
	         <span>
				<form:form id="frmBodega" commandName="bodega" method="post" action="${pageContext.request.contextPath}/monitoreo/verUnidades">
					<label>Bodega: </label>
					<form:select path="codigo" style="width: 200px" onchange="actualizarUnidadesPorBodega()" >
						<form:option value="0" label="-- Seleccione --" />
						<form:options items="${bodegas}" itemValue="codigo" itemLabel="nombre" />
					</form:select>
					<jsp:useBean id="now" class="java.util.Date"/> 
					<label>Fecha de despacho: <fmt:formatDate value="${now}" pattern="yyyy-MM-dd" /></label>
				</form:form>
			</span>
	        </div>
	
	        <div id="graficaTotalBodega" class="span6" style="display:none">
				<p>Monitoreo del Total de Pedidos</p>
		         <div style="width:300px;height:300px">
					<canvas id="chartPedidosPorBodega" width="200px" height="200px"></canvas>
				</div>
	        </div>
	        <div id="noHayPedidosMsg" class="span6" style="display:none">
	        	<p>No hay pedidos asignados a esta bodega.
	        		Para visualizar grafica, por favor elegir bodega con pedidos asignados
	        	</p>
	        </div>
	        
	        <div id="panelUnidades" class="span12" style="display:none">
	        	<div>
					<p>Lista de Unidades activas para el 
					<fmt:formatDate value="${now}" pattern="yyyy-MM-dd" />, por favor seleccione la unidad a monitorear. </p>
				</div>
	        	<table id="tblUnidades" class="table">
					<thead>
						<tr>
							<th><label></label></th>
							<th><label>Numero de Placa</label></th>
							<th><label>Chofer</label></th>
							<th><label>Telefono</label></th>
							<th><label>Porcentaje de Atención</label></th>
						</tr>
					</thead>
					<tbody id="tbodyUnidades">
					</tbody>		
				</table>
	        </div>
	        
	        <div id="graficaTotalUnidad" class="span12" style="display:none">
	        	<p>Monitoreo de Despacho de Pedidos</p>
	        	<div style="width:300px;height:300px">
					<canvas id="myChart" width="200px" height="200px"></canvas>
				</div>
	        </div>
	        <hr>
	        
	</div>
	<div id="dialogMap" style="display: none;">
		<div id="monitoreoMap"
			style="border: 1px solid black; width:512px; height:480px">
		</div>
		<div id="controlPanel" class="botonera">
			<button class="btn btn-sm btn-success" id="iniciarSimBtn">Iniciar Simulación</button>
			<button class="btn btn-sm btn-danger" style="display: none;" id="detenerSimBtn">Detener Simulación</button>
			<script>
				$("#iniciarSimBtn").click(function(event){
					event.preventDefault();
					$("#detenerSimBtn").show();
					$("#iniciarSimBtn").hide();
					establecerParadasRuta().then(()=>{
						simularMovimiento();
					});
				});
				$("#detenerSimBtn").click(function(event){
					event.preventDefault();
					$("#iniciarSimBtn").show();
					$("#detenerSimBtn").hide();
					detenerSimulacion();
				});
			</script>
		</div>
	</div>
	<div id="pedidoMap"
			style="display: none;border: 1px solid black; width:512px; height:480px">
	</div>
	<div id="accordion" data-collapse style="display:none">
		<h3 class="tbl-descripcion open">Pedidos Atendidos</h3>
		<div class="tbl-contenedor">
			<table id="tblPedidosAtendidos" class="table" >
					<thead>
						<tr>
							<th><label>Código de pedido</label></th>
							<th><label>Ventana Horaria</label></th>
							<th><label>Hora Pactada</label></th>
							<th><label>Ubicación</label></th>
						</tr>
					</thead>
					<tbody id="tbodyPedidosAtendidos">
					</tbody>		
				</table>
		</div>
		<h3 class="tbl-descripcion open">Pedidos No Atendidos</h3>
		<div class="tbl-contenedor">
			<table id="tblPedidosNoAtendidos" class="table">
					<thead>
						<tr>
							<th><label>Código de pedido</label></th>
							<th><label>Ventana Horaria</label></th>
							<th><label>Hora No Atención</label></th>
							<th><label>Motivo</label></th>
							<th><label>Ubicación</label></th>
						</tr>
					</thead>
					<tbody id="tbodyPedidosNoAtendidos">
					</tbody>		
				</table>
		</div>
		<h3 class="tbl-descripcion open">Pedidos Pendientes</h3>
		<div class="tbl-contenedor">
			<table id="tblPedidosPendientes" class="table">
					<thead>
						<tr>
							<th><label>Código de pedido</label></th>
							<th><label>Ventana Horaria</label></th>
							<th><label>Ubicación</label></th>
						</tr>
					</thead>
					<tbody id="tbodyPedidosPendientes">
					</tbody>		
				</table>
		</div>
		<h3 class="tbl-descripcion open">Pedidos Reprogramados</h3>
		<div class="tbl-contenedor">
			<table id="tblPedidosReprogramados" class="table">
					<thead>
						<tr>
							<th><label>Código de pedido</label></th>
							<th><label>Motivo</label></th>
						</tr>
					</thead>
					<tbody id="tbodyPedidosReprogramados">
					</tbody>		
				</table>
		</div>
		<h3 class="tbl-descripcion open">Pedidos Cancelados</h3>
		<div class="tbl-contenedor">
			<table id="tblPedidosCancelados" class="table">
					<thead>
						<tr>
							<th><label>Código de pedido</label></th>
							<th><label>Motivo</label></th>
						</tr>
					</thead>
					<tbody id="tbodyPedidosCancelados">
					</tbody>		
				</table>
		</div>
	</div>
     	</c:otherwise>
     </c:choose>
      
	
</div>