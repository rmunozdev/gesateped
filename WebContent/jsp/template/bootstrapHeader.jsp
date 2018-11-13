<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="masthead cabecera">
        <ul class="nav nav-pills pull-right">
        	<c:choose>
	        	<c:when test="${menu eq 'monitoreo'}">
	        		<li><a href="${pageContext.request.contextPath}/">Inicio</a></li>
			        <li class="active"><a href="${pageContext.request.contextPath}/monitoreo">Monitoreo</a></li>
	        		<li><a href="${pageContext.request.contextPath}/carga">Abastecimiento de Productos</a></li>
	        	</c:when>
	        	<c:when test="${menu eq 'carga'}">
	        		<li><a href="${pageContext.request.contextPath}/">Inicio</a></li>
			        <li><a href="${pageContext.request.contextPath}/monitoreo">Monitoreo</a></li>
	        		<li class="active"><a href="${pageContext.request.contextPath}/carga">Abastecimiento de Productos</a></li>
	        	</c:when>
	        	<c:otherwise>
	        		<li class="active"><a href="${pageContext.request.contextPath}/">Inicio</a></li>
			        <li><a href="${pageContext.request.contextPath}/monitoreo">Monitoreo</a></li>
			        <li><a href="${pageContext.request.contextPath}/carga">Abastecimiento de Productos</a></li>
	        	</c:otherwise>
        	</c:choose>
        </ul>
        <h3 class="muted"><img src="${pageContext.request.contextPath}/images/sodimaclogo.jpg" alt="sodimac logo"></h3>
</div>
