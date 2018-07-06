<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="masthead">
        <ul class="nav nav-pills pull-right">
        	<c:choose>
	        	<c:when test="${menu eq 'monitoreo'}">
	        		<li><a href="${pageContext.request.contextPath}/">Inicio</a></li>
			          <li class="active"><a href="${pageContext.request.contextPath}/monitoreo">Monitoreo</a></li>
			          <li><a href="#">Configuración</a></li>
	        	</c:when>
	        	<c:otherwise>
	        		<li class="active"><a href="${pageContext.request.contextPath}/">Inicio</a></li>
			          <li><a href="${pageContext.request.contextPath}/monitoreo">Monitoreo</a></li>
			          <li><a href="#">Configuración</a></li>
	        	</c:otherwise>
        	</c:choose>
        </ul>
        <h3 class="muted">GESATEPED</h3>
</div>
