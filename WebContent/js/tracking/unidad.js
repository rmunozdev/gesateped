function initTracking(map,destino) {
	iniciarUnidadEnFirebase().then(()=>{
		var directionsDisplay = new google.maps.DirectionsRenderer({
			preserveViewport : false,
			suppressMarkers : true
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
						  text: unidad.placa
					  });
					  document.getElementById('distanceLbl').innerHTML = unidad.timeleft;
					  document.getElementById('timeLbl').innerHTML = unidad.distanceleft;
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
							  text: unidad.placa
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
					  document.getElementById('distanceLbl').innerHTML = unidad.timeleft;
					  document.getElementById('timeLbl').innerHTML = unidad.distanceleft;
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
					  
					//Se establece panel:
					document.getElementById('endLbl').innerHTML = destino;
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
						obtenerDetallesRuta(origen,destino).then((route)=>{
							
							let distanciaPendiente = 0;
					    	let demoraPendiente = 0;
					    	route.legs.forEach(leg=>{
					    		distanciaPendiente += leg.distance.value;
					    		demoraPendiente += leg.duration.value;
					    	});
							
							firebaseDB
							.ref('gesatepedUnidad')
							.set({
								"viaje" : {
									placa: pedido.unidadAsignada.numeroPlaca,
									timeleft: formatTime(demoraPendiente),
									distanceleft: formatDistance(distanciaPendiente),
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
	});
	return finishPromise;
}

function obtenerPuntoDePartida(pedido) {
	return new Promise((resolve,reject)=>{
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
						document.getElementById('initLbl').innerHTML = partida.direccion;
					}
				});
			}
		});
	});
}

function obtenerDetallesRuta(origen,destino) {
	return new Promise((resolve,reject)=>{
		var directionsService = new google.maps.DirectionsService();
		 var request = {
			origin: new google.maps.LatLng(origen.lat,origen.lng),
			destination: destino.destino,
			travelMode: 'DRIVING'
		 };
		 
		 directionsService.route(request, function(result, status){
			 if (status == 'OK') {
				 const route = result.routes[0];
				 resolve(route);
			 } else {
				 reject("Fallo consulta a directions.",origen,destino);
			 }
		 });
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


function formatTime(seconds) {
    var sec_num = seconds; // don't forget the second param
    var hours   = Math.floor(sec_num / 3600);
    var minutes = Math.floor((sec_num - (hours * 3600)) / 60);
    var seconds = sec_num - (hours * 3600) - (minutes * 60);

    if (hours   < 10) {hours   = "0"+hours;}
    if (minutes < 10) {minutes = "0"+minutes;}
    if (seconds < 10) {seconds = "0"+seconds;}
    return hours+':'+minutes+':'+seconds;
}

function formatDistance(meters) {
	if(meters<100) {
		return meters + " m";
	} else {
		var kilometros = meters/1000;
		return kilometros + "km"
	}
}