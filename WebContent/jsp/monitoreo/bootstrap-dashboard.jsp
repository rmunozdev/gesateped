<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<%-- <script type="text/javascript" src="${pageContext.request.contextPath}/js/dataTable/media/js/jquery.dataTables.js"></script> --%>
<!-- <link rel="stylesheet" type="text/css" href="//cdn.datatables.net/1.10.11/css/jquery.dataTables.css"> -->
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/dashboard.css">

<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/v/bs/dt-1.10.18/datatables.min.css"/>
<script type="text/javascript" src="https://cdn.datatables.net/v/bs/dt-1.10.18/datatables.min.js"></script>

<!-- <script type="text/javascript" charset="utf8" src="//cdn.datatables.net/1.10.11/js/jquery.dataTables.js"></script> -->
<script type="text/javascript" charset="utf8" src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.bundle.js"></script>
<script type="text/javascript" charset="utf8" src="https://cdnjs.cloudflare.com/ajax/libs/localforage/1.7.2/localforage.min.js"></script>
<script src="https://www.gstatic.com/firebasejs/3.8.0/firebase.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/tracking/simulador.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/tracking/unidad.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/gesatepedTables/unidades.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/gesatepedTables/pedidosAtendidos.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/gesatepedTables/pedidosNoAtendidos.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/gesatepedTables/pedidosPendientes.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/gesatepedTables/pedidosReprogramados.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/gesatepedTables/pedidosCancelados.js"></script>
<script async defer
    src="https://maps.googleapis.com/maps/api/js?key=AIzaSyC5zx6JgWVPftfjOPJybTKhKUwhN5zVxJI&libraries=geometry">
</script>

<script>
const firebaseConfig = {
		apiKey: "AIzaSyBiFvJ6Uvz7Hg54xc2VIEhlIZiMrFXl7ps",
	    authDomain: "sodimacmonitor.firebaseapp.com",
	    databaseURL: "https://sodimacmonitor.firebaseio.com",
	    projectId: "sodimacmonitor",
	    storageBucket: "sodimacmonitor.appspot.com",
	    messagingSenderId: "756903087303"
};
firebase.initializeApp(firebaseConfig);
const firebaseDB = firebase.database();
(()=>{
	_globalContextPath = "${pageContext.request.contextPath}";
	window.addEventListener('load',crearTabla);
})();

function UnidadSeleccionada(hojaRuta,placa) {
	this.hojaRuta = hojaRuta;
	this.placa = placa;
}

function crearTabla(params) {
	var paths = {
		marker : "${pageContext.request.contextPath}/images/location-marker.png"
	}
	crearTablaUnidades();
	crearTablaPedidosAtendidos(paths);
	crearTablaPedidosNoAtendidos(paths);
	crearTablaPedidosPendientes(paths);
	crearTablaPedidosReprogramados();
	crearTablaPedidosCancelados();
}


function actualizarUnidadesPorBodega(){
	$.ajaxSetup({
		cache : false
	});
	var form  = $('#frmBodega');
	hideAllDetails();
	$.ajax({
		url: form.attr('action'),
		type: form.attr('method'),
		data: form.serialize(),
		Accept : 'application/json',
		success:function(data){
			if(data.length && data.length > 0) {
				$('#tblUnidades').show();
				actualizarTablaUnidades(data);
			} else {
				$('#tblUnidades').hide();
			}
		}
	});
	//Ver estados de pedidos por bodega
	$.ajax({
		url: '${pageContext.request.contextPath}/monitoreo/verEstadoPedidosPorBodega',
		type: 'POST',
		data: form.serialize(),
		Accept : 'application/json',
		success:function(data){
			if(data.length && data.length > 0) {
				$("#graficaTotalBodega").show();
				actualizarGraficaEstadoPedidosPorBodega(data);	
			} else {
				$("#graficaTotalBodega").hide();
				
			}
		}
	});
	
}

