# Main Project for Almond Volume Sensing
Main project for Almond Volume Sensing using LD05 and Raspberry Pi.<p>

## Software Development
Tasks to perform
>  Project Initialization	Requirements Gathering		
> 	Initial Meeting with Client		
> 	Project Plan Development		
> 	Team Assignment		
>  Hardware Setup	Procurement of LIDAR Sensor and Raspberry Pi 5 Compute Unit		
> 	Hardware Configuration		
> 	Testing Hardware Components		
> Software Development	LIDAR Data Acquisition		Research and Select LIDAR Library
> 			Implement LIDAR Data Acquisition
> 			Test LIDAR Data Acquisition
> 	Data Storage		Design Data Storage Structure
> 			Implement Data Storage Solution
> 			Test Data Storage Solution
> 	Data Processing		Develop Algorithms for Data Processing
> 			Implement Heatmap Generation
> 			Test Data Processing and Heatmap Generation
> 	Data Output to John Deere Display		Research ISO 11783 Standard and Libraries
> 			Implement Data Output in ISO 11783 Format
> 			Test Data Output to John Deere Display
> Integration and Testing	System Integration		
> 	End-to-End Testing		
> 	User Acceptance Testing (UAT)		
> Documentation	Code Documentation		
> 	User Manual		
> 	Technical Documentation		
> Deployment and Support	Deployment Plan		
> 	System Deployment		
> 	Post-Deployment Support		
> Project Management	Regular Status Meetings		
> 	Progress Reporting		
> 	Risk Management		
 
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
