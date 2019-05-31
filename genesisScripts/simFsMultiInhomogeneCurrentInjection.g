// 
// Simulation of a pair of FS neurons connected through gap junctions.
// Input is read from the INDATA directory.
//
// Usage: Use matlab script to generate indata
//        Call genesis code from matlab script
//        Parse outdata files and move them to storage directory
//
// Johannes Hjorth, Mars 2007
// hjorth@nada.kth.se
//
// THIS VERSION OF THE CODE USES A CURRENT INJECTION INSTEAD OF SYNAPTIC INPUT
// DATA IS USED TO GENERATE IF CURVE
//

echo "### Start of script ###################"
echo "Johannes Hjorth (hjorth@nada.kth.se)"
echo "Last updated: Mars 2007, Oct 2008"
echo " "


// Read maxTime from parameter file!

str parFile = "INDATA/parameters.txt"
openfile {parFile} r

str outputName = {readfile {parFile}}
float maxTime  = {readfile {parFile}}
int numCells   = {readfile {parFile}}

echo "Simulating "{numCells}" FS neurons for "{maxTime}" seconds"
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
include ../genesisScripts/fsInputFromFile
include ../genesisScripts/fsSomaOutput
include ../genesisScripts/fsInputInject

//setclocks
setclock 1 {vmOutDt}
setclock 0 {simDt}

// Use the SPRNG random number generator
setrand -sprng
//randseed {{randSeed} + 4711}

// Create neuron
// echo "Creating "{numCells}" FS neurons"
// copyFsNeuron "/fs" {numCells}

// ************  SYNAPTIC INPUT REMOVED only current injection



// Read location of gap junctions from parameter file

int numGaps = {readfile {parFile}}
int gapCtr

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

// TODO: Add GABA connections between FS neurons
// code by Lennart is available in fsConnect.g
// function: reciprocalGABAinhib

closefile {parFile}


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

//  makeInjectInput currentInject{iCur} {curStart} {curEnd} {curAmp}
  makeInjectInputNoRepeat currentInject{iCur} {curStart} {curEnd} {curAmp} {maxTime}
  connectInjectInput currentInject{iCur} {curLoc}
end



check

// // 6 tertdend at 1.5e9 ohm --> 14.1% coupling
// float tertGapRes = 1.5e9
// 
// // 1 soma-soma gapjunction at 2.6e9 ohm --> 14.1% coupling
// float somaGapRes = 2.6e9

  
makeOutput "/fs" {outputName} {vmOutDt}

reset       
reset

step {maxTime} -t

clearOutput {outputName}

// close files
quit
