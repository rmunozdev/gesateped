/**
 * 
 */
(()=>{
		window.addEventListener('load',iniciar);
})();


function iniciar() {
	console.log("Inicio de js para carga");
	observarModificacionTipo();
	activarDatePicker();
	desactivarProcesamiento();
	crearTablas();
	//presentarTabla(misErrores);
}

var archivo;
function observarModificacionTipo() {
	$('input[type=radio][name=tipo]').change(function() {
	    if (this.value == 'compra') {
	        $('#fieldProveedor').show();
	        $('#fieldNodo').hide();
	        $('#lblFecha').html('Fecha de Abastecimiento:');
	    }
	    else if (this.value == 'reposicion') {
	    	$('#fieldProveedor').hide();
	    	$('#fieldNodo').show();
	    	$('#lblFecha').html('Fecha de Reposición:');
	    }
	    //Cualquier cambio limpia y oculta info de resultados
	    $('#proveedor\\.codigo').val(function(){ return '0';});
	    $('#bodega\\.codigo').val(function(){ return '0';});
	    $('#nodo\\.codigo').val(function(){ return '0';});
	    $('#fecha').val(function(){ return '';});
	    $('#fileCSV').val(function(){ return '';});
	    $('#lblErrorArchivo').hide(); //Se oculta validacion
	    
	    $('#panelErrores').hide();
	    $('#panelResumen').hide();
	    validForm();
	});
	
	$("#fecha").change(validForm);
	$('#proveedor\\.codigo').change(validForm);
	$('#bodega\\.codigo').change(validForm);
	$('#nodo\\.codigo').change(validForm);
	$('#fileCSV').change(function(){
		archivo = this.files[0];
		validForm();
	});
}

function activarDatePicker() {
	var myDatepicker = $( "#fecha" ).datepicker({ 
		dateFormat: 'dd/mm/yy'
	});
	
	$('#myDatepickerTrigger').click(function() {
		myDatepicker.focus();
	});
}


function activarProcesamiento() {
	$("#procesarBtn").unbind("click");
	$("#procesarBtn").click((event)=>{
		enviarFormulario();
	});
	$("#procesarBtn").removeClass("disabled");
}
function desactivarProcesamiento() {
	$("#procesarBtn").unbind("click");
	$("#procesarBtn").addClass("disabled");
}

function enviarFormulario() {
	var form  = $('#frmCarga')[0];
	var data = new FormData(form);
	
	$.ajax({
		url: _globalContextPath+'/carga/procesar',
		type: 'POST',
		enctype: 'multipart/form-data',
		data: data,
		processData: false,
		contentType: false,
		cache: false,
		Accept: 'application/json',
		success: mostrarResumen
	});
}

function mostrarResumen(data) {
	console.log(data);
	presentarResumen(data);
	if(data.errores && data.errores.length > 0) {
		$('#panelErrores').show();
		presentarTabla(data.errores);
	} else {
		$('#panelErrores').hide();
	}
}

function presentarResumen(resumen) {
	if(resumen.codigoRespuesta != -1) {
		$('#panelResumen').show();
		$('#registrosCargados').html(resumen.cargados | 0);
		$('#registrosOmitidos').html(resumen.omitidos | 0);
		$('#registrosConError').html(resumen.errores.length);
		$('#totalRegistros').html(resumen.total);
	} else {
		$('#panelResumen').hide();
	}
	
	if(resumen.validacionProveedor || resumen.validacionProveedor != '') {
		$('#lblErrorProveedor').show();
		$('#lblErrorProveedor').html(resumen.validacionProveedor);
	} else {
		$('#lblErrorProveedor').hide();
	}
	
	if(resumen.validacionBodega || resumen.validacionBodega != '') {
		$('#lblErrorBodega').show();
		$('#lblErrorBodega').html(resumen.validacionBodega);
	} else {
		$('#lblErrorBodega').hide();
	}
	
	if(resumen.validacionNodo || resumen.validacionNodo != '') {
		$('#lblErrorNodo').show();
		$('#lblErrorNodo').html(resumen.validacionNodo);
	} else {
		$('#lblErrorNodo').hide();
	}
	
	if(resumen.validacionFecha || resumen.validacionFecha != '') {
		$('#lblErrorFecha').show();
		$('#lblErrorFecha').html(resumen.validacionFecha);
	} else {
		$('#lblErrorFecha').hide();
	}
	
	if(!resumen.archivoCsvOk) {
		$('#lblErrorArchivo').show();
		$('#lblErrorArchivo').html("Debe adjuntar un archivo con formato y extensión CSV.");
	} else {
		$('#lblErrorArchivo').hide();
	}
	
	
}

