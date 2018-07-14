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
	
	window.addEventListener('load',iniciar);
})();

var reloadTask;

function UnidadSeleccionada(hojaRuta,placa) {
	this.hojaRuta = hojaRuta;
	this.placa = placa;
}

function iniciar() {
	var paths = {
		marker : _globalContextPath+"/images/location-marker.png"
	}
	crearTablaUnidades();
	crearTablaPedidosAtendidos(paths);
	crearTablaPedidosNoAtendidos(paths);
	crearTablaPedidosPendientes(paths);
	crearTablaPedidosReprogramados();
	crearTablaPedidosCancelados();
}


function actualizarUnidadesPorBodega(){
	stopAutoRefresh();
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
				$('#panelUnidades').show();
				actualizarTablaUnidades(data);
			} else {
				$('#panelUnidades').hide();
			}
		}
	});
	//Ver estados de pedidos por bodega
	$.ajax({
		url: _globalContextPath+'/monitoreo/verEstadoPedidosPorBodega',
		type: 'POST',
		data: form.serialize(),
		Accept : 'application/json',
		success:function(data){
			if(data.length && data.length > 0) {
				$("#graficaTotalBodega").show();
				$("#noHayPedidosMsg").hide();
				actualizarGraficaEstadoPedidosPorBodega(data);	
			} else {
				$("#graficaTotalBodega").hide();
				$("#noHayPedidosMsg").show();
			}
		}
	});
	
}

function verDashBoardUnidad(codigoHojaRuta) {
	stopAutoRefresh();
	$.ajax({
		url: _globalContextPath+'/monitoreo/verEstadoPedidos',
		type: 'POST',
		data: {codigoHojaRuta : codigoHojaRuta},
		Accept : 'application/json',
		success:function(data){
			if(data.length && data.length > 0) {
				//Se establece unidad en base a codigo de ruta seleccionado
				localforage.getItem(codigoHojaRuta)
				.then(unidad => {
					localforage.setItem("unidadSeleccionada",{
						unidad: unidad,
						codigoHojaRuta: codigoHojaRuta
					}).then(()=>{
						showAllDetails();
						crearGrafica(data);
						verDetallePedidosAtendidos(codigoHojaRuta);
						verDetallePedidosNoAtendidos(codigoHojaRuta);
						verDetallePedidosPendientes(codigoHojaRuta);
						verDetallePedidosReprogramados(codigoHojaRuta);
						verDetallePedidosCancelados(codigoHojaRuta);
						
						startAutoRefresh(codigoHojaRuta);
					});
				});
				
				
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
	            	(estadoPedidos[0].porcentaje  * 100).toFixed(2), 
	            	(estadoPedidos[1].porcentaje  * 100).toFixed(2), 
	            	(estadoPedidos[2].porcentaje  * 100).toFixed(2), 
	            	(estadoPedidos[3].porcentaje  * 100).toFixed(2), 
	            	(estadoPedidos[4].porcentaje  * 100).toFixed(2)
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
	    options: {
	    	legend: {
	    		position: "left"
	    	}
	    }
	});
}

function actualizarGraficaEstadoPedidosPorBodega(estadoPedidos) {
	var ctx = document.getElementById("chartPedidosPorBodega").getContext('2d');
	var myDoughnutChart = new Chart(ctx, {
	    type: 'doughnut',
	    data: {
	        datasets: [{
	            data: [
	            	(estadoPedidos[0].porcentaje  * 100).toFixed(2), 
	            	(estadoPedidos[1].porcentaje  * 100).toFixed(2), 
	            	(estadoPedidos[2].porcentaje  * 100).toFixed(2), 
	            	(estadoPedidos[3].porcentaje  * 100).toFixed(2), 
	            	(estadoPedidos[4].porcentaje  * 100).toFixed(2)
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
	    options: {
	    	legend: {
	    		position: "left"
	    	}
	    }
	});
}

function verDetallePedidosAtendidos(codigoHojaRuta) {
	$.ajax({
		url: _globalContextPath+'/monitoreo/verDetallePedidosAtendidos',
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
		url: _globalContextPath+'/monitoreo/verDetallePedidosNoAtendidos',
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
		url: _globalContextPath+'/monitoreo/verDetallePedidosPendientes',
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
		url: _globalContextPath+'/monitoreo/verDetallePedidosReprogramados',
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
		url: _globalContextPath+'/monitoreo/verDetallePedidosCancelados',
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
	$("#accordion").show();
}

function hideAllDetails() {
	$("#graficaTotalUnidad").hide();
	$("#accordion").hide();
}

function detectarCambios(codigoHojaRuta) {
	//Conteo de resultados
	var status = {
		codigoHojaRuta: codigoHojaRuta,
		atendidos: $('#tblPedidosAtendidos').dataTable().fnGetData().length,
		noAtendidos: $('#tblPedidosNoAtendidos').dataTable().fnGetData().length,
		pendientes: $('#tblPedidosPendientes').dataTable().fnGetData().length,
		reprogramados: $('#tblPedidosReprogramados').dataTable().fnGetData().length,
		cancelados: $('#tblPedidosCancelados').dataTable().fnGetData().length
	}
	$.ajax({
		url: _globalContextPath+'/monitoreo/reload',
		type: 'POST',
		data: status,
		Accept : 'text/plain',
		success:function(data){
			console.log(data);
			if(data) {
				console.log("Success");
				verDashBoardUnidad(codigoHojaRuta);
			} else {
				console.log("Fail");
			}
		}
	});
}

function startAutoRefresh(codigoHojaRuta) {
	reloadTask = setInterval(() => {
		detectarCambios(codigoHojaRuta);
	}, 10*1000);
}

function stopAutoRefresh() {
	if(reloadTask) {
		clearInterval(reloadTask);
	}
}


