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
		document.getElementById("generarBtn").onclick = generarRutas;
		document.getElementById("descargarBtn").onclick = descargarReporte;
	}
	
	function generarRutas() {
		fetch('admin/runbatch').then(response=>{
			console.log("Runbatch success");
		});
	}
	
	function descargarReporte() {
		$.fileDownload('admin/generarReporte')
	    .done(function () { 
	    	alert('File download a success!'); 
	    })
	    .fail(function () { 
	    	alert('File download failed!'); 
	    });
	}

</script>
<div>
	<h1>Generador de hoja de ruta</h1>
	<h2>Control</h2>
	<div>
		<span>
			<button id="generarBtn">Generar Hoja de Ruta</button>
		</span>
		<span>
			<button id="descargarBtn">Descargar Reporte</button>
		</span>
		
	</div>
</div>