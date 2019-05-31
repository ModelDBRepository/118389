//////////////////////////////////////////////////////////////////////////////
//
// fsOutput.g
// Johannes Hjorth, July 2005
//
// Handles writing output from FS-neurons in a simulation to file
//
//////////////////////////////////////////////////////////////////////////////

//
// Example:
// makeOutput /fs /home/nobackup/genesis.DATA/run07.txt "Testing NMDA channels"
//
//
//



function makeOutput(cellPath, outputName, plotDt)

    str cellPath
    str outputName
    float plotDt
    str description
    int index

    str fileBasePath = "UTDATA/"

    str filenameDATA = {fileBasePath}@{outputName}@".data"
    str outputPath = "/output/"@{outputName}
    str filenameINFO = {fileBasePath}@{outputName}@".info"
    str cellSoma
    int cellCtr = 0

    if(!{exists /output})
        echo "Creating /output"
        create neutral /output        
    end 

    foreach cellSoma ({el {cellPath}[]/soma})
        cellCtr = {cellCtr + 1}
    end


    // Open the file in overwrite mode and write the simulation parameters

    echo "Writing simulation parameters to "{filenameINFO}

    openfile {filenameINFO} w
    
    writefile {filenameINFO} "nParams     2 0" // 2 numbers, 0 strings
    writefile {filenameINFO} "cellCtr     "{cellCtr}
    writefile {filenameINFO} "maxTime     "{maxTime}


    // Add info about noise level etc. Ändra på parameters randen

    closefile {filenameINFO}

    echo "Setting clock 1 (output to file) to "{plotDt}"s"
    setclock 1 {plotDt}

    // Close file and reopen it as an asc_file object (append mode)
    // to add simulation data.

    if(!{exists {outputPath}})
      echo "Creating new asc_file object: "{outputPath}
      create asc_file {outputPath}
    end

    setfield {outputPath} leave_open 1 append 0 notime 0 filename {filenameDATA}
    useclock {outputPath} 1

    foreach cellSoma ({el {cellPath}[]/soma})
        echo "Directing voltage of "{cellSoma}" to "{filenameDATA}
        addmsg {cellSoma} {outputPath} SAVE Vm
    end

end

//////////////////////////////////////////////////////////////////////////////

function addCompartmentOutput(compartment, outputName)

  str compartment
  str outputName
  str outputPath = "/output/"@{outputName}

  echo "Directing voltage of "{compartment}" to "{getfield {outputPath} filename}

  addmsg {compartment} {outputPath} SAVE Vm

end

//////////////////////////////////////////////////////////////////////////////

function clearOutput(outputName)
  str outputName

  str outputPath = "/output/"@{outputName}

  int ctr
  int nMsg = {getmsg {outputPath} -incoming -count}
  
  echo "Clearing output "{outputName}

  for(ctr = 0; ctr < nMsg; ctr = ctr + 1)
    deletemsg {outputPath} 0 -incoming
  end

  // HERE THE asc_file should be closed!!

end
