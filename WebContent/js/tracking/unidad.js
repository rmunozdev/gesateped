/**
 * 
 */
function initTracking(map,destino) {
	var directionsDisplay = new google.maps.DirectionsRenderer({
		preserveViewport : true
	});
	  
	  firebaseDB.ref('gesatepedMap').on('value',snapshot=>{
		  const value = snapshot.val();
		  //Contorno de mapa segun la posicion de la unidad
	  });
	  
	  const unidadLocationMarkers = {};
	  firebaseDB.ref('gesatepedUnidad').on('value',snapshot=>{
		  const value = snapshot.val();
		  console.log("Value found",value);
		  
		  //Limpieza de localizaciones
		  for(let key in unidadLocationMarkers) {
			  if(value === null || !(key in value)) {
				  console.log("Se elimina marcador");
				  const marker = unidadLocationMarkers[key];
				  marker.setMap(null);
				  delete unidadLocationMarkers[key];
			  }
		  }
		  
		  //Actualizacion de localizaciones por cada unidad
		  for(let key in value) {
			  const unidad = value[key];
			  
			  if(key in unidadLocationMarkers) {
				  //Si ya estaba, solo actualizacion del marcador
				  console.log("Se actualiza marcador");
				  const marker = unidadLocationMarkers[key];
				  marker.setPosition({
					  lat: unidad.lat,
					  lng: unidad.lng
				  })
			  } else {
				  //Si no estaba, se crea nuevo marcador
				  console.log("Se crea nuevo marcador");
				  const url = _globalContextPath + colorToUnidadMarker(unidad.route_color);
				  const marker = new google.maps.Marker({
					  position: {
						  lat: unidad.lat,
						  lng: unidad.lng
					  },
					  map: map,
					  icon: {
						  url,
						  anchor: new google.maps.Point(30,30)
					  },
					  title: unidad.route_name,
					  optimized: false
				  });
				  
				  unidadLocationMarkers[key] = marker;
			  }
			  
			//Se pinta ruta hacia
			  
			  var directionsService = new google.maps.DirectionsService();
			  var request = {
					    origin: new google.maps.LatLng(unidad.lat,unidad.lng),
					    destination: destino,
					    travelMode: 'DRIVING'
				};
				
			  directionsDisplay.setMap(map);
			  directionsService.route(request, function(result, status) {
				    if (status == 'OK') {
				      directionsDisplay.setDirections(result);
				    }
			  });
		  }
		  
		  
	  });
}


function colorToUnidadMarker(color) {
	  switch (color) {
	    case 'FCE444':
	      return '/images/dashboard/busmarker_yellow.png';
	    case 'C4E86B':
	      return '/images/dashboard/busmarker_lime.png';
	    case '00C1DE':
	      return '/images/dashboard/busmarker_teal.png';
	    case 'FFAD00':
	      return '/images/dashboard/busmarker_orange.png';
	    case '0061C8':
	      return '/images/dashboard/busmarker_indigo.png';
	    case '8A8A8D':
	      return '/images/dashboard/busmarker_caltrain.png';
	    case 'EA1D76':
	      return '/images/dashboard/busmarker_sf.png';
	    default:
	      console.log(`colorToBusMarker(${color}) not handled`);
	      return '';
	  }
	}