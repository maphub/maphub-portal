<html>
	<head>
		<title>Upload Map</title>
		<meta name="layout" content="main" />
	</head>
	<body>
		<h1>Map Upload</h1>
		<p>Here you can upload and share your maps.</p>
  
		<g:hasErrors>
			<div class="errors">
				<g:renderErrors bean="${map}" as="list" />
			</div>
		</g:hasErrors>

  	<g:form>
			<div>
				You can either:
				<div>
					<label for="tilesetUrl">provide a tileset URL:</label>
					<g:textField name="tilesetUrl"/>
				</div>
				or 
				<div>
					<label for="imgupload">upload an image of the map</label>		
					<input type="file" name="imgupload" disabled/>
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
				<label for="isPublic">This map is available to all users</label>
				<g:checkBox name="isPublic" checked="true"/>
			</div>

			<div>
				<g:actionSubmit value="Upload"/>
			</div>
		</g:form>    
	</body>
</html>
