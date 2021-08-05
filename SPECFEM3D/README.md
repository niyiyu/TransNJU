# Mesh Configuration

In `/Mesh_par`, two different sets of model configuration is provided.
```
													|						Fine Model								|						Rough Model		  					|
													|	 Depth			Layer			Mesh size			|  Depth			Layer			Mesh Size			|
=======================================================================================================
	Topography							| surface															|	surface															|
												  | 		 			 	24 	4.16x4.16x(2.9-6.3)	|							20			6.25x6.25x(5-8)	|
	Doubling/Interface 1 		|	 -50m 															|	 -80m																|
													|							11			 8.3x8.3x8.2		|							7				12.5x12.5x12.9	|
	Doubling/Interface 2		|	 -140m  														|	 -170m															|
													|							10			16.7x16.7x16.0	|							7				25.0x25.0x22.9	|
	Doubling/Interface 3 		|	 -300m															|	 -330m															|
													|							14			33.3x33.3x35.7	|							10			50.0x50.0x47.0	|
	Bottom/Interface 4 			|	 -800m															|  -800m															|
	
	Binary Model/Mesh Size	|								  										|							9.2G  x4								|
	Max Meshfem Mem					|							4.7G x4									|					    1.8G  x4								|
	Max Gendatabases Mem		|							32G	 x4									|							20.7G x4								|
```

