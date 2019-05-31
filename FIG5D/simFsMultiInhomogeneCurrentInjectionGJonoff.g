// 
// Simulation of a pair of FS neurons connected through gap junctions.
//
// Neurons are driven by current injection.
//
// Johannes Hjorth, Mars 2007
// hjorth@nada.kth.se

echo "### Start of script ###################"
echo "Johannes Hjorth (hjorth@nada.kth.se)"
echo "Last updated: September 2007"
echo " "

// Read information about input data


// Read maxTime from parameter file!

str parFile = "INDATA/parameters.txt"
openfile {parFile} r

str outputName = {readfile {parFile}}
float maxTime  = {readfile {parFile}}
int numCells   = {readfile {parFile}}

echo "Simulating "{numCells}" FS neurons for "{maxTime}" seconds"
echo "Using randseed 4711 for genesis internally"
echo "This simulations should be deterministic, so should not matter"
echo "Writing output to "{outputName}


//simulation time and time steps
float spikeoutdt=1e-3
float vmOutDt=1e-4
float simDt=1e-5 //1e-6 needed for voltage clamp

// Number of synapse sites

int nAMPA = 127 // per cell
int nGABA = 93

//read in functions for creating and running simulations
include ../genesisScripts/protodefsInhomogene 
include ../genesisScripts/fsSomaOutput
include ../genesisScripts/fsInputInject

//setclocks
setclock 1 {vmOutDt}
setclock 0 {simDt}

// Use the SPRNG random number generator
setrand -sprng
randseed 4711
//randseed {{randSeed} + 4711}

// Create neuron
// echo "Creating "{numCells}" FS neurons"
// copyFsNeuron "/fs" {numCells}

// ************  SYNAPTIC INPUT REMOVED only current injection



// Read location of gap junctions from parameter file

int numGaps = {readfile {parFile}}
int gapCtr


// Read current injection info

str currentInputInfoFile = "INDATA/currentInputInfo.txt"
openfile {currentInputInfoFile} r

int nCurs = {readfile {currentInputInfoFile}}
int iCur
float curStart
float curEnd
float curAmp
str curLoc


for(iCur = 0; iCur < nCurs; iCur = iCur + 1)
  curStart = {readfile {currentInputInfoFile}}
  curEnd = {readfile {currentInputInfoFile}}
  curAmp = {readfile {currentInputInfoFile}}
  curLoc = {readfile {currentInputInfoFile}}

  echo "curStart: "{curStart}" curEnd: "{curEnd}" curAmp "{curAmp}" curLoc "{curLoc}

  makeInjectInput currentInject{iCur} {curStart} {curEnd} {curAmp}
  connectInjectInput currentInject{iCur} {curLoc}
end



check


  
makeOutput "/fs" {outputName} {vmOutDt}

reset       
reset

step 0.25 -t

// Create gap junctions required in file

str readGapLine
str gapSrc
str gapDest
float gapRes

for(gapCtr = 0; gapCtr < numGaps; gapCtr = gapCtr + 1)
    readGapLine = {readfile {parFile} -linemode}

    gapSrc  = {getarg {arglist {readGapLine}} -arg 1}
    gapDest = {getarg {arglist {readGapLine}} -arg 2}
    gapRes  = {getarg {arglist {readGapLine}} -arg 3}

    if({gapRes} > 0)
      connectGap {gapSrc} {gapDest} {gapRes}

      echo {gapSrc}"-->"{gapDest}" res: "{gapRes}
    else
      echo "WARNING: gapRes: "{gapRes}" ohm, no gap junction created"
    end
end

closefile {parFile}


step 0.25 -t
openfile {parFile} r
readfile {parFile}
readfile {parFile}
readfile {parFile}

numGaps = {readfile {parFile}}

for(gapCtr = 0; gapCtr < numGaps; gapCtr = gapCtr + 1)
    readGapLine = {readfile {parFile} -linemode}

    gapSrc  = {getarg {arglist {readGapLine}} -arg 1}
    gapDest = {getarg {arglist {readGapLine}} -arg 2}
    gapRes  = {getarg {arglist {readGapLine}} -arg 3}

    if({gapRes} > 0)
      clearGap {gapSrc} {gapDest}

      echo "Removing "{gapSrc}"-->"{gapDest}
    else
      echo "WARNING: gapRes: "{gapRes}" ohm, no gap junction created"
    end
end

closefile {parFile}


step {{maxTime}-0.5} -t



clearOutput {outputName}

// close files
quit
