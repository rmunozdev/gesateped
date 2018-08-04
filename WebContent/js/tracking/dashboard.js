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
	
	$("#rutaCompleta").click(function(){
		verRutaCompleta();
	});
}

function onBodegaChange() {
	$("#codigoHojaRutaField").val("");
	actualizarUnidadesPorBodega();
}

function actualizarUnidadesPorBodega(){
	stopAutoRefresh();
	$.ajaxSetup({
		cache : false
	});
	var form  = $('#frmBodega');
	if(!$("#codigoHojaRutaField").val()) {
		hideAllDetails();
	}
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
				mostrarGraficaTotal(data);
				startAutoRefresh();
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
						mostrarGraficaUnitaria(data);
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

var colores = {
    pendientes : '#b7afab',
    atendidos : '#9ccedc',
    noAtendidos : '#dc6f33',
    reprogramados : '#e4c583',
    cancelados : '#005dff'
};

function mostrarGraficaUnitaria(estadoPedidos) {
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
	                colores.pendientes,
	                colores.atendidos,
	                colores.noAtendidos,
	                colores.reprogramados,
	                colores.cancelados,
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
	    	tooltips: {
                mode: 'label',
                callbacks: {
                    label: function(tooltipItem, data) {
                        return data['datasets'][0]['data'][tooltipItem['index']] + '%';
                    }
                }
            },
	    	legend: {
	    		position: "left"
	    	}
	    }
	});
}

function mostrarGraficaTotal(estadoPedidos) {
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
		                colores.pendientes,
		                colores.atendidos,
		                colores.noAtendidos,
		                colores.reprogramados,
		                colores.cancelados,
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
	    	tooltips: {
                mode: 'label',
                callbacks: {
                    label: function(tooltipItem, data) {
                        return data['datasets'][0]['data'][tooltipItem['index']] + '%';
                    }
                }
            },
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

function detectarCambios() {
	//Conteo de resultados
	var status = {
		codigoBodega: $( "#codigo" ).val()
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
				actualizarUnidadesPorBodega();
				if($("#accordion").is(":visible")) {
					verDashBoardUnidad($("#codigoHojaRutaField").val());
				}
			} else {
				console.log("Fail");
			}
		}
	});
}

function startAutoRefresh() {
	reloadTask = setInterval(() => {
		detectarCambios();
	}, 10*1000);
}

function stopAutoRefresh() {
	if(reloadTask) {
		clearInterval(reloadTask);
	}
}



function verRutaCompleta() {
	$.ajax({
		url: _globalContextPath+'/sim/paradas',
		type: 'POST',
		data: {codigoRuta: $("#codigoHojaRutaField").val()},
		Accept: "application/json", 
		success: function(paradas) {
			const map = new google.maps.Map(document.getElementById('pedidoMap'), {
				zoom: 16,
				disableDefaultUI: false,
				disableDoubleClickZoom: true,
				zoomControl: true,
				styles: [
			          {
			            featureType: "transit.station.bus",
			            stylers: [
			              { visibility: "off" }
			            ]
			          },
			          {
			        	  featureType: "poi.business",
			        	  stylers: [
			        		  { visibility: "off" }
			        		  ]
			          }
			    ]
			});
			
			var directionsDisplay = new google.maps.DirectionsRenderer({
				preserveViewport : false,
				suppressMarkers : true,
				polylineOptions: {
					strokeColor: "blue",
					strokeWeight : 3,
					strokeOpacity: 0.6
				}
			});
			
			let waypointsDetail = [];
			paradas.forEach((parada,index)=>{
				if(index!=0) {
					waypointsDetail.push({location: parada.direccion,codigo: parada.codigoPedido});
				}
			});
			
			//Los waypoitns deben ordenarse por codigo de pedido
			waypointsDetail.sort((waypointA,waypointB)=>{
				return waypointA.codigo > waypointB.codigo;
			});
			
			let waypoints = [];
			waypointsDetail.forEach((waypoint,index)=>{
				waypoints.push({location: waypoint.location});
			});
			
			let geocoder = new google.maps.Geocoder();
			geocoder.geocode({address:paradas[0].direccion},(results,status)=>{
				var marker = new google.maps.Marker({
		  			  position: {
		  				  lat: results[0].geometry.location.lat(),
		  				  lng: results[0].geometry.location.lng()
		  			  },
		  			  map: map,
		  			  title: `${paradas[0].codigoPedido}\n${paradas[0].direccion}`,
		  			  optimized: false,
		  			  label: {
		  				  color: 'black',
		  				  fontWeight: 'normal',
		  				  text: paradas[0].codigoPedido
		  			  },
		  			  icon: {
		  				  labelOrigin: new google.maps.Point(11, 50),
		  				  url: _globalContextPath+'/images/dashboard/map-markers/location-inicio.png',
		  				  size: new google.maps.Size(32, 40),
		  				  origin: new google.maps.Point(0, 0),
		  				  anchor: new google.maps.Point(11, 40)
		  			  }
		  		  });
			});
			
			//Panel
		    var stepDisplay = new google.maps.InfoWindow({
		    	disableAutoPan: true
		    });
			var directionsService = new google.maps.DirectionsService();
			  var request = {
					    origin: paradas[0].direccion + " Peru",
					    destination: paradas[0].direccion + " Peru",
					    waypoints: waypoints,
					    optimizeWaypoints: true,
					    travelMode: 'DRIVING'
				};
			  
			  
				
			  directionsDisplay.setMap(map);
			  directionsService.route(request, function(result, status) {
				    if (status == 'OK') {
				      directionsDisplay.setDirections(result);
				      
				      const ruta = result.routes[0];
				      const waypointsOrdenados = ruta.waypoint_order;
				      const pasos = ruta.legs;
				      pasos.forEach((paso,index)=>{
				    	  if(index<(pasos.length-1)) {
				    		  let address = paso.end_address;
				    		  let location = paso.end_location;
				    		  let nextdistance = paso.distance.text;
				    		  let waypointPedidoCode = waypointsDetail[waypointsOrdenados[index]].codigo;
				    		  console.log("waypoint params",index,waypointsOrdenados[index],waypointPedidoCode);
				    		  var locationMarker = new google.maps.Marker({
				    			  position: location,
				    			  map: map,
				    			  title: `${waypointPedidoCode}\n${address} ${nextdistance}`,
				    			  optimized: false,
				    			  label: {
				    				  color: 'red',
				    				  fontWeight: 'normal',
				    				  text: waypointPedidoCode
				    			  },
				    			  icon: {
				    				  labelOrigin: new google.maps.Point(11, 50),
				    				  url: _globalContextPath+'/images/dashboard/map-markers/location-' +  (index+1) +'.png',
				    				  size: new google.maps.Size(32, 40),
				    				  origin: new google.maps.Point(0, 0),
				    				  anchor: new google.maps.Point(11, 40)
				    			  }
				    		  });
				    		  //attachInstructionText(stepDisplay,locationMarker,`${waypointPedidoCode}<br>${address}<br>Distancia desde parada previa: ${nextdistance}`);
				    		  
				    	  }
				    	  attachDistanceLabel(paso,map);
				      });
				      
				      
				      $('div#pedidoMap').dialog({
							title: "Ruta completa",
							width: $(window).width(),
					        height: $(window).height(),
					        modal: true
					    });
				    }
			  });
			  
			  
			  google.maps.event.addListener(map, 'zoom_changed', function(e) {
	        	  if(map.zoom >= 12) {
	        		  overlays.forEach(function(overlay,index){
	        			  overlay.setMap(map);
	        		  });
	        	  }
	        	  else {
	        		  overlays.forEach(function(overlay,index){
	        			  overlay.setMap(null);
	        		  });
	        	  }
	        });
			  
		}
	});
}

