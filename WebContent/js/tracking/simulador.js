/**
 * 
 */
function iniciarSimulacion() {
	let geocoder = new google.maps.Geocoder();
	//Avenida Angamos Oeste 371, Miraflores Peru
	geocoder.geocode({address: "Avenida Angamos Oeste 371, Miraflores Peru"}, (results, status) => {
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
	 firebaseDB.ref('gesatepedUnidad').on('value',snapshot=>{
		 const value = snapshot.val();
		 localforage.getItem("destinoSeleccionado").then(destino=>{
			 for(let key in value) {
				 const unidad = value[key];
				 var directionsService = new google.maps.DirectionsService();
				 var request = {
					origin: new google.maps.LatLng(unidad.lat,unidad.lng),
					destination: destino,
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
					    	localforage.setItem("tripLocations",tripPoints);
					    } else {
					    	console.log("Something fail on request directions");
					    }
				  });
			 }
		 });
	 });
}

function simularMovimiento() {
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



