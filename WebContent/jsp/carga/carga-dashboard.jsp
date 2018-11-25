<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/carga/inicio.css">
<div>
		<%-- Formularios 
			Orientacion bootstrap:
			https://getbootstrap.com/docs/3.3/css/#forms
			https://stackoverflow.com/questions/12201835/form-inline-inside-a-form-horizontal-in-twitter-bootstrap
		--%>
	<div class="jumbotron cabecera-narrow">
        <p class="lead titulo-abastecimiento">ABASTECIMIENTO DE PRODUCTOS</p>
      </div>
	<form:form id="frmCarga" commandName="carga" class="form-horizontal" role="form">
		<div id="formContainer" class="row-fluid marketing" style="display:block;">
			<div id="formPanel" class="span12 panel panel-default">
				<div class="panel-body">
					<div>
						<label class="control-label">Tipo de Abastecimiento:</label>
					</div>
					<div class="form-inline row">
						<div class="col-md-12">
							<div class="control-group row">
									<label for="radioTipoCompra" class="col-md-3 control-label">Compra</label>
									<div class="col-md-3">
										<input type="radio" id="radioTipoCompra" name="tipo" value="compra" class="form-control" >
									</div>
									<label for="radioTipoReposicion" class="col-md-3 control-label">Reposici&oacute;n</label>
									<div class="col-md-3">
										<input type="radio" id="radioTipoReposicion" name="tipo" value="reposicion" class="form-control" checked>
									</div>
							</div>
						 </div>
					</div>
					<div id="fieldProveedor" style="display:none">
						<label class="control-label" >Proveedor:</label>
						<label id="lblErrorProveedor" style="display:none" class="validacion-alerta"></label>
						<form:select path="proveedor.codigo" class="custom-select form-control">
								<form:option value="0" label="-- Seleccione --"></form:option>
								<form:options items="${proveedores}" itemValue="codigo" itemLabel="razonSocial" />
						</form:select>
					</div>
					<div id="fieldBodega" >
						<label class="control-label">Bodega:</label>
						<label id="lblErrorBodega" style="display:none" class="validacion-alerta"></label>
						<form:select path="bodega.codigo" class="custom-select form-control">
							<form:option value="0" label="-- Seleccione --"></form:option>
							<form:options items="${bodegas}" itemValue="codigo" itemLabel="nombre" />
						</form:select>
					</div>
					<div id="fieldNodo"  >
						<label class="control-label">Nodo:</label>
						<label id="lblErrorNodo" style="display:none" class="validacion-alerta"></label>
						<form:select path="nodo.codigo" class="custom-select form-control">
							<form:option value="0" label="-- Seleccione --"></form:option>
							<form:options items="${nodos}" itemValue="codigo" itemLabel="nombre" />
						</form:select>
					</div>
					
					<div>
						<label id="lblFecha" class="control-label">Fecha de Reposici&oacute;n:</label>
						<label id="lblErrorFecha" style="display:none" class="validacion-alerta"></label>
					</div>
					
					<div id="fieldCsv" class="left-text input-group date">
						<input type="text" id="fecha" name="fecha" class="form-control" placeholder="Click para elegir" readonly="readonly">
						<div id="myDatepickerTrigger" class="input-group-addon">
					        <span class="glyphicon glyphicon-th"></span>
					    </div>
					</div>
					
					<input type="hidden" id="maxFileSize" value="${maxFileSize}">
					<div id="fieldCsv" class="left-text">
						<label class="control-label">Seleccione el archivo CSV a cargar:</label>
						<label id="lblErrorArchivo" style="display:none" class="validacion-alerta"></label>
						<input id="fileCSV" type="file" name="file" class="form-control"/>
						<a href="carga/ver-plantilla">Descargar plantilla CSV</a>
					</div>
					<div class="text-center">
				        <a class="btn btn-success " id="procesarBtn">Procesar</a><br>
			      	</div>
				</div>
			</div>
		</div>
	</form:form>
	
	
	<%-- Grilla Resumen --%>
	<div id="panelResumen" class="row-fluid marketing" style="display:none;">
			<div class="span12 panel panel-default">
				<div class="panel-body">
					<h4 class="tbl-descripcion open">Resumen de la Carga de Datos</h4>
					<div class="tbl-contenedor">
						<table id="tblResumenCarga" class="table">
							<tr>
								<th><label>Registros cargados</label></th>
								<td><label id="registrosCargados"></label></td>
							</tr>
							<tr>
								<th><label>Registros omitidos</label></th>
								<td><label id="registrosOmitidos"></label></td>
							</tr>
							<tr>
								<th><label>Registros con error</label></th>
								<td><label id="registrosConError"></label></td>
							</tr>
							<tr>
								<th><label>Total de registros</label></th>
								<td><label id="totalRegistros"></label></td>
							</tr>
						</table>
					</div>
				</div>
			</div>
	</div>
	
		
	<%-- Grilla Errores (paginado) --%>
	<div id="panelErrores" class="row-fluid marketing" style="display:none">
			<div class="span12 panel panel-default">
				<div class="panel-body">
					<h4 class="tbl-descripcion open">
					Lista de Errores en la Carga de Datos
					</h4>
					<img id="xlsxBtn" src="${pageContext.request.contextPath}/images/carga/iconoExportar.png" width="48" alt="Ver xlsx" title="Exportar" style="display:none"><br>
					<div class="row">
						<div class="tblErrorCargaContainer span10">
							<table id="tblErrorCarga" class="table">
								<thead>
									<tr>
										<th>
											<label>Registro</label>
										</th>
										<th>
											<label>Mensaje</label>
										</th>
									</tr>
								</thead>
								<tbody id="tbodyErrorCarga"></tbody>
							</table>
						</div>
					</div>
					<!-- <a class="btn btn-large btn-success xlsx-localizado-button" id="xlsxBtn">Ver xlsx</a><br> -->
				</div>
			</div>
	</div>
	
</div>

<script src="${pageContext.request.contextPath}/js/jquery.fileDownload.js"></script>
<script src="${pageContext.request.contextPath}/js/carga/inicio.js"></script>