function attachInstructionText(stepDisplay, marker, text, map) {
	google.maps.event.addListener(marker, 'click', function() {
        // Open an info window when the marker is clicked on, containing the text
        // of the step.
        stepDisplay.setContent(text);
        stepDisplay.open(map, marker);
   });
}

/*
 * Distance text label instructions
 */
USGSOverlay.prototype = new google.maps.OverlayView();
var overlays = [];
function attachDistanceLabel(leg,map) {
	overlays.push(new USGSOverlay(
			  leg,
			  map));
}


function USGSOverlay(leg, map) {
    // Initialize all properties.
    this.leg = leg;
    this.text = leg.distance.text;
    this.map_ = map;

    // Define a property to hold the image's div. We'll
    // actually create this div upon receipt of the onAdd()
    // method so we'll leave it null for now.
    this.div_ = null;

    // Explicitly call setMap on this overlay.
    this.setMap(map);
}

USGSOverlay.prototype.onAdd = function() {
    var div = document.createElement('div');
    div.style.borderStyle = 'none';
    div.style.borderWidth = '0px';
    div.style.position = 'absolute';
    div.className = 'km-label-container';
    
    var myMsg = document.createElement('p');
    div.className = 'km-label';
    myMsg.innerHTML = `${this.text}<br>${this.leg.duration.text}`;
    
    div.appendChild(myMsg);

    this.div_ = div;

    // Add the element to the "overlayLayer" pane.
    var panes = this.getPanes();
    panes.overlayLayer.appendChild(div);
  };
  
  USGSOverlay.prototype.draw = function() {

      var overlayProjection = this.getProjection();

      var points = [];
      var legDistance = this.leg.distance.value;
      var targetDistance = parseInt(legDistance/2);
      
      var acumulated = 0;
      var targetPoint;
      this.leg.steps.forEach(function(step,index){
    	  if(targetPoint) {
    		  return;
    	  }
    	acumulated += step.distance.value;
    	if(acumulated >= targetDistance) {
    		var stepPoints = polyline.decode(step.polyline.points);
    		targetPoint = stepPoints[parseInt(stepPoints.length/2)];
    		
    	}
      });
      
      if(targetPoint) {
      	var position = overlayProjection.fromLatLngToDivPixel(
              	new google.maps.LatLng(
              			targetPoint[0],
              			targetPoint[1]
              	)
              );

              // Resize the image's div to fit the indicated dimensions.
              var div = this.div_;
              div.style.left = position.x + 'px';
              div.style.top = position.y + 'px';
              div.style.width = '35px';
      	
      	
      } else {
      	window.alert("Fail by no targetPoint adquired");
      }
    };
    
 // The onRemove() method will be called automatically from the API if
    // we ever set the overlay's map property to 'null'.
    USGSOverlay.prototype.onRemove = function() {
      this.div_.parentNode.removeChild(this.div_);
      this.div_ = null;
    };