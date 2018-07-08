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
		}
		document.getElementById("descargarBtn").onclick = descargarReporte;
	}
	var myresponse;
	function generarRutas(event) {
		event.preventDefault();
		fetch('starter/construir').then(response => response.json()).then(data=>{
			myresponse = data;
			if(data) {
				//Construir select para la data.
				var sel = $('#bodegasList');
				data.forEach((bodega)=>{
					console.log("value added",bodega);
					sel.append($('<option value="'+bodega+'">'+bodega+'</option>'));
				});
				//sel.addClass('selectpicker');
				$('.selectpicker').selectpicker('render');
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

</script>
<c:choose>
	<c:when test="${empty bodegas}">
		<div id="step1" class="jumbotron">
        	<p class="lead">Las hojas de rutas se construirán para los pedidos a despachar mañana.</p>
        	<a class="btn btn-large btn-success" href="#" id="generarBtn">Iniciar construcción</a>
      	</div>
		<div id="step2" class="jumbotron" style="display:none">
	        <p class="lead">Ya se generaron las hojas de ruta, para descargar, por favor elija una bodega.</p>
	        <select id="bodegasList"  class="selectpicker">
	        </select>
	        <a class="btn btn-large btn-success" href="#" id="descargarBtn">Descargar</a>
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
      	</div>
	</c:otherwise>
</c:choose>

<hr>


<hr>
