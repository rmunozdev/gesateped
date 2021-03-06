<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<%-- <script type="text/javascript" src="${pageContext.request.contextPath}/js/dataTable/media/js/jquery.dataTables.js"></script> --%>
<!-- <link rel="stylesheet" type="text/css" href="//cdn.datatables.net/1.10.11/css/jquery.dataTables.css"> -->
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/dashboard.css">

<script type='text/javascript' src='${pageContext.request.contextPath}/monitoreo/config.js'></script>
<!-- <script type="text/javascript" charset="utf8" src="//cdn.datatables.net/1.10.11/js/jquery.dataTables.js"></script> -->
<script type="text/javascript" charset="utf8" src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.bundle.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery/collapse/jquery.collapse.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery/collapse/jquery.collapse_storage.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery/collapse/jquery.collapse_cookie_storage.js"></script>

<script type="text/javascript" charset="utf8" src="https://cdnjs.cloudflare.com/ajax/libs/localforage/1.7.2/localforage.min.js"></script>
<script type="text/javascript" charset="utf8" src="https://cdn.jsdelivr.net/npm/moment@2.22.2/moment.min.js"></script>
<script src="https://www.gstatic.com/firebasejs/3.8.0/firebase.js"></script>
<script 
    src="https://maps.googleapis.com/maps/api/js?key=${DirectionsAPIKEY}&libraries=geometry">
</script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/@mapbox/polyline@1.0.0/src/polyline.min.js"></script>


