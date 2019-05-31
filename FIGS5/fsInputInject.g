////////////////////////////////////////////////////////////////////////////
//
// Creates different types of input that is injected into a FS-cell
//
// Based on Genesis Cable-tutorial 
//
// Johannes Hjorth, august 2005
// hjorth@nada.kth.se
//
////////////////////////////////////////////////////////////////////////////


function makeInjectInput (name, pulseStart, pulseEnd, current)
  str name
  float pulseStart
  float pulseEnd
  float current

  echo "makeInjectInput "{name}

  str path = "/input/"@{name}

  if(!{exists /input})
    create neutral /input
  end

  create pulsegen {path}
  setfield {path} level1 {current} \
           width1 {pulseEnd-pulseStart} \
           delay1 {pulseStart}  

end

////////////////////////////////////////////////////////////////////////////

function makeInjectInputNoRepeat (name, pulseStart, pulseEnd, current, maxTime)
  str name
  float pulseStart
  float pulseEnd
  float current

  echo "makeInjectInput "{name}

  str path = "/input/"@{name}

  if(!{exists /input})
    create neutral /input
  end

  create pulsegen {path}
  setfield {path} level1 {current} \
           width1 {pulseEnd-pulseStart} \
           delay1 {pulseStart} \
           delay2 {maxTime}

end

////////////////////////////////////////////////////////////////////////////


function connectInjectInput(name, target)
  str name, target

  echo "connectInjectInput "{name}" "{target}

  str path = "/input/"@{name}
  
  addmsg {path} {target} INJECT output

end


////////////////////////////////////////////////////////////////////////////

// Loads spiketrain from file for later connection to FS cell

function loadSpikeTrain(fileName, inputName)
  str fileName
  str inputName

  str inputPath = "/insignal/"@{inputName}

  if(!{exists /insignal})
    create neutral /insignal
  end

  echo "Creating "{inputPath}
  create timetable {inputPath}

  setfield {inputPath} maxtime {maxTime} act_val 1.0 \
           method 4 fname {fileName}

  call {inputPath} TABFILL

  // Create spikes from timetable
  create spikegen {inputPath}/spikes
  setfield {inputPath}/spikes output_amp 1 thresh 0.5 abs_refract 0.0001
  addmsg {inputPath} {inputPath}/spikes INPUT activation

end

////////////////////////////////////////////////////////////////////////////

function connectSpikeTrain(inputName, cellPath, compType, channel, pCon)

  str inputName
  str cellPath
  str compType
  str channel   // ie, AMPA, GABA, NMDA...
  float pCon    // Probability that a compartment will recieve connection

  str srcPath
  str destPath

  int conCtr = 0

  // echo "Use /fs[] instead of /fs if you want to connect input to ALL cells"

  srcPath = "/insignal/"@{inputName}@"/spikes"

  foreach destPath ({el {cellPath}/{compType}#/{channel}_channel} \
                    {el {cellPath}/{compType}#/{compType}#/{channel}_channel})

    if({rand 0 1} < {pCon})
      //echo "Connecting "{srcPath}" with "{destPath}
      addmsg {srcPath} {destPath} SPIKE
      conCtr = {conCtr + 1}
    end
  end


  echo "Total of "{conCtr}" connections: "{srcPath}"->"{cellPath}"("{compType}" "{channel}")"
end


////////////////////////////////////////////////////////////////////////////


function connectNamedSpikeTrain(inputName, compPath, channel)

  str inputName
  str compType
  str channel   // ie, AMPA, GABA, NMDA...

  str srcPath
  str destPath

  int conCtr = 0

  // echo "Use /fs[] instead of /fs if you want to connect input to ALL cells"

  srcPath = "/insignal/"@{inputName}@"/spikes"
  destPath = {compPath}@"/"@{channel}@"_channel"

  addmsg {srcPath} {destPath} SPIKE

end


////////////////////////////////////////////////////////////////////////////


function clearSpikeTrainConnections(inputName)

  str inputName
  str inputPath = "/insignal/"@{inputName}@"/spikes"
  int msgCtr
  int msgNum


  msgCtr = {getmsg {inputPath} -out -count}

  echo "Clearing connections from "{inputPath}

  for(msgNum = 0; msgNum < msgCtr; msgNum = msgNum + 1)
    deletemsg {inputPath} 0 -out 
  end

end

////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////


