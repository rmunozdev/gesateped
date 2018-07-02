<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>

<!doctype html>

<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title><tiles:getAsString name="title" /></title>
	<link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/favicon.png">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery/jquery-ui.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery/jquery-ui.structure.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery/jquery-ui.theme.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
	
	<script src="${pageContext.request.contextPath}/js/jquery/jquery.js"></script>
	<script src="${pageContext.request.contextPath}/js/jquery/jquery-ui.js"></script>
</head>
<body>
	<table style="width: 100%" class="tableLayout">
		<tr>
			<td colspan="3"><tiles:insertAttribute name="header" /></td>
		</tr>
		<tr>
			<td style="width: 210px" valign="top"><tiles:insertAttribute name="menu" /></td>
			<td style="width: 20px" class="fondoBody"></td>
			<td class="fondoBody" valign="top"><tiles:insertAttribute name="body" /></td>
		</tr>
	</table>
</body>
</html>