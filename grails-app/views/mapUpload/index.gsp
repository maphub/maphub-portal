<html>
	<head>
		<title>Upload Map</title>
		<meta name="layout" content="main" />
	</head>
	<body>
		<h1>Map Upload</h1>
		<p>Here you can upload and share your maps.</p>
  
  	<g:form class="genericForm">
      <p>
      	<label for="tilesetUrl">Tileset URL:</label>
      	<g:textField name="tilesetUrl"/>
      </p>
      <p>
      	<label for="name">Map Name:</label>
      	<g:textField name="name"/>
      </p>
      <p>
      	<label for="description">Map Description:</label>
      	<g:textArea name="description" rows="5" cols="60"/>
      </p>
      <p>
      	<label for="mapDate">Map Date:</label>
      	<g:datePicker name="mapDate" precision="year" noSelection="['':'']" default="none" years="${1700..2050}"/>
      </p>
      <p>
      	<g:actionSubmit value="Upload"/>
      </p>		
    </g:form>    
	</body>
</html>
