/**
 * 
 */
(()=>{
	window.addEventListener("load",()=>{
		setTimer();
		$(".top-msg-close").click(function(event){
			closeAlertZone();
		});
	});
})();

function getAlert() {
	$.ajax({
		url: 'monitoreo/alerta',
		type: 'get',
		Accept: 'application/json',
		success: function(data) {
			console.log("Success",data);
			console.log("Alert generate at: " + new Date());
			var mensaje = "";
			data.forEach((msg,index)=>{
				mensaje += "<p>" + msg + "</p>";
			});
			$(".top-msg-inner").html(mensaje);
		}
	})
}


function setTimer() {
	//Request times for timer
	$.ajax({
		url: 'monitoreo/tiemposAlerta',
		type: 'get',
		Accept: 'application/json',
		success: function(data) {
			console.log("Success",data);
			data.forEach((time,index)=>{
				console.log("Date " + index, new Date(time));
				var lapsoRestante = new Date(time).getTime() - new Date().getTime();
				console.log("lapso in miliseconds",lapsoRestante);
				
				if(lapsoRestante > 0) {
					setTimeout(() => {
						getAlert();
						$("#alertZone").show();
						highLightData();
					}, lapsoRestante);
				}
				
			});
			console.log("Timers ready");
		}
	});
}

function highLightData() {
	if($('#tblPedidosPendientes').is(":visible")) {
		$('#tblPedidosPendientes')
			.DataTable()
			.rows()
			.every(function(){ 
				console.log(this.data());
				var timeString = this.data().horaInicioVentana + ':00';
				var inicioVentana = moment(timeString, 'HH:mm:ss')
				if(inicioVentana < new Date()) {
					console.log(this.data().codigoPedido + " esta en alerta");
					$(this.node()).addClass("highlight")
				}
			})
	}
}

function closeAlertZone() {
	$("#alertZone").hide();
}