<style>
	.tbl-descripcion {
		background-color: #dce6ef;
	    padding: 5px 5px;
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
	
	.left-text {
		
	}
	
	.dialog-sodimac {
		height: 20px;
	}
	
	.dialog-sodimac-title {
		position: relative;
	    left: 35px;
	    top: 3px;
	    text-decoration: underline;
	}
	
	.map-panel {
		position:absolute; 
		right: 1%;
    	bottom: 5%;
		background: #f9f1dd;
		padding: 6px;
	    border: 2px solid #ad9595;
	    border-radius: 5px;
	    color: black;
	    font-family: sans-serif;
	}
	.map-panel-title {
		font-weight: bold;
		text-decoration: underline
	}
	.km-label-container {
		
		
	}
	.km-label{
		padding-top: 5px;
		font-size: 9px;
		background-color: black;
		color: white;
		line-height: 10px;
		text-align: center;
		border-radius: 4px;
		z-index: 99;
	}
	
</style>

<div>
	<div id="alertZone" class="top-msg" style="display:none">
		<div style="position: relative">
			<div class="top-msg-close" style="cursor: pointer;">&#10005;</div>
		</div>
		<div class="top-msg-ico">!</div>
		<div class="top-msg-inner">
		</div>
		
	</div>
	<div class="jumbotron cabecera-narrow">
        <p class="lead">MONITOREO DE DESPACHO DE PEDIDOS</p>
      </div>
     <c:choose>
     	<c:when test="${empty rutas}">
     		<div class="alert alert-danger">
     			No existen pedidos para despachar hoy.
     		</div>
     	</c:when>
     	<c:otherwise>
     		<script type="text/javascript" src="${pageContext.request.contextPath}/js/tracking/dashboard.js"></script>
			<script type="text/javascript" src="${pageContext.request.contextPath}/js/tracking/simulador.js"></script>
			<script type="text/javascript" src="${pageContext.request.contextPath}/js/tracking/unidad.js"></script>
			<script type="text/javascript" src="${pageContext.request.contextPath}/js/tracking/alerts.js"></script>
			<script type="text/javascript" src="${pageContext.request.contextPath}/js/gesatepedTables/unidades.js"></script>
			<script type="text/javascript" src="${pageContext.request.contextPath}/js/gesatepedTables/pedidosAtendidos.js"></script>
			<script type="text/javascript" src="${pageContext.request.contextPath}/js/gesatepedTables/pedidosNoAtendidos.js"></script>
			<script type="text/javascript" src="${pageContext.request.contextPath}/js/gesatepedTables/pedidosPendientes.js"></script>
			<script type="text/javascript" src="${pageContext.request.contextPath}/js/gesatepedTables/pedidosReprogramados.js"></script>
			<script type="text/javascript" src="${pageContext.request.contextPath}/js/gesatepedTables/pedidosCancelados.js"></script>
     		<div class="row-fluid marketing">
	        <div class="span5 panel panel-default">
	          <h4 class="panel-heading panel-narrow">Bodega</h4>
	         <div class="panel-body">
	         	<div class="left-text">
			        <jsp:useBean id="now" class="java.util.Date"/> 
					<label>Fecha de Despacho: <fmt:formatDate value="${now}" pattern="dd/MM/yyyy" /></label>
			    </div>
			    <input type="hidden" id="codigoHojaRutaField">
			    <input type="hidden" id="unidadSeleccionadaField">
				<form:form id="frmBodega" commandName="bodega" method="post" action="${pageContext.request.contextPath}/monitoreo/verUnidades">
					<form:select path="codigo" class="selectpicker" onchange="onBodegaChange()" >
						<form:option value="0" label="-- Por favor seleccione --" />
						<form:options items="${bodegas}" itemValue="codigo" itemLabel="nombre" />
					</form:select>
				</form:form>
			</div>
	        </div>
	
	        <div id="graficaTotalBodega" class="span7" style="display:none">
				<p class="alert-info">Monitoreo del Total de Pedidos</p>
		         <div style="width:300px;height:180px">
					<canvas id="chartPedidosPorBodega" width="340px" height="180px"></canvas>
				</div>
	        </div>
	        <div id="noHayPedidosMsg" class="span6" style="display:none">
	        	<p class="alert alert-danger">Esta bodega no tiene pedidos para ser despachados hoy.
	        	</p>
	        </div>
	        
	        <div id="panelUnidades" class="span12" style="display:none">
	        	<div class="alert-warning">
					<p>Lista de unidades activas para el 
					<fmt:formatDate value="${now}" pattern="dd/MM/yyyy" />, por favor seleccione la unidad a monitorear. </p>
				</div>
	        	<table id="tblUnidades" class="table">
					<thead>
						<tr>
							<th><label></label></th>
							<th><label>Número de Placa</label></th>
							<th><label>Chofer</label></th>
							<th><label>Teléfono</label></th>
							<th><label>Porcentaje de Atención</label></th>
						</tr>
					</thead>
					<tbody id="tbodyUnidades">
					</tbody>		
				</table>
	        </div>
	        
	        <div id="graficaTotalUnidad" class="span12" style="display:none">
	        	<p class="alert-info">Monitoreo de Despacho de Pedidos</p>
	        	<div style="width:300px;height:180px">
					<canvas id="myChart" width="340px" height="180px"></canvas>
				</div>
				<div>
					<a id="rutaCompleta">Ver ruta completa</a>
				</div>
	        </div>
	        <hr>
	        
	</div>
	<div id="dialogMap" style="display: none;">
		<div id="monitoreoMap"
			style="border: 1px solid black; width:512px; height:420px">
		</div>
		<div id="controlPanel" class="row">
			<div id="infoPanel" class="col-sm-10 info-panel">
				<label>Origen:</label>
				<label id="initLbl"></label>
				<br>
				<label>Destino:</label>
				<label id="endLbl"></label>
				<br>
				<label>Distancia restante:</label>
				<label id="distanceLbl"></label>
				<br>
				<label>Tiempo restante:</label>
				<label id="timeLbl"></label>
			</div>
			<div  class="col-sm-2 botonera">
				<label class="simLbl">Simulación</label><br>
				<a  id="iniciarSimBtn"><img class="ctrlimg" src="${pageContext.request.contextPath}/images/dashboard/play.png"></a>
				<a  id="detenerSimBtn" style="display: none;"><img class="ctrlimg" src="${pageContext.request.contextPath}/images/dashboard/pause.png"></a>
				<a  id="continuarSimBtn" style="display: none;"><img  class="ctrlimg" src="${pageContext.request.contextPath}/images/dashboard/play.png"></a>
				<a  id="unavailableSimBtn" style="display: none;"><img  class="ctrlimg" src="${pageContext.request.contextPath}/images/dashboard/unavailable.png"></a>
			</div>
		</div>
	</div>
	<div id="pedidoMap"
			style="display: none;border: 1px solid black; width:512px; height:480px">
	</div>
	<div id="noAtendidoMap"
			style="display: none;border: 1px solid black; width:512px; height:480px">
	</div>
	<div id="rutaCompletaMap"
			style="display: none;border: 1px solid black; width:512px; height:480px">
	</div>
	
	<div id="accordion" data-collapse style="display:none">
		<h4 class="tbl-descripcion open">Pedidos Atendidos</h4>
		<div class="tbl-contenedor">
			<table id="tblPedidosAtendidos" class="table" >
					<thead>
						<tr>
							<th><label>Código de Pedido</label></th>
							<th><label>Rango Horario</label></th>
							<th><label>Hora Pactada</label></th>
							<th><label>Ubicación</label></th>
						</tr>
					</thead>
					<tbody id="tbodyPedidosAtendidos">
					</tbody>		
				</table>
		</div>
		<h4 class="tbl-descripcion open">Pedidos No Atendidos</h4>
		<div class="tbl-contenedor">
			<table id="tblPedidosNoAtendidos" class="table">
					<thead>
						<tr>
							<th><label>Código de Pedido</label></th>
							<th><label>Rango Horario</label></th>
							<th><label>Hora No Atención</label></th>
							<th><label>Motivo</label></th>
							<th><label>Ubicación</label></th>
						</tr>
					</thead>
					<tbody id="tbodyPedidosNoAtendidos">
					</tbody>		
				</table>
		</div>
		<h4 class="tbl-descripcion open">Pedidos Pendientes</h4>
		<div class="tbl-contenedor">
			<table id="tblPedidosPendientes" class="table">
					<thead>
						<tr>
							<th><label>Código de Pedido</label></th>
							<th><label>Rango Horario</label></th>
							<th><label>Ubicación</label></th>
						</tr>
					</thead>
					<tbody id="tbodyPedidosPendientes">
					</tbody>		
				</table>
		</div>
		<h4 class="tbl-descripcion open">Pedidos Reprogramados</h4>
		<div class="tbl-contenedor">
			<table id="tblPedidosReprogramados" class="table">
					<thead>
						<tr>
							<th><label>Código de Pedido</label></th>
							<th><label>Motivo</label></th>
						</tr>
					</thead>
					<tbody id="tbodyPedidosReprogramados">
					</tbody>		
				</table>
		</div>
		<h4 class="tbl-descripcion open">Pedidos Cancelados</h4>
		<div class="tbl-contenedor">
			<table id="tblPedidosCancelados" class="table">
					<thead>
						<tr>
							<th><label>Código de Pedido</label></th>
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