///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////// AURA: Automated Universal RNAscope® Analysis for high-throughput applications //////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////// AUTHORSHIP ////////////////////
// Jean DESCARPENTRIE; Department of Molecular Biology, Umeå University, 90187 Umeå, Sweden
// Florian BERNARD; University of Bordeaux, INSERM, U1212, Nucleic Acids: Natural and Artificial Regulations Laboratory, 33000 Bordeaux, France
// Wilfried SOULEYREAU; University of Bordeaux, INSERM, U1312 BRIC, Tumor and Vascular Biology Laboratory, 33600 Pessac, France
// Ioannis S. PATERAS; Molecular Carcinogenesis Group, Department of Histology and Embryology, School of Medicine, National and Kapodistrian University of Athens, 11527 Athens, Greece
// Océane C. B. MARTIN: University of Bordeaux, CNRS, IBGC, UMR 5095, 33000 Bordeaux, France
// Teresa FRISAN; Department of Molecular Biology, Umeå University, 90187 Umeå, Sweden

// Technical contact: wilfried.souleyreau@u-bordeaux.fr 
// Lead contact: jean.descapentrie@umu.se 
// Web-app link: https://aura-data-processing.streamlit.app/ 


///////////////////////////////////////////////////////////////////////////////////
///////////////////// AURA main Functions /////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////

///////////////////// Nucleus Segmentation Function/////////////////////////////////////
function ApplyNucleiSegmentation() {
run("Duplicate...", "title=nuclei_QC");//For Quality control 
selectImage(NucleusChannel);
////// function can be adjusted from the line below /////
run("Enhance Contrast", "saturated=0.35");
run("Apply LUT");
run("Mean...", "radius=2");
run("Gaussian Blur...", "sigma=2");
setAutoThreshold("Otsu dark");
run("Convert to Mask");
run("Open");
run("Watershed");
//// End of function adjustment : from here you should have nuclei segmented binary image
}
/////////////////////////////////////////////////////////////////////////////////


///////////////////// Dot Segmentation Function //////////////////////////////////////
function ApplyDotSegmentation() {
////// function can be adjusted from the line below /////
 run("Enhance Contrast", "saturated=0.4");
 run("Gaussian Blur...", "sigma=0.5");
 setAutoThreshold("Yen");
    run("Convert to Mask");
    run("Erode");
    run("Dilate");
    run("Invert");
    run("Watershed"); 
//// End of function adjustment : from here you should have dot segmented binary image

}
/////////////////////////////////////////////////////////////////////////////////////

///////////////////// Quality Control Function //////////////////////////////////////
function ApplyQualityControl() {
run("Grays");
run("RGB Color");
run("Restore Selection");
setForegroundColor(255, 255, 0);
run("Draw", "slice");
run("Color Picker...");
setForegroundColor(255, 0, 0);
roiManager("Select", 0);
run("Draw", "slice");
}
///////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////   	
///////////////////// User Input for Analysis Settings ////////////////////////////
///////////////////////////////////////////////////////////////////////////////////


///////////////////// Pre-start Cleanup /////////////////////////////////////////
run("Close All");
roiManager("reset");
/////////////////////////////////////////////////////////////////////////////////

