/**
 * 
 */
function iniciarSimulacion() {
	let geocoder = new google.maps.Geocoder();
	//Avenida Angamos Oeste 371, Miraflores Peru
	geocoder.geocode({
		address: "Avenida Angamos Oeste 371, Miraflores Peru"}, 
		(results, status) => {
		let myUnidadLocation = {
				route_id: 'A034',
				route_name: 'Ruta_34',
				route_color: 'FCE444',
				lat: results[0].geometry.location.lat(),
				lng: results[0].geometry.location.lng()
		};
		
		const unidadesLocations = {
				"Trip_X" : myUnidadLocation
		};
		firebaseDB.ref('gesatepedUnidad').set(unidadesLocations);
	});
}

function establecerPosicionUnidad() {
	localforage.getItem("destinoSeleccionado").then(destino=>{
		 localforage.getItem("unidadSeleccionada").then((unidadSeleccionada)=>{
				console.log(unidadSeleccionada);
				//Se obtiene posicion inicial
				$.ajax({
					url: _globalContextPath+'/sim/partidas',
					type: 'POST',
					data: {codigoRuta: unidadSeleccionada.codigoHojaRuta},
					Accept: "application/json", 
					success: function(partidas) {
						console.log("Partidas",partidas);
						partidas.forEach((partida,index)=>{
							if(partida.codigoPedido == destino.pedido) {
								console.log("Partida elegida: ",partida);
								
								//Posicion original
								let geocoder = new google.maps.Geocoder();
								geocoder.geocode({
									address:partida.direccion},
									(results,status)=>{
										let myUnidadLocation = {
												route_id: 'A034',
												route_name: 'Ruta_34',
												route_color: 'FCE444',
												lat: results[0].geometry.location.lat(),
												lng: results[0].geometry.location.lng()
										};
										const unidadesLocations = {
												"Trip_X" : myUnidadLocation
										};
										firebaseDB
											.ref('gesatepedUnidad')
											.set(unidadesLocations).then(()=>{
												establecerParadasRuta(destino,myUnidadLocation);
										});
								});
							}
						});
					}
				});
		});
	 });
	 
}

function establecerParadasRuta(destino,unidadLocation) {
	 var directionsService = new google.maps.DirectionsService();
	 console.log("destino",destino);
	 console.log("Unidad",unidadLocation);
	 var request = {
		origin: new google.maps.LatLng(unidadLocation.lat,unidadLocation.lng),
		destination: destino.destino,
		travelMode: 'DRIVING'
	 };
	 const tripPoints = [];
	 directionsService.route(request, function(result, status) {
		    if (status == 'OK') {
		    	const route = result.routes[0];
		    	console.log("Route",route);
		    	route.legs.forEach(leg=>{
		    		leg.steps.forEach(step=>{
		    			const durationInSeconds = step.duration.value;
		    			tripPoints.push({
		    				duration: durationInSeconds,
		    				locations: {
		    					lat : step.start_location.lat(),
		    					lng : step.start_location.lng()
		    				}
		    			});
		    		});
		    	});
		    	localforage.setItem("tripLocations",tripPoints)
		    		.then(()=>{
		    			simularMovimiento();
		    		});
		    } else {
		    	console.log("Something fail on request directions");
		    }
	  });
}

function simularMovimiento() {
	console.log("Se inicia simulacion");
	localforage.getItem("tripLocations").then(tripPoints=>{
		let index = 0;
		let refreshIntervalId = setInterval(()=>{
			tripPoints[index];
			let myUnidadLocation = {
					route_id: 'A034',
					route_name: 'Ruta_34',
					route_color: 'FCE444',
					lat: tripPoints[index].locations.lat,
					lng: tripPoints[index].locations.lng
			};
			
			const unidadesLocations = {
					"Trip_X" : myUnidadLocation
			};
			firebaseDB.ref('gesatepedUnidad').set(unidadesLocations);
			index++;
			if(index == tripPoints.length) {
				clearInterval(refreshIntervalId);
			}
		},2000);
	});
}



