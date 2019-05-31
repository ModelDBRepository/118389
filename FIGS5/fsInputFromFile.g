//
// fsInputFromFile.g
//
// Johannes Hjorth, hjorth@csc.kth.se
// December 2005
//
// Updated february 2009, moved parts of fsInsignalGenerator.g here
// (the functions that were used to connect input to the synapes)
//
// Functions to read noise and insignal data from file to timetables
//

// Please note that readInputFromFile assumes that the files are numbered
// from 1 and up, whereas the input naming convention starts from 0

function readInputFromFile(inputName, filePath, fileNum)

    str inputName
    str filePath
    int fileNum

    str inputBasePath = "/input"
    int ctr

    str inputPath = {inputBasePath}@"/"@{inputName}

    if({maxTime} == 0)
        echo "readInputFromFile: Error, maxTime is set to 0"
        quit
    end

    if(!{exists {inputBasePath}})
        create neutral {inputBasePath}
    end

    echo "Reading from "{filePath}" files 1 to "{fileNum}
    echo "Connecting input to "{inputPath}[0]" to "[{{fileNum}-1}]


    for(ctr = 0; ctr < {fileNum}; ctr = ctr + 1)


        create timetable {inputPath}[{ctr}]
        setfield {inputPath}[{ctr}] maxtime {maxTime} \
                                    method 4 \
                                    act_val 1.0 \ 
                                    fname {filePath}{{ctr}+1}

        call {inputPath}[{ctr}] TABFILL

        create spikegen {inputPath}[{ctr}]/spikes

        setfield {inputPath}[{ctr}]/spikes \
                 output_amp 1 thresh 0.5 abs_refract 0.0001

        addmsg {inputPath}[{ctr}] {inputPath}[{ctr}]/spikes \
               INPUT activation
        
    end

end





//////////////////////////////////////////////////////////////////////////////
//
// Connects insignal objects to the synapses of the cells
//
// if the fsNetworkPath ends with [], eg /fs[] then all cells in the /fs
// path will get connected to the insignal specified. If it only says /fs then
// just the first cell /fs[0] will get connected.
//
//////////////////////////////////////////////////////////////////////////////


function connectFsInsignalToCell(fsNetworkPath, fsInsignalPath, channelTypes)

    str fsNetworkPath
    str fsInsignalPath
    str channelTypes

    str fsName, compName

    int insignalCtr = 0 // We assume that there are enough insignals in the path

    str channelType
    int dCtr, densityMax


    if({strlen channelTypes} == 0)
      echo "The function connectFsInsignal in fsInsignalGenerator.g"
      echo "has been updated! Please add channelType argument to call."
      echo " "
      echo "eg. connectFsInsignal /fs /insignal \"AMPA GABA \""
      echo " "
      echo "Aborting genesis."
      quit
    end


    foreach fsName ({el {fsNetworkPath}}) // Loop through network cells if []

        // Connect to soma AMPA+GABA, later also NMDA

        foreach channelType ({arglist {channelTypes}}) // Add NMDA later
            echo "Connecting "{channelType}" inputs to "{fsName}" starting at "{fsInsignalPath}" (#"{insignalCtr}")"

            densityMax = {getfield {fsName} somaDensity{channelType}}

            for(dCtr = 0; dCtr < densityMax; dCtr = dCtr + 1)

                // echo "* soma ("{insignalCtr}")

                addmsg {fsInsignalPath}[{insignalCtr}]/spikes \
                       {fsName}/soma/{channelType}_channel SPIKE
                insignalCtr = {insignalCtr + 1}

            end


            // Connect to primary dendrites

            densityMax = {getfield {fsName} primDensity{channelType}}

            foreach compName ({el {fsName}/primdend#} \
                              {el {fsName}/primdend#/prim_dend#})

                for(dCtr = 0; dCtr < densityMax; dCtr = dCtr + 1)

                    // echo "* "{compName}" starting from input "{insignalCtr}

                    addmsg {fsInsignalPath}[{insignalCtr}]/spikes \
                           {compName}/{channelType}_channel SPIKE

                    insignalCtr = {insignalCtr + 1}
                end
            end


            // Connect to secondary dendrites

            densityMax = {getfield {fsName} secDensity{channelType}}

            foreach compName ({el {fsName}/secdend#} \
                              {el {fsName}/secdend#/sec_dend#})

                for(dCtr = 0; dCtr < densityMax; dCtr = dCtr + 1)

                    // echo "* "{compName}" starting from input "{insignalCtr}

                    addmsg {fsInsignalPath}[{insignalCtr}]/spikes \
                           {compName}/{channelType}_channel SPIKE
                    insignalCtr = {insignalCtr + 1}

                end
            end

            // Connect to tertiary dendrites

            densityMax = {getfield {fsName} tertDensity{channelType}}

            foreach compName ({el {fsName}/tertdend#} \
                              {el {fsName}/tertdend#/tert_dend#})

                for(dCtr = 0; dCtr < densityMax; dCtr = dCtr + 1)

                    // echo "* "{compName}" starting from input "{insignalCtr}

                    addmsg {fsInsignalPath}[{insignalCtr}]/spikes \
                           {compName}/{channelType}_channel SPIKE
                    insignalCtr = {insignalCtr + 1}
                end
            end
        end
    end
end

//////////////////////////////////////////////////////////////////////////////


function connectFsInsignal(fsNetworkPath, fsInsignalPath, channelTypes)
  str fsNetworkPath
  str fsInsignalPath
  str channelTypes

  connectFsInsignalToCell {fsNetworkPath}[] {fsInsignalPath} {channelTypes}

end



