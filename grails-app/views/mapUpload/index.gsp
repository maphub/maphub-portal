<html>
	<head>
		<title>Upload Map</title>
		<meta name="layout" content="main" />
	</head>
	<body>
		<h1>MapHub Map Upload</h1>
		Here you can upload and share your maps.
  
  	<g:form>
			<div>
				<label for="tilesetUrl">Tileset URL:</label>
				<g:textField name="tilesetUrl"/>
			</div>

			<div>
				<label for="name">Map Name:</label>
				<g:textField name="name"/>
			</div>

			<div>
				<label for="description">Map Description:</label>
				<g:textArea name="description" rows="5" cols="60"/>
			</div>

			<div>
				<label for="mapDate">Map Date:</label>
				<g:datePicker name="mapDate" precision="year" noSelection="['':'']" default="none" years="${1700..2050}"/>
			</div>

			<div>
				<g:actionSubmit value="Upload"/>
			</div>
		</g:form>    
	</body>
</html>
