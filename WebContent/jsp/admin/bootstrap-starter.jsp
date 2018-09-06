<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<script src="${pageContext.request.contextPath}/js/jquery.fileDownload.js"></script>

<script>
	(()=>{
		window.addEventListener('load',iniciar);
	})();
	
	function iniciar() {
		if(document.getElementById("generarBtn")) {
			document.getElementById("generarBtn").onclick = generarRutas;
			if(document.getElementById("pedidosBtn")){
				document.getElementById("pedidosBtn").onclick = function(event) {
					event.preventDefault();
					if($('#detallePedidos').is(":visible")) {
						document.getElementById("pedidosBtn").innerHTML = "Ver detalle pedidos a procesar";
						$('#detallePedidos').hide();
					} else {
						document.getElementById("pedidosBtn").innerHTML = "Ocultar detalles";
						$('#detallePedidos').show();
					}
					
				};
			}
			
		}
		if(document.getElementById("monitoreoBtn")) {
			document.getElementById("monitoreoBtn").onclick = function(event) {
				event.preventDefault();
				window.location = _globalContextPath+'/monitoreo';
			}
		}
		if($("#limpiarBtn")) {
			$("#limpiarBtn").click((event)=>{
				limpiar();
			});
		}
		
		
		document.getElementById("descargarBtn").onclick = descargarReporte;
	}
	var myresponse;
	function generarRutas(event) {
		event.preventDefault();
		$("#construyendo").show();
		$("#generarBtn").hide();
		fetch('starter/construir').then(response => response.json()).then(data=>{
			$("#generarBtn").show();
			$("#construyendo").hide();
			myresponse = data;
			if(data) {
				//Construir select para la data.
				var sel = $('#bodegasList');
				data.forEach((bodega)=>{
					console.log("value added",bodega);
					sel.append($('<option value="'+bodega+'">'+bodega+'</option>'));
				});
				//sel.addClass('selectpicker');
				$('.selectpicker').selectpicker('refresh');
				$('#step1').hide();
				$('#step2').show(1000);
			} else {
				console.log("Runbatch fail");
			}
		});
	}
	
	function descargarReporte(event) {
		event.preventDefault();
		$.fileDownload('starter/descargar', {data: {nombreBodega: $("#bodegasList" ).val()}})
	    .done(function () { 
	    	alert('File download a success!'); 
	    })
	    .fail(function () { 
	    	alert('File download failed!'); 
	    });
	}
	
	function limpiar() {
		fetch('starter/limpiar').then((response)=>{
			location.reload(true);
		});
	}

</script>
<c:choose>
	<c:when test="${empty pedidos}">
		<div id="step2" class="jumbotron">
	        <p class="lead">No existen pedidos para despachar mañana.</p>
	        <a class="btn btn-large btn-success" id="monitoreoBtn">Ir a monitoreo</a><br>
      	</div>
	</c:when>
	<c:when test="${empty bodegas}">
		<div id="step1" class="jumbotron">
        	<p class="lead">Las hojas de rutas se construirán para los pedidos a despachar mañana.</p>
        	<a class="btn btn-large btn-success" id="generarBtn">Iniciar construcción</a><br>
        	<div id="construyendo" style="display:none">
        		<p>Procesando...</p>
        		<img
        			src="${pageContext.request.contextPath}/images/procesando.gif"
        			class="img-thumbnail" height="100" width="100"
        			alt="Procesando..."></div>
        	<br>
        	<hr>
        	<a id="pedidosBtn">Ver detalle pedidos a procesar</a>
        	
        	<div id="detallePedidos" class="container" style="display:none">
        		<table class="table">
        			<thead>
        				<tr>
						<th style="text-align: center">#</th>
						<th style="text-align: center">PEDIDO</th>
						<th style="text-align: center">TIPO DE ATENCIÓN</th>
						<th style="text-align: center">TIPO DE DESPACHO</th>
						</tr>
        			</thead>
	        		<tbody>
	        			<c:forEach items="${pedidos }" var="pedido" varStatus="loop">
						<tr>
							<td>${loop.index + 1 }</td>
							<td>${pedido.codigoPedido }</td>
							<td>${pedido.clasificacionTipo }</td>
							<td>${pedido.clasificacionFecha }</td>
						</tr>	        			
	        		</c:forEach>
	        		</tbody>
        		</table>
        	</div>
        	
        	
      	</div>
		<div id="step2" class="jumbotron" style="display:none">
	        <p class="lead">Ya se generaron las hojas de ruta, para descargar, por favor elija una bodega.</p>
	        <select id="bodegasList"  class="selectpicker">
	        </select>
	        <a class="btn btn-large btn-success" id="descargarBtn">Descargar</a>
	        <br>
	        <hr>
	        <a id="limpiarBtn">Limpiar la data (para volver a generar rutas)</a>
      	</div>
	</c:when>
	<c:otherwise>
		<div id="step2" class="jumbotron">
	        <p class="lead">Ya se generaron las hojas de ruta, para descargar, por favor elija una bodega.</p>
	        <select id="bodegasList"  class="selectpicker">
	        	<c:forEach items="${bodegas}" var="bodega" >
	        		<option value="${bodega}">${bodega}</option>
	        	</c:forEach>
	        </select>
	        <a class="btn btn-large btn-success" href="#" id="descargarBtn">Descargar</a>
	        <br>
	        <hr>
	        <a id="limpiarBtn">Limpiar la data (para volver a generar rutas)</a>
      	</div>
	</c:otherwise>
</c:choose>
<hr>


<hr>
