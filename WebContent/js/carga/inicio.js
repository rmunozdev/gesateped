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
	activarExportacion();
	crearTablas();
}

var archivo;
function observarModificacionTipo() {
	$('input[type=radio][name=tipo]').change(function() {
	    if (this.value == 'compra') {
	        $('#fieldProveedor').show();
	        $('#fieldNodo').hide();
	        $('#lblFecha').html('Fecha de Abastecimiento');
	    }
	    else if (this.value == 'reposicion') {
	    	$('#fieldProveedor').hide();
	    	$('#fieldNodo').show();
	    	$('#lblFecha').html('Fecha de Reposición');
	    }
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
	$('#panelResumen').show();
	$('#registrosCargados').html(resumen.cargados | 0);
	$('#registrosOmitidos').html(resumen.omitidos | 0);
	$('#registrosConError').html(resumen.errores.length);
	$('#totalRegistros').html(resumen.total);
	
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
			'bPaginate':  true,
			'bFilter'	: false,
			'aoColumns': [
				{'sWidth':'20%','mData' : 'registro'},
				{}
			],
			'aoColumnDefs': [
				{
					'aTargets':[1],
					'sWidth': '80%',
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
			        "sNext":       "Siguiente",
			        "sPrevious":   "Anterior"
			    },
			}
		};
	tablaErrores = $('#tblErrorCarga').dataTable(config);
}

function presentarTabla(errores) {
	tablaErrores.fnClearTable();
	tablaErrores.fnAddData(errores);
	tablaErrores.fnDraw();
	tablaErrores.fnPageChange('first');
}

function activarExportacion() {
	$('#xlsxBtn').click((event=>{
		event.preventDefault();
		$.fileDownload('carga/exportar-excel', {data: {}})
	    .done(function () { 
	    	alert('File download a success!'); 
	    })
	    .fail(function () { 
	    	alert('File download failed!'); 
	    });
	}));
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
