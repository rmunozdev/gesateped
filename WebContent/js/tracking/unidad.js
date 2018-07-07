function initTracking(map,destino) {
	iniciarUnidadEnFirebase().then(()=>{
		var directionsDisplay = new google.maps.DirectionsRenderer({
			preserveViewport : true
		});
		  
		  firebaseDB.ref('gesatepedMap').on('value',snapshot=>{
			  const value = snapshot.val();
			  //Contorno de mapa segun la posicion de la unidad
		  });
		  
		  const unidadLocationMarkers = {};
		  let pintarRuta = 0;
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
					  });
					  marker.setLabel({
						  color: 'blue',
						  fontWeight: 'bold',
						  text: unidad.placa + 
								  " Tiempo:" + 
								  unidad.timeleft + 
								  " Distancia:" + 
								  unidad.distanceleft
					  });
				  } else {
					  //Si no estaba, se crea nuevo marcador
					  console.log("Se crea nuevo marcador");
					  const url = _globalContextPath + colorToUnidadMarker('FCE444');
					  const marker = new google.maps.Marker({
						  position: {
							  lat: unidad.lat,
							  lng: unidad.lng
						  },
						  map: map,
						  label: {
							  color: 'blue',
							  fontWeight: 'bold',
							  text: unidad.placa + 
									  " Tiempo:" + 
									  unidad.timeleft + 
									  " Distancia:" + 
									  unidad.distanceleft
						  },
						  icon: {
							  labelOrigin: new google.maps.Point(11, 50),
							  url: url,
							  anchor: new google.maps.Point(30,30)
						  },
						  title: unidad.placa,
						  optimized: false
					  });
					  
					  unidadLocationMarkers[key] = marker;
				  }
				  
				//Se pinta ruta una sola vez
				  if(pintarRuta == 0) {
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
				  pintarRuta++;
			  }
		  });
	});
}

function iniciarUnidadEnFirebase() {
	console.log("Se establece posicion de unidad");
	let finishPromise = new Promise((resolve,reject)=>{
		localforage.getItem("destinoSeleccionado").then(destino=>{
			 localforage.getItem("unidadSeleccionada").then((unidadSeleccionada)=>{
					console.log(unidadSeleccionada);
					//Se obtiene posicion inicial
					let pedido = {
							codigoPedido: destino.pedido,
							codigoHojaRuta: unidadSeleccionada.codigoHojaRuta,
							unidadAsignada: {
								numeroPlaca: unidadSeleccionada.unidad.placa
							}
					};
					
					obtenerPuntoDePartida(pedido).then((origen)=>{
						firebaseDB
							.ref('gesatepedUnidad')
							.set({
								"viaje" : {
									placa: pedido.unidadAsignada.numeroPlaca,
									timeleft: 0,
									distanceleft: 0,
									lat: origen.lat, 
									lng: origen.lng	
								}
							}).then(()=>{
								resolve();
						});
					});
			});
		 });
	});
	return finishPromise;
}

function obtenerPuntoDePartida(pedido) {
	let finishPromise = new Promise((resolve,reject)=>{
		$.ajax({
			url: _globalContextPath+'/sim/partidas',
			type: 'POST',
			data: {codigoRuta: pedido.codigoHojaRuta},
			Accept: "application/json", 
			success: function(partidas) {
				partidas.forEach((partida,index)=>{
					if(partida.codigoPedido == pedido.codigoPedido) {
						console.log("Partida elegida: ",partida);
						console.log("Unidad seleccionada:",pedido.unidadAsignada.numeroPlaca);
						//Posicion original
						let geocoder = new google.maps.Geocoder();
						geocoder.geocode({
							address:partida.direccion},
							(results,status)=>{
								let origen = {
										lat: results[0].geometry.location.lat(),
										lng: results[0].geometry.location.lng()
								};
								resolve(origen);
						});
					}
				});
			}
		});
	});
	return finishPromise;
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