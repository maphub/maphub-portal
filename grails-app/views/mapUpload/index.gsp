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

  	<g:form class="genericForm">
  	    <h3>Step 1 - Upload</h3>
				You can either
				<p>
					<label for="tilesetUrl">provide a tileset URL:</label>
					<g:textField name="tilesetUrl"/>&nbsp;&nbsp;or <br/>
					<label for="imgupload">upload an image of the map</label>		
					<input type="file" name="imgupload" disabled/>
			</p>


      <h3>Step 2 - Provide some more information</h3>
      Now for some details:
      
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
				<label for="isPublic">This map is available to all users</label>
				<g:checkBox name="isPublic" checked="true"/>
			</p>
<p></p>
			<p>
				<g:actionSubmit value="Upload"/>
			</p>
		</g:form>    
	</body>
</html>
