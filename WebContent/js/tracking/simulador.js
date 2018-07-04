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
	
}