///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////// AURA: Automated Universal RNA in situ Analysis for high-throughput applications //////////////////////////////////////////////////////////////////////////////////////
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
		macro "A Button Action Tool - N66C000C111C222D31C333D71D81Dc1C333D61D91Da1Db1Dd1De1C333D51C333D41C333DbaC333DbdC333C444D04C444DdaC444D03C444Db0Dd0De0C444D80Dc0C444D40D49D70Da0C444D30D4aD50D90C444D05D06D4bD60C444D07D0cC444D08D09D0aD0bD0dD0eD4cC444D4dC444C555D14C555D45C555D02C555D20C555D23C555D8cD8dC555D8bD8eC555D8aC555D32C555D89C555D01C666D10D13C666DbbC666C777D24C777D33C777DaaC777C888DadDcaC888D21DabC888DddC888DdeC888DacDb9C888D44D48C888D22C888C999D88C999DdbC999D15C999Dd9C999D16D46DbeDdcC999D17C999D18D19D1aD1bD1cD1dD1eCaaaD11D42D55CaaaDedCaaaD00D34DeaCaaaD62D72CaaaD3bD52D82D92Da2Db2Dc2Dd2De2DeeCaaaD3aD3cCaaaDd8CaaaD39D3dCaaaD4eCaaaD35D54CaaaD5aD5dCaaaD25D59D5bD5cDbcCaaaD43D56CaaaD6eCbbbD36CbbbD26D66D73D74D75D76D84D85D94Da4Dc4Dc5Dd4Dd7CbbbD53D57D63D64D65D83D86D93D95D96Da3Da5Da6Db3Db4Db5Db6Dc3Dc6Dd3Dd5Dd6De3De4De5De6CbbbD38D58D67CbbbD47CbbbD87D97CbbbD37CbbbD27Dc7De9CbbbDcbDe7CbbbDa9CbbbD77DcdCbbbDa7CbbbD68Db7DecCcccD6cD6dCcccD69D6bCcccD6aD98CcccD12CcccD9eCcccD5eD99DaeCcccD9aCcccDc9CcccD9bCcccD9cD9dCcccDebCcccCdddDc8CdddD3eCdddD28CdddDe8CdddD2cCdddD29D2aD2bD2dDceCdddD2eCdddCeeeD78CeeeD7dCeeeD7cCeeeD7bD7eCeeeD79D7aCeeeDa8CeeeCfffDccCfffDb8CfffBf0C000C111C222D71C222D31C222D21D41C333D01D11C333D51C333D1dD61D99C333D4aC333Da3Da4C333D4dC333D4cD4eC333C444D4bC444Da9C444D8aC444DaaC444D1eD20D30Da5C444D10D40Da2C444D00Da6C444D49D50DabDacDadDaeC444D60C444D70Da7C444Da8C444D19C444D65C444D94C555D80C555D89C555Da1C555D90C555D5aC555D93C555D83C555C666D1aC666D91C666D8bC666D9aC666D72C666C777D8cC777D7aC777D8dC777D7bD8eD98C777D7cD7dD7eC777D84C888D81C888D59C888D18C888D73C888D1cC888D48C888D64C888C999D9bC999D82C999D95C999D66C999D55C999Da0C999D5bD9cD9eCaaaD96D9dCaaaD42D52D97CaaaD02D12D22D32D62CaaaD2dD5cCaaaD5dCaaaD5eCaaaD88CaaaD54CaaaD56CaaaD75D92CaaaD79CbbbD04D05D24D34D46D76CbbbD03D06D13D14D15D16D17D23D25D26D33D35D36D43D44D45D47D53D74D85D86CbbbD63D87CbbbD07D2cCbbbD27D37CbbbD09CbbbD0dD67D77CbbbD0eD57CcccD08CcccD0aCcccD2eCcccD29CcccD38CcccD28CcccD39CdddD3aD3dD3eCdddD3cCdddD3bCdddD2aCdddD6aCdddD0cCdddCeeeD1bCeeeD69CeeeD6bCeeeD6cD6dCeeeD6eCeeeCfffD58D78CfffD0bD68CfffD2bB0fC000D09D0aD19D1aD29D2aD39D3aD49D4aD59D5aD69D6aD79D7aD89D8aD99D9aDa9DaaC000C111D88C111C222D98C222D78C222C333D48C333D18D38D58C333D08D28D68C333D71C333Da7C333D40C444D41C444Da5C444Da4C444D97C444D87C444Da2Da6C444Da0Da1Da3C444D01D10C444C555D11C555D31C555C666D77C666D76C666C777D70D95C777Da8C777D94C777D80C777D64D81D85C777C888D61C888C999D75C999D84C999D63D72C999D42C999D12C999D02D91D92CaaaD90CaaaD93CaaaD32CaaaD82CaaaD86CaaaD17D27D37D47D57CaaaD07D21D54CaaaD67CaaaD51CaaaD50CaaaD53CaaaCbbbD00D52D62CbbbD74CbbbD22D65CbbbD04D05D14D15D23D24D25D35D43D44D45D55D56D73CbbbD03D06D13D16D26D33D34D36D46D66D83CbbbD96CbbbCcccD30CcccD20CcccCdddD60CeeeCfffNf0C000D09D0aD19D1aD29D2aD39D3aD49D4aD59D5aD69D6aD79D7aD89D8aD99D9aDa9DaaDb9DbaDc9DcaDd9DdaDe9DeaC000C111D28C111C222D38C222D18C222Dd1C222D58C333D48D68D88C333D78D98Dd8C333Dc8C333Da8Db8De8C333D81C333D27C333Dd0C333C444Dc1C444D51C444D04C444D05D61C444D07Db1C444D41C444D17C444D03C444D00D01D02C444C555D80C555D31C555D06D37C555C666D36C666D60D71C666De1C666C777D15C777D14D25C777Da1C777D44C777D90C777C888D08D42D91Dc2C888D52C888C999Db2C999D35D43Dd2C999D82C999D24C999D26D62C999De0C999D32C999D12D13C999D11D47CaaaD10D21CaaaD72CaaaD67D77CaaaD57D87D97Da7CaaaDb7Dc7Dd7De2De7CaaaD54CaaaD53D92CaaaDc3CaaaD46CaaaDa2CbbbDd3CbbbD45D55D63Db3CbbbD22D33D34D56D64D65D66D73D74D75D76D83D84D85D86D94Da4Db4Dc4Dd4De3De4CbbbD23D93D95D96Da5Da6Db5Db6Dc5Dd5De5CbbbDa3Dc6Dd6De6CbbbDc0CbbbCcccD50Da0CcccCdddD70CdddD16CdddD20CdddCeeeDb0CeeeD30CeeeD40CeeeCfff" {
		handleClick("B");
	    function handleClick(button) {
/////////////////////////////////////////////////////////////////////////////////

///////////////////// Selection of Image Directories: ///////////////////////////  
input = getDirectory("input folder where images are stored"); 
list = getFileList(input); 
/////////////////////////////////////////////////////////////////////////////////
// For faster processing
setBatchMode(true);
//Note: To show picture setBatchMode("show");
run("Set Measurements...", "redirect=None decimal=3");
////////////////////////////////////////////////////////////////////////////////

///////////////////// Channel numbers array /////////////////////////////////////
ChannelNumber = newArray("2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15");
////////////////////////////////////////////////////////////////////////////////

///////////////////// Create dialog for macro options ///////////////////////////
Dialog.create("Number of channels");
Dialog.addMessage("Enter your settings here:");
Dialog.addChoice("Number of channels (including Nuclei staining channel)", ChannelNumber, ChannelNumber[0]);
Dialog.show();
ChannelsTotal = Dialog.getChoice();
////////////////////////////////////////////////////////////////////////////////

///////////////////// Dynamic dialog for channel options ///////////////////////
Dialog.create("Channel names");
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

///////////////////// Nuclei expansion designation ////////////////////////////////
Dialog.create("Nuclei expansion");
Dialog.addNumber("Expansion around nuclei for segmentation [µm]:", "0.1");
Dialog.show();
cell_size = Dialog.getNumber();
////////////////////////////////////////////////////////////////////////////////

///////////////////// Select Channels for Analysis ///////////////////////////
selectedChannels = newArray(); // Initialize the array to store selected channels

Dialog.create("Select Channels for Analysis");
Dialog.addMessage("Select the channels you want to analyze:");

// Add checkboxes for each channel
for (i = 0; i < channelNames.length; i++) {
    Dialog.addCheckbox(channelNames[i], true); // Default to all checked
}
Dialog.show();

// Get the user selections
for (i = 0; i < channelNames.length; i++) {
    if (Dialog.getCheckbox()) {
        selectedChannels = Array.concat(selectedChannels, channelNames[i]); // Add the selected channel to the array
    }
}

///////////////////// Minimum size threshold for each channel ///////////////////
dotSizeArray = newArray(); // To store the minimum size thresholds for each channel
Dialog.create("Dot Size Thresholds");
Dialog.addMessage("Set minimum size threshold for dots detection [µm] for each channel:");

for (i = 0; i < selectedChannels.length; i++) {
    // Skip adding a threshold input for the Nucleus Channel
    if (selectedChannels[i] != NucleusChannel) {
        Dialog.addNumber("Channel " + selectedChannels[i] + " [µm]:", "0.1");
    }
}
Dialog.show();

for (i = 0; i < selectedChannels.length; i++) {
    // Skip retrieving a threshold for the Nucleus Channel
    if (selectedChannels[i] != NucleusChannel) {
        dotSizeArray[i] = Dialog.getNumber(); // Store each channel's dot size threshold
    } else {
        dotSizeArray[i] = 0; // Set the threshold for the nucleus channel to 0 (or skip entirely based on your preference)
    }
}
////////////////////////////////////////////////////////////////////////////////

///////////////////// Analysis settings save ///////////////////////////////////
for (i = 0; i < selectedChannels.length && i < 15; i++) {
    print("Channel " + (i + 1) + ": " + selectedChannels[i]);
    if (selectedChannels[i] != NucleusChannel) {
        print("Minimum size dots [µm]: " + dotSizeArray[i]);
    }
    if (selectedChannels[i] == NucleusChannel) {
        print("Nuclei channel: " + NucleusChannel + "");
        print("Expansion around nuclei [µm]: " + cell_size + "");
    }
}

baseFilename = "Analysis_Settings";
filename = baseFilename + ".txt";
fileCounter = 1;
while (File.exists(input + filename)) {
    filename = baseFilename + "_" + fileCounter + ".txt";
    fileCounter++;
}

selectWindow("Log");
saveAs("Text", input + filename);
run("Close");

///////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////////   	
///////////////////// AURA Macro Core /////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////

///////////////////// Loop Through Image Files ////////////////////////////////////
found = false;
for (i = 0; i < list.length; i++) {
    if (endsWith(list[i], ".tif") || endsWith(list[i], ".tiff")) {
        open(input + list[i]);
         found = true;

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

fileCounter = 1;
Nucleus_QC_baseFilename = replace(ori, ".tif", "_" + "_Nucleus_QC.tif");
while (File.exists(input + Nucleus_QC_baseFilename)) {
    Nucleus_QC_baseFilename = replace(ori, ".tif", "_" +  "_Nucleus_QC_" + fileCounter + ".tif");
    fileCounter++;
}
saveAs("Tiff", input + Nucleus_QC_baseFilename);

/////////////////////////////////////////////////////////////////////////////////

///////////////////// Dot Analysis //////////////////////////////////////////////
for (i = 0; i < selectedChannels.length && i < 15; i++) {
    if (selectedChannels[i] != NucleusChannel) {

        selectImage(selectedChannels[i]);
        run("Duplicate...", "title=analyze_" + selectedChannels[i]);
        
        ApplyDotSegmentation();
        
        selectImage("analyze_" + selectedChannels[i]);
        run("Analyze Particles...", "size=" + dotSizeArray[i] + "-Infinity show=Masks");
        rename(selectedChannels[i] + "_mask");
        run("Duplicate...", "title=" + selectedChannels[i] + "_1");

        nNuclei = roiManager("count");
        for (k = 1; k < nNuclei; k++) {
            selectWindow(selectedChannels[i] + "_" + k);
            roiManager("Select", k); 
            run("Analyze Particles...", "summarize");
            rename(selectedChannels[i] + "_" + (k + 1));
        }
run("Close");
/////////////////////////////////////////////////////////////////////////////////


///////////////////// Dots Quality Control //////////////////////////////////////
selectImage(selectedChannels[i] + "_mask");
run("Select None");
run("Create Selection");
selectImage(selectedChannels[i]);
run("Duplicate...", "title="+selectedChannels[i]+"_QC");
ApplyQualityControl();


fileCounter = 1;
QC_baseFilename = replace(ori, ".tif", "_" + selectedChannels[i] + "_QC.tif");
while (File.exists(input + QC_baseFilename)) {
    QC_baseFilename = replace(ori, ".tif", "_" + selectedChannels[i] + "_QC_" + fileCounter + ".tif");
    fileCounter++;
}
saveAs("Tiff", input+QC_baseFilename); 
    }
}

run("Close");
run("Close All");
break;
}

}
/////////////////////////////////////////////////////////////////////////////////

///////////////////// Final cleaning ////////////////////////////////////////////
run("Close All");
roiManager("reset");
 waitForUser("Done! Thank you for using AURA Light");
 }
	}
/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////