function verDashBoardUnidad(codigoHojaRuta) {
	$.ajax({
		url: '${pageContext.request.contextPath}/monitoreo/verEstadoPedidos',
		type: 'POST',
		data: {codigoHojaRuta : codigoHojaRuta},
		Accept : 'application/json',
		success:function(data){
			if(data.length && data.length > 0) {
				
				showAllDetails();
				crearGrafica(data);
				verDetallePedidosAtendidos(codigoHojaRuta);
				verDetallePedidosNoAtendidos(codigoHojaRuta);
				verDetallePedidosPendientes(codigoHojaRuta);
				verDetallePedidosReprogramados(codigoHojaRuta);
				verDetallePedidosCancelados(codigoHojaRuta);
			} else {
				
				hideAllDetails();
			}
		}
	});
}

function crearGrafica(estadoPedidos) {
	var ctx = document.getElementById("myChart").getContext('2d');
	var myDoughnutChart = new Chart(ctx, {
	    type: 'doughnut',
	    data: {
	        datasets: [{
	            data: [
	            	estadoPedidos[0].porcentaje, //pendientes
	            	estadoPedidos[1].porcentaje, //atendidos
	            	estadoPedidos[2].porcentaje, //no atendidos
	            	estadoPedidos[3].porcentaje, //reprogramados
	            	estadoPedidos[4].porcentaje //cancelados
	            	],
	            backgroundColor: [
	                '#b7afab',
	                '#9ccedc',
	                '#dc6f33',
	                '#e4c583',
	                '#005dff'
	            ]
	        }],
	        labels: [
	        	estadoPedidos[0].nombre,
	        	estadoPedidos[1].nombre,
	        	estadoPedidos[2].nombre,
	        	estadoPedidos[3].nombre,
	        	estadoPedidos[4].nombre
	        ]
	    },
	    options: {}
	});
}

function actualizarGraficaEstadoPedidosPorBodega(estadoPedidos) {
	var ctx = document.getElementById("chartPedidosPorBodega").getContext('2d');
	var myDoughnutChart = new Chart(ctx, {
	    type: 'doughnut',
	    data: {
	        datasets: [{
	            data: [
	            	estadoPedidos[0].porcentaje, 
	            	estadoPedidos[1].porcentaje, 
	            	estadoPedidos[2].porcentaje, 
	            	estadoPedidos[3].porcentaje, 
	            	estadoPedidos[4].porcentaje
	            	],
	            backgroundColor: [
	            	'#dc0e40',
	                '#156f15',
	                '#f19f2a',
	                '#dff369',
	                '#36a2eb'
	            ]
	        }],
	        labels: [
	        	estadoPedidos[0].nombre,
	        	estadoPedidos[1].nombre,
	        	estadoPedidos[2].nombre,
	        	estadoPedidos[3].nombre,
	        	estadoPedidos[4].nombre
	        ]
	    },
	    options: {}
	});
}

function verDetallePedidosAtendidos(codigoHojaRuta) {
	$.ajax({
		url: '${pageContext.request.contextPath}/monitoreo/verDetallePedidosAtendidos',
		type: 'POST',
		data: {codigoHojaRuta : codigoHojaRuta},
		Accept : 'application/json',
		success:function(data){
			console.log("Success");
			console.log(JSON.stringify(data));
			actualizarTablaPedidosAtendidos(data);
		}
	});
}

