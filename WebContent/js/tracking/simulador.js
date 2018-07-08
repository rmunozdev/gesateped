function establecerParadasRuta() {
	let finishPromise = new Promise((resolve,reject)=>{
		
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
	 return finishPromise;
}
var refreshIntervalId;
function simularMovimiento() {
	console.log("Se inicia simulacion");
	localforage.getItem("tripLocations").then(tripPoints=>{
		let index = 0;
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
					"Trip_X" : myUnidadLocation
			};
			firebaseDB.ref('gesatepedUnidad').set(unidadesLocations);
			index++;
			if(index == tripPoints.length) {
				console.log("Fin de simulación");
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



