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
	            	estadoPedidos[0].porcentaje, //pendientes
	            	estadoPedidos[1].porcentaje, //atendidos
	            	estadoPedidos[2].porcentaje, //no atendidos
	            	estadoPedidos[3].porcentaje, //reprogramados
	            	estadoPedidos[4].porcentaje //cancelados
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
	    options: {}
	});
}

function actualizarGraficaEstadoPedidosPorBodega(estadoPedidos) {
	var ctx = document.getElementById("chartPedidosPorBodega").getContext('2d');
	var myDoughnutChart = new Chart(ctx, {
	    type: 'doughnut',
	    data: {
	        datasets: [{
	            data: [
	            	estadoPedidos[0].porcentaje, 
	            	estadoPedidos[1].porcentaje, 
	            	estadoPedidos[2].porcentaje, 
	            	estadoPedidos[3].porcentaje, 
	            	estadoPedidos[4].porcentaje
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
	    options: {}
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