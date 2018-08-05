<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<!doctype html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title><tiles:getAsString name="title" /></title>
	<link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/images/favicon.ico">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
	
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" 
		integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" 
		crossorigin="anonymous">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" 
		integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" 
		crossorigin="anonymous">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.12.4/css/bootstrap-select.min.css">
	<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	 <style type="text/css">
      body {
        padding-top: 5px;
        padding-bottom: 40px;
      }
      
      /* Cabecera */
      .cabecera {
      	padding-bottom: 5px;
      	border-bottom: solid 3px #667777!important;
      }

      /* Custom container */
      .container-narrow {
        margin: 0 auto;
        max-width: 800px;
      }
      .container-narrow > hr {
        margin: 30px 0;
      }

      /* Main marketing message and sign up button */
      .jumbotron {
        margin: 10px 0 20px 0 ;
        text-align: center;
      }
      .jumbotron h1 {
        font-size: 72px;
        line-height: 1;
      }
      .jumbotron .btn {
        font-size: 21px;
        padding: 14px 24px;
      }
      
      

      /* Supporting marketing content */
      .marketing {
        margin: 20px 0 20px 0;
      }
      .marketing p + h4 {
        margin-top: 28px;
      }
      
      a {
      	cursor: pointer;
      }
    </style>
<!-- 	<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/v/bs/dt-1.10.18/datatables.min.css"/> -->
	<link rel="stylesheet" href="${pageContext.request.contextPath}/bootstrap/css/bootstrap-responsive.css">
	<script
		  src="https://code.jquery.com/jquery-3.3.1.min.js"
		  integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
		  crossorigin="anonymous"></script>
	<script type="text/javascript" src="https://cdn.datatables.net/v/bs/dt-1.10.18/datatables.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" 
		integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" 
		crossorigin="anonymous"></script>
	<!-- Info https://silviomoreto.github.io/bootstrap-select -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.12.4/js/bootstrap-select.min.js"></script>
	<script
  		src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"
  		integrity="sha256-VazP97ZCwtekAsvgPBSUwPFKdrwD3unUfSGVYrahUqU="
  		crossorigin="anonymous"></script>
  	<style>
    	tr:nth-child(even) {
    		background-color: #f2f2f2
		}
		
		.texto-central {
			text-align: center;
		}
		.footer {
		  position: fixed;
		  bottom: 0;
		  width: 100%;
		  height: 40px; /* Set the fixed height of the footer here */
		  line-height: 40px; /* Vertically center the text there */
		  background-color: #f5f5f5;
		}
		
		.ui-dialog-titlebar {
		  background-color: #FFFFFF;
		  background-image: none;
		  color: #000;
		}
		
    </style>
    
    
    <script>
    	const _globalContextPath = "${pageContext.request.contextPath}";
    	
    	//Jquery Dialog Soporte html en titulo
    	$.widget("ui.dialog", $.extend({}, $.ui.dialog.prototype, {
    	    _title: function(title) {
    	        if (!this.options.title ) {
    	            title.html("&#160;");
    	        } else {
    	            title.html(this.options.title);
    	        }
    	    }
    	}));
    </script>
</head>
<body>
	<div class="container-narrow">
      <tiles:insertAttribute name="header" />
      <tiles:insertAttribute name="body" />
    </div>
    <footer class="footer">
      <div class="container texto-central">
        <span class="text-muted center-footer">&copy; Lima-Perú 2018</span>
      </div>
    </footer>
</body>
</html>