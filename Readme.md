# Main Project for Almond Volume Sensing
Main project for Almond Volume Sensing using LD05 and Raspberry Pi.<p>

## Software Development
Tasks to perform<br />
>  Project Initialization	Requirements Gathering		<br />
> 	Initial Meeting with Client		<br />
> 	Project Plan Development		<br />
> 	Team Assignment		<br />
>  Hardware Setup	Procurement of LIDAR Sensor and Raspberry Pi 5 Compute Unit		<br />
> 	Hardware Configuration		<br />
> 	Testing Hardware Components		<br />
> Software Development	LIDAR Data Acquisition		Research and Select LIDAR Library<br />
> 			Implement LIDAR Data Acquisition<br />
> 			Test LIDAR Data Acquisition<br />
> 	Data Storage		Design Data Storage Structure<br />
> 			Implement Data Storage Solution<br />
> 			Test Data Storage Solution<br />
> 	Data Processing		Develop Algorithms for Data Processing<br />
> 			Implement Heatmap Generation<br />
> 			Test Data Processing and Heatmap Generation<br />
> 	Data Output to John Deere Display		Research ISO 11783 Standard and Libraries<br />
> 			Implement Data Output in ISO 11783 Format<br />
> 			Test Data Output to John Deere Display<br />
> Integration and Testing	System Integration		<br />
> 	End-to-End Testing		<br />
> 	User Acceptance Testing (UAT)		<br />
> Documentation	Code Documentation		<br />
> 	User Manual		<br />
> 	Technical Documentation		<br />
> Deployment and Support	Deployment Plan		<br />
> 	System Deployment		<br />
> 	Post-Deployment Support		<br />
> Project Management	Regular Status Meetings		<br />
> 	Progress Reporting		<br />
> 	Risk Management		<br />
 
## Notes to add:<br />
OTS hardware allowing for other hardware to be used.<br />


#### Links to resources:
Simon mentioned this library: https://pyimagesearch.com/2016/03/28/measuring-size-of-objects-in-an-image-with-opencv/<br />

##### Previous email sent to Michael:
> I’ve just spoken with our clients John Deere dealer and they’ve advised that the output will be a standard ISO bus (ISO 11783) output.
> There should be plenty of resources online, the spec is here (costs money and likely not required, but let me know if it is required): https://www.iso.org/standard/57556.html
> There seems to be some Python and C++ libraries, like here: https://github.com/Open-Agriculture/AgIsoStack-plus-plus
> https://github.com/GwnDaan/python-isobus-library?tab=readme-ov-file and possibly https://github.com/jboomer/python-isobus
>  
> All the client wants to do is output the results from the lidar in a “Waterfall/Heatmap” format on the terminal in the cab. (John Deere then take that output and upload that to the cloud as well).
>  
> The heatmap is a representation of the volume of almonds the lidar picks up when they fall from the conveyor belt to the hopper.

</p>