function verDetallePedidosNoAtendidos(codigoHojaRuta) {
	$.ajax({
		url: '${pageContext.request.contextPath}/monitoreo/verDetallePedidosNoAtendidos',
		type: 'POST',
		data: {codigoHojaRuta : codigoHojaRuta},
		Accept : 'application/json',
		success:function(data){
			console.log("Success");
			console.log(JSON.stringify(data));
			actualizarTablaPedidosNoAtendidos(data);
		}
	});
}
function verDetallePedidosPendientes(codigoHojaRuta) {
	$.ajax({
		url: '${pageContext.request.contextPath}/monitoreo/verDetallePedidosPendientes',
		type: 'POST',
		data: {codigoHojaRuta : codigoHojaRuta},
		Accept : 'application/json',
		success:function(data){
			console.log("Success");
			console.log(JSON.stringify(data));
			actualizarTablaPedidosPendientes(data,codigoHojaRuta);
		}
	});
}
function verDetallePedidosReprogramados(codigoHojaRuta) {
	$.ajax({
		url: '${pageContext.request.contextPath}/monitoreo/verDetallePedidosReprogramados',
		type: 'POST',
		data: {codigoHojaRuta : codigoHojaRuta},
		Accept : 'application/json',
		success:function(data){
			console.log("Success");
			console.log(JSON.stringify(data));
			actualizarTablaPedidosReprogramados(data);
		}
	});
}
function verDetallePedidosCancelados(codigoHojaRuta) {
	$.ajax({
		url: '${pageContext.request.contextPath}/monitoreo/verDetallePedidosCancelados',
		type: 'POST',
		data: {codigoHojaRuta : codigoHojaRuta},
		Accept : 'application/json',
		success:function(data){
			console.log("Success");
			console.log(JSON.stringify(data));
			actualizarTablaPedidosCancelados(data);
		}
	});
}


function showAllDetails() {
	$("#graficaTotalUnidad").show();
	$("#detallePedidosAtendidos").show();
	$("#detallePedidosNoAtendidos").show();
	$("#detallePedidosPendientes").show();
	$("#detallePedidosReprogramados").show();
	$("#detallePedidosCancelados").show();
}

function hideAllDetails() {
	$("#graficaTotalUnidad").hide();
	$("#detallePedidosAtendidos").hide();
	$("#detallePedidosNoAtendidos").hide();
	$("#detallePedidosPendientes").hide();
	$("#detallePedidosReprogramados").hide();
	$("#detallePedidosCancelados").hide();
}

</script>
<div>
	<div class="jumbotron">
        <p class="lead">MONITOREO DE DESPACHO DE PEDIDOS.</p>
      </div>
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
	        
	        <div class="span12">
	        	<table id="tblUnidades" class="table" style="display:none">
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
	        
	        <div id="detallePedidosAtendidos" style="display:none" class="span12" >
	        	<p>Pedidos Atendidos</p>
				<table id="tblPedidosAtendidos" class="table" >
					<thead>
						<tr>
							<th><label>Código de pedido</label></th>
							<th><label>Ventana Horaria</label></th>
							<th><label>Hora Pactada</label></th>
							<th></th>
						</tr>
					</thead>
					<tbody id="tbodyPedidosAtendidos">
					</tbody>		
				</table>
	        </div>
	        
	        <div id="detallePedidosNoAtendidos" style="display:none" class="span12">
	        	<p>Pedidos No Atendidos</p>
				<table id="tblPedidosNoAtendidos" class="table">
					<thead>
						<tr>
							<th><label>Código de pedido</label></th>
							<th><label>Ventana Horaria</label></th>
							<th><label>Hora Pactada</label></th>
							<th></th>
						</tr>
					</thead>
					<tbody id="tbodyPedidosNoAtendidos">
					</tbody>		
				</table>
	        </div>
	        
	        <div id="detallePedidosPendientes" style="display:none" class="span12">
	        	<p>Pedidos Pendientes</p>
				<table id="tblPedidosPendientes" class="table">
					<thead>
						<tr>
							<th><label>Código de pedido</label></th>
							<th><label>Ventana Horaria</label></th>
							<th><label>Hora Pactada</label></th>
							<th></th>
						</tr>
					</thead>
					<tbody id="tbodyPedidosPendientes">
					</tbody>		
				</table>
	        </div>
	        
	        <div id="detallePedidosReprogramados" style="display:none" class="span12">
				<p>Pedidos Reprogramados</p>
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
	        
	        <div id="detallePedidosCancelados" style="display:none" class="span12">
		        <p>Pedidos Cancelados</p>
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
		<div id="pedidoMap" style="display: none;border: 1px solid black; width:512px; height:512px">
		</div>
</div>