///////////////////// AURA Button Action Tool  ///////////////////////////////// 
	macro "A Button Action Tool - N66C000D00D01D02D03D04D05D06D07D08D09D0aD0bD0cD0dD0eD10D11D12D13D14D15D16D17D18D19D1aD1bD1cD1dD1eD20D21D22D23D24D25D26D27D28D29D2aD2bD2cD30D31D32D33D34D35D36D37D3eD40D41D42D43D44D45D46D47D4bD50D51D52D53D54D55D56D57D60D61D62D63D64D65D66D67D68D70D71D72D73D74D75D76D77D80D81D82D83D84D85D86D87D90D91D92D93D94D95D96D97Da0Da1Da2Da3Da4Da5Da6Da7Db0Db1Db2Db3Db4Db5Db6Db7Dc0Dc1Dc2Dc3Dc4Dc5Dc6Dc7Dd0Dd1Dd2Dd3Dd4Dd5Dd6Dd7Dd8De0De1De2De3De4De5De6De7De8C000D98C000D4aD58C000D88Dc8C000D4cD78Db8C000D38D49C000D48C000Da8C000D2eC000D39D4dC000D3bC111D3aC111D3cC111D3dDa9C111C222D4eC222D8cC222D2dC222C333D79C333D59C333Db9Dc9C333D8bC333D8dC333D99C333Dd9C333D69C444De9C444D89C444DaaC444C555DadC555DabC555DacC555DecC555C666D5bC666DcaC666C777DceDebC777D8eDccDcdC777DaeDcbC777DeeC777C888D5aC888D8aC888D7aD7bC888C999D6cC999CaaaD5cCaaaD6eCaaaD5dD9eCaaaDbaCaaaD9cD9dCbbbD7cCbbbD5eCbbbDbcDbdCbbbDbbCbbbCcccDbeCcccDdeCcccD9bDdcCcccD6bD7eCcccDdbCcccDdaCdddD9aCdddDeaCdddD7dCdddD6aCdddD6dCdddCeeeDddCeeeDedBf0C000D00D01D02D03D04D05D06D07D10D11D12D13D14D15D16D17D20D21D22D23D24D25D26D27D30D31D32D33D34D35D36D37D40D41D42D43D44D45D46D47D50D51D52D53D54D55D56D57D60D61D62D63D64D65D66D67D6cD6dD6eD70D71D72D73D74D75D76D77D78D79D7aD80D81D82D83D84D85D86D87D88D89D8aD8bD8cD8dD8eD90D91D92D93D94D95D96D97D98D99D9aD9bD9cD9dD9eDa0Da1Da2Da3Da4Da5Da6Da7Da8Da9DaaDabDacDadDaeC000D38C000D08C000D48C000D19C000D5aD7bD7dC000D59D7cD7eC000D18D69C000D6aC000D28C000C111D68C111D58C111D1aC111D5bC111C222D29C222D1dC222D6bC222D09D49C222C333D1eC333D39C333C444D1bC444D1cC444D2bC444C555D2aC555D5eC555D5cC555D5dC555C666C777C888D2cC888C999D4aC999D3cC999D0eC999D4bC999CaaaD0aD2dCaaaD3eCaaaCbbbD0cCbbbD0dCbbbD4cCcccD0bCcccD2eD3bCcccD4eCcccCdddD3aCdddD3dCdddCeeeD4dB0fC000D03D04D05D06D07D08D09D0aD13D14D15D16D17D18D19D1aD23D24D25D26D27D28D29D2aD33D34D35D36D37D38D39D3aD43D44D45D46D47D48D49D4aD53D54D55D56D57D58D59D5aD63D64D65D66D67D68D69D6aD73D74D75D76D77D78D79D7aD80D81D82D83D84D85D86D87D88D89D8aD90D91D92D93D94D95D96D97D98D99D9aDa0Da1Da2Da3Da4Da5Da6Da7Da8Da9DaaC000D52C000D02D22D42C000D12C000D60D72C000D62C000D32C000C111D61C111D70C111D71C111D31C111C222D30C222C333D11C333C444D41C444D01D51C444D21C444C555D50C555C666D10C666C777C888D40C999D00C999CaaaD20CaaaCbbbCcccCdddCeeeNf0C000D00D01D02D03D04D05D06D07D08D09D0aD10D11D12D13D14D15D16D17D18D19D1aD23D24D25D26D27D28D29D2aD33D34D35D36D37D38D39D3aD43D44D45D46D47D48D49D4aD53D54D55D56D57D58D59D5aD63D64D65D66D67D68D69D6aD73D74D75D76D77D78D79D7aD83D84D85D86D87D88D89D8aD93D94D95D96D97D98D99D9aDa3Da4Da5Da6Da7Da8Da9DaaDb3Db4Db5Db6Db7Db8Db9DbaDc3Dc4Dc5Dc6Dc7Dc8Dc9DcaDd3Dd4Dd5Dd6Dd7Dd8Dd9DdaDe3De4De5De6De7De8De9DeaC000D30D52Da2C000Dd2C000D31D72C000D62D92De2C000D82Db2C000D20C000D21C000D42Dc2C000C111D22C111D32C111De1C111Dc1C111D61C111C222De0C222D60C222C333D41C333Db1C333D40C333D81C333D91C444D71C444Dd1C444D51Dc0C555Da1C555C666C777D80C777C888D70C888D90C888C999CaaaDb0Dd0CaaaD50CaaaCbbbCcccDa0CcccCdddCeee" {
		handleClick("B");
	    function handleClick(button) {
/////////////////////////////////////////////////////////////////////////////////

///////////////////// Selection of Image Directories: ///////////////////////////  
input = getDirectory("input folder where images are stored"); 
list = getFileList(input); 
/////////////////////////////////////////////////////////////////////////////////

///////////////////// File directory ///////////////////////////////////////////
Results_Folder = "Results";
ROI_Folder = "ROIs";
QC_Folder = "Quality_Control";
Results_Folder_Path = input + Results_Folder + "/";
ROI_Folder_Path = input + ROI_Folder + "/";
QC_Folder_Path = input + QC_Folder + "/";

File.makeDirectory(Results_Folder_Path);
File.makeDirectory(ROI_Folder_Path);
File.makeDirectory(QC_Folder_Path);
/////////////////////////////////////////////////////////////////////////////////


///////////////////// Batch Mod Activation //////////////////////////////////////
// For faster processing
setBatchMode(true);
//Note: To show picture setBatchMode("show");
run("Set Measurements...", "  redirect=None decimal=3");
////////////////////////////////////////////////////////////////////////////////

///////////////////// Channel numbers array /////////////////////////////////////
ChannelNumber=newArray("2","3","4","5","6","7","8","9","10","11","12","13","14","15");
////////////////////////////////////////////////////////////////////////////////

///////////////////// Create dialog for macro options ///////////////////////////
Dialog.create("macro options");
Dialog.addMessage("Enter your settings here:");
Dialog.addNumber("Expansion around nuclei for segmentation [µm]:", "0.1");
Dialog.addChoice("Number of channels (including Nuclei staining channel)", ChannelNumber, ChannelNumber[0]);
Dialog.addNumber("Minimum size threshold for dots detection [µm]", "0.1"); 
Dialog.show();
////////////////////////////////////////////////////////////////////////////////

///////////////////// User inputs /////////////////////////////////////////////
cell_size = Dialog.getNumber();
dot_size = Dialog.getNumber();
ChannelsTotal = Dialog.getChoice();
////////////////////////////////////////////////////////////////////////////////

///////////////////// Dynamic dialog for channel options ///////////////////////
Dialog.create("Channels options");
Dialog.addMessage("Name your channels:");
Dialog.addMessage("Do not use special characters"); 
channelNames = newArray(); // To store the names of the channels

for (i = 1; i <= parseInt(ChannelsTotal); i++) {
    Dialog.addString("Channel " + i + ":", "");
}
Dialog.show();

for (i = 1; i <= parseInt(ChannelsTotal); i++) {
    channelNames[i-1] = Dialog.getString();
}
////////////////////////////////////////////////////////////////////////////////


///////////////////// Nuclei channel designation ////////////////////////////////
Dialog.create("Nucleus channel selection");
Dialog.addChoice("Nucleus channel", channelNames, channelNames[0]);
Dialog.show();
NucleusChannel = Dialog.getChoice();
////////////////////////////////////////////////////////////////////////////////

///////////////////// Analysis settings save ///////////////////////////////////
    for (i = 0; i < ChannelsTotal && i < 15; i++) {
print("Channel " + (i + 1) + ": " + channelNames[i]);
}
print("Expansion around nuclei [µm]: "+cell_size+"");
print("Nuclei channel: "+NucleusChannel+"");
print("Size exclusion of dot < "+dot_size+"");
selectWindow("Log");
saveAs("Text", Results_Folder_Path + "Analysis_Settings.txt");
run("Close");
///////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////////   	
///////////////////// AURA Macro Core /////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////

///////////////////// Loop Through Image Files ////////////////////////////////////
 	for (j = 0; j<list.length; j++) {
if (endsWith(list[j], ".tif") || endsWith(list[j], ".tiff")) {
open(input + list[j]);

///////////////////////////////////////////////////////////////////////////////////
 	   	
///////////////////// Image informations /////////////////////////////////////////
roiManager("reset");//Clean previous results
ori=getTitle();
dir=getInfo("Image.directory");
//////////////////////////////////////////////////////////////////////////////////

///////////////////// Image Duplication and Channel Splitting ///////////////////
run("Duplicate...", "title=Working duplicate");
run("Split Channels");

for (i = 1; i <= ChannelsTotal && i <= 15; i++) {
    selectImage("C" + i + "-Working");
    rename(channelNames[i-1]); 
}
/////////////////////////////////////////////////////////////////////////////////

///////////////////// Nucleus Segmentation /////////////////////////////////////
selectImage(NucleusChannel);
ApplyNucleiSegmentation();
/////////////////////////////////////////////////////////////////////////////////

///////////////////// Voronoi-Based Cell Segmentation //////////////////////////
run("Duplicate...", "title=voronoi");
run("Voronoi");
setThreshold(1, 255);
setOption("BlackBackground", false);
run("Convert to Mask");
selectImage(NucleusChannel);
run("3D Watershed Voronoi", "radius_max=cell_size"); 
run("8-bit");
run("Invert");
imageCalculator("OR create", "voronoi","VoronoiZones");
selectImage("Result of voronoi");
run("Invert");
run("Select None");
run("Analyze Particles...", "show=Masks exclude"); 
run("Create Selection");
roiManager("add");
selectImage("Result of voronoi");
run("Select None");
run("Analyze Particles...", "show=Masks exclude add");

	roiManager("Select", 0);
	roiManager("Rename", "AllNuclei");
nNuclei=roiManager("count");	
for (i = 1; i < nNuclei; i++) {
	roiManager("Select", i);
	roiManager("Rename", "cell_"+i);
	}
/////////////////////////////////////////////////////////////////////////////////

///////////////////// Nuclei Quality Control ////////////////////////////////////
selectWindow("nuclei_QC");
run("Grays");
run("RGB Color");
setForegroundColor(255, 0, 0);
roiManager("select", 0);
run("Draw", "slice");
saveAs("Tiff", QC_Folder_Path+replace(ori, ".tif", "_Nucleus_QC.tif")); 
/////////////////////////////////////////////////////////////////////////////////

///////////////////// Dot Analysis //////////////////////////////////////////////
for (i = 0; i < ChannelsTotal && i < 15; i++) {
    if (channelNames[i] != NucleusChannel) {

        selectImage(channelNames[i]);
        run("Duplicate...", "title=analyze_" + channelNames[i]);
        
        ApplyDotSegmentation();
        
        selectImage("analyze_" + channelNames[i]);
        run("Analyze Particles...", "size=" + dot_size + "-Infinity show=Masks");
        rename(channelNames[i] + "_mask");
        run("Duplicate...", "title=" + channelNames[i] + "_1");

        nNuclei = roiManager("count");
        for (k = 1; k < nNuclei; k++) {
            selectWindow(channelNames[i] + "_" + k);
            roiManager("Select", k); 
            run("Analyze Particles...", "summarize");
            rename(channelNames[i] + "_" + (k+1));
        }
Table.deleteColumn("%Area");
Table.deleteColumn("Average Size");
//Table.deleteColumn("Total Area");
saveAs("Results", Results_Folder_Path+replace(ori, ".tif", "_"+channelNames[i]+".csv")); //
run("Close");
/////////////////////////////////////////////////////////////////////////////////


///////////////////// Dots Quality Control //////////////////////////////////////
selectImage(channelNames[i] + "_mask");
run("Select None");
run("Create Selection");
selectImage(channelNames[i]);
run("Duplicate...", "title="+channelNames[i]+"_QC");
ApplyQualityControl();
saveAs("Tiff", QC_Folder_Path+replace(ori, ".tif", "_"+channelNames[i]+"_QC.tif")); //
    }
}
roiManager("Select", 0);
roiManager("Delete");
roiManager("Add");
roiManager("Save", ROI_Folder_Path+ori+"-RoiSet.zip");

setForegroundColor(255, 0, 0);
run("Close");
run("Close All");
}
}
/////////////////////////////////////////////////////////////////////////////////

///////////////////// Final cleaning ////////////////////////////////////////////
run("Close All");
roiManager("reset");
 waitForUser("Done! Thank you for using AURA");
 }
	}
/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////