var tablaErrores;
function crearTablas() {
	/*
	 * Para configurar ver: 
	 * https://datatables.net/reference/option/language
	 * http://legacy.datatables.net/usage/i18n
	 * 
	 * Ancho de columnas
	 * https://datatables.net/reference/option/columns.width
	 * 
	 * Personalizacion de tabla (sDom): 
	 * http://legacy.datatables.net/usage/options
	 */
	var config = {
			"sDom": '<"toolbar"lp><"xlsx">rt<"info"i>',
			'bPaginate':  true,
			'bFilter'	: true,
			'bAutoWidth': false,
			'aoColumns': [
				{'sWidth':'16%','mData' : 'registro', "sClass": "columnaCentrada"},
				{}
			],
			'aoColumnDefs': [
				{
					'aTargets':[1],
					'sWidth': '84%',
					'mData': null,
					'mRender': function(data, type, row, position) {
						return data.mensaje;
					}
				}
			],
			"oLanguage" : {
				"sEmptyTable": "No se encontraron errores",
				"sLengthMenu": "Mostrar _MENU_ registros.",
				"sInfo": "Mostrando _START_ al _END_ de _TOTAL_ registros",
				"oPaginate": {
			        "sFirst":      "Primero",
			        "sLast":       "Último",
			        "sNext":       ">>",
			        "sPrevious":   "<<"
			    },
			}
		};
	tablaErrores = $('#tblErrorCarga').dataTable(config);
	var btnExportar = $( "#xlsxBtn" ).clone();
	btnExportar.appendTo( "div.xlsx" ).show();
	btnExportar.click(exportar);
}

var misErrores = [
	{
		'registro' : 1,
		'mensaje' : 'Falla general'
	},
	{
		'registro' : 2,
		'mensaje' : 'Falla general'
	},
	{
		'registro' : 3,
		'mensaje' : 'Falla general'
	},
	{
		'registro' : 4,
		'mensaje' : 'Este es un contenido extensamente largo, lo usual seria mas pequeño pero se necesita hacerlo asi para probar'
	},
	{
		'registro' : 5,
		'mensaje' : 'Falla general'
	},
	{
		'registro' : 6,
		'mensaje' : 'Falla general'
	},
	{
		'registro' : 7,
		'mensaje' : 'Falla general'
	},
	{
		'registro' : 8,
		'mensaje' : 'Falla general'
	},
	{
		'registro' : 18,
		'mensaje' : 'Falla general'
	},
	{
		'registro' : 9,
		'mensaje' : 'Falla general'
	}
];

function presentarTabla(errores) {
	//Fix se suspende lógica de paginación.
//	if(errores.length < 11) {
//		$('.toolbar').hide();
//		$('.dataTables_length').hide();
//		$('.dataTables_paginate').hide();
//		$( ".xlsx img" ).css("float","right");
//	} else {
//		$( ".xlsx img" ).css("float","none");
//	}
	$( ".xlsx img" ).css("float","none");
	
	
	tablaErrores.fnClearTable();
	tablaErrores.fnAddData(errores);
	tablaErrores.fnDraw();
	tablaErrores.fnPageChange('first');
}

function exportar(event) {
	event.preventDefault();
	$.fileDownload('carga/exportar-excel', {data: {}})
    .done(function () { 
    	alert('File download a success!'); 
    })
    .fail(function () { 
    	alert('File download failed!'); 
    });
}

function validForm() {
	console.log("Validacion de formulario");
	if(validFile()
		&& validBodega()
		&& validNodo()
		&& validFecha()
		&& validProveedor()
	) {
		console.log("Formulario valido");
		activarProcesamiento();
	} else {
		console.log("Formulario no valido");
		desactivarProcesamiento();
	}
}

function validFileSize() {
	if(archivo) {
		if(parseInt(archivo.size) > parseInt($("#maxFileSize").val())) {
			$('#lblErrorArchivo').show();
			$('#lblErrorArchivo').html("•	Debe adjuntar un archivo que no exceda los "+  $("#maxFileSize").val() +" bytes de capacidad");
		} else {
			$('#lblErrorArchivo').hide();
			$('#lblErrorArchivo').html("");
		}
		return parseInt(archivo.size) < parseInt($("#maxFileSize").val());
	} else {
		return false;
	}
}

function validFile() {
	return $('#fileCSV').val() && $('#fileCSV').val().trim() != "" && validFileSize();
}

function validProveedor() {
	if ($('#proveedor\\.codigo').is(":hidden")) {
		return true;
	}
	return $('#proveedor\\.codigo').val() && $('#proveedor\\.codigo').val() != 0;
}

function validBodega() {
	if ($('#bodega\\.codigo').is(":hidden")) {
		return true;
	}
	return $('#bodega\\.codigo').val() && $('#bodega\\.codigo').val() != 0;
}
function validNodo() {
	if ($('#nodo\\.codigo').is(":hidden")) {
		return true;
	}
	return $('#nodo\\.codigo').val() && $('#nodo\\.codigo').val() != 0;
}

function validFecha() {
	return $('#fecha').val() && $('#fecha').val().trim() != "";
}
