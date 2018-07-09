function establecerParadasRuta() {
	return new Promise((resolve,reject)=>{
		
		localforage.getItem("destinoSeleccionado").then(destino=>{
			localforage.getItem("unidadSeleccionada").then(unidadSeleccionada=>{
				let pedido = {
						codigoPedido: destino.pedido,
						codigoHojaRuta: unidadSeleccionada.codigoHojaRuta,
						unidadAsignada: {
							numeroPlaca: unidadSeleccionada.unidad.placa
						}
				};
				obtenerPuntoDePartida(pedido).then(origen=>{
					var directionsService = new google.maps.DirectionsService();
					 var request = {
						origin: new google.maps.LatLng(origen.lat,origen.lng),
						destination: destino.destino,
						travelMode: 'DRIVING'
					 };
					 const tripPoints = [];
					 directionsService.route(request, function(result, status) {
						    if (status == 'OK') {
						    	const route = result.routes[0];
						    	
						    	//Calculo de distancia total
						    	let distanciaPendiente = 0;
						    	let demoraPendiente = 0;
						    	route.legs.forEach(leg=>{
						    		distanciaPendiente += leg.distance.value;
						    		demoraPendiente += leg.duration.value;
						    	});
						    	console.log("Distancia pendiente",distanciaPendiente);
						    	console.log("Demora pendiente",demoraPendiente);
						    	
						    	route.legs.forEach(leg=>{
						    		leg.steps.forEach(step=>{
						    			const durationInSeconds = step.duration.value;
						    			distanciaPendiente -= step.distance.value;
						    			demoraPendiente -= step.duration.value;
						    			
						    			tripPoints.push({
						    				placa: pedido.unidadAsignada.numeroPlaca,
						    				timeleft: formatTime(demoraPendiente),
											distanceleft: formatDistance(distanciaPendiente),
						    				locations: {
						    					lat : step.start_location.lat(),
						    					lng : step.start_location.lng()
						    				}
						    			});
						    		});
						    	});
						    	localforage.setItem("tripLocations",tripPoints)
						    		.then(()=>{
						    			resolve();
						    		});
						    } else {
						    	console.log("Something fail on request directions");
						    }
					  });
				});
			});
		});
	});
	 
}
var refreshIntervalId;
function simularMovimiento(control) {
	console.log("Se inicia simulacion");
	localforage.getItem("tripLocations").then(tripPoints=>{
		console.log("Simulando movimiento desde: " + control.step);
		let index = control.step;
		refreshIntervalId = setInterval(()=>{
			tripPoints[index];
			let myUnidadLocation = {
					route_id: 'A034',
					route_name: 'Ruta_34',
					route_color: 'FCE444',
					placa: tripPoints[index].placa,
					timeleft: tripPoints[index].timeleft,
					distanceleft: tripPoints[index].distanceleft,
					lat: tripPoints[index].locations.lat,
					lng: tripPoints[index].locations.lng
			};
			
			const unidadesLocations = {
					"viaje" : myUnidadLocation
			};
			firebaseDB.ref('gesatepedUnidad').set(unidadesLocations);
			index++;
			control.step = index;
			if(control.stop) {
				console.log("Simulación pausada");
				clearInterval(refreshIntervalId);
			} else if(index == tripPoints.length) {
				console.log("Fin de simulación");
				control.reset();
				clearInterval(refreshIntervalId);
			}
		},2000);
	});
}

function detenerSimulacion() {
	if(refreshIntervalId) {
		clearInterval(refreshIntervalId);
	}
}

function cancelarSimulacion() {
	if(refreshIntervalId) {
		clearInterval(refreshIntervalId);
	}
}


function Simulador(trigger,stopper,reactivate) {
	this.trigger = trigger;
	this.stopper = stopper;
	this.reactivate = reactivate;
	this.stop = false;
	this.step = 0;
	
	this.trigger.unbind("click");
	this.stopper.unbind("click");
	this.reactivate.unbind("click");
	
	this.trigger.click((event)=>{
		event.preventDefault();
		this.stopper.show();
		this.trigger.hide();
		this.reactivate.hide();
		establecerParadasRuta().then(()=>{
			this.iniciar();
		});
	});

	this.stopper.click((event)=>{
		event.preventDefault();
		this.reactivate.show();
		this.stopper.hide();
		this.detener();
	});

	this.reactivate.click((event)=>{
		event.preventDefault();
		this.stopper.show();
		this.reactivate.hide();
		this.iniciar();
	});
	
	this.iniciar = function() {
		this.stop = false;
		simularMovimiento(this);
	};
	this.detener = function() {
		this.stop = true;
	};
	this.cancelar = function() {
		this.step = 0;
		this.trigger.show();
		this.stopper.hide();
		this.reactivate.hide();
		this.detener();
	};
	this.reset = function() {
		this.step = 0;
		this.stop = false;
		this.trigger.show();
		this.stopper.hide();
		this.reactivate.hide();
	}
}



