// 
// Simulation of a pair of FS neurons connected through gap junctions.
// Input is read from the INDATA directory.
//
// Usage: Use matlab script to generate indata
//        Call genesis code from matlab script
//        Parse outdata files and move them to storage directory
//
// Johannes Hjorth, January 2006
// hjorth@nada.kth.se
//
//

echo "### Start of script ###################"
echo "Johannes Hjorth (hjorth@nada.kth.se)"
echo "Last updated: September 2008"
echo " "

// Read maxTime from parameter file!

str parFile = "INDATA/parameters.txt"
openfile {parFile} r

str outputName = {readfile {parFile}} //"FSGapEff"
float maxTime = {readfile {parFile}}
int numCells = {readfile {parFile}}

echo "Simulating "{numCells}" FS neurons for "{maxTime}" seconds"
echo "Writing output to "{outputName}

//simulation time and time steps
float spikeoutdt=1e-3
float vmOutDt= 1e-4
float simDt= 1e-5 //1e-6 needed for voltage clamp

// Number of synapse sites

int nAMPA = 127 // per cell
int nGABA = 93

//read in functions for creating and running simulations
include protodefs 
include ../genesisScripts/fsInputFromFile
include ../genesisScripts/fsSomaOutput
include ../genesisScripts/fsInputInject

//setclocks
setclock 1 {vmOutDt}
setclock 0 {simDt}

// Use the SPRNG random number generator
setrand -sprng
randseed 21483789

// Read input location from parameter file

str masterInputLoc = {readfile {parFile}}
str slaveInputLoc = {readfile {parFile}}
str masterFile = {readfile {parFile}}
str slaveFile = {readfile {parFile}}

// Create neuron
echo "Creating "{numCells}" FS neurons"
copyFsNeuron "/fs" {numCells}

loadSpikeTrain {masterFile} masterTrain
loadSpikeTrain {slaveFile}  slaveTrain

connectNamedSpikeTrain masterTrain {masterInputLoc} AMPA
connectNamedSpikeTrain slaveTrain  {slaveInputLoc} AMPA


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

    connectGap {gapSrc} {gapDest} {gapRes}

    echo {gapSrc}"-->"{gapDest}" res: "{gapRes}
end

// Add current pulses to neurons

int numCurrentPulses = {readfile {parFile}}
int iPulse 
str pulseLine
str pulseName = "injectedCurrentPulse"
float pulseStart
float pulseEnd
float pulseCurrent
str pulseLoc

for(iPulse = 0; iPulse < numCurrentPulses; iPulse = iPulse + 1)
    pulseLine = {readfile {parFile} -linemode}
    echo "Read: "{pulseLine}
    pulseStart = {getarg {arglist {pulseLine}} -arg 1}
    pulseEnd  = {getarg {arglist {pulseLine}} -arg 2}
    pulseCurrent = {getarg {arglist {pulseLine}} -arg 3}
    pulseLoc = {getarg {arglist {pulseLine}} -arg 4}

    // makeInjectInput cant handle currents that are 0
    if({pulseCurrent} != 0)

      echo "Pulse "{pulseStart}"s ->"{pulseEnd}"s "{pulseCurrent}"A loc: "{pulseLoc}
//    makeInjectInput {pulseName}{iPulse} {pulseStart} {pulseEnd} {pulseCurrent}
      makeInjectInputNoRepeat {pulseName}{iPulse} {pulseStart} {pulseEnd} \
                            {pulseCurrent} {maxTime}
      connectInjectInput {pulseName}{iPulse} {pulseLoc}

    end
end

closefile {parFile}

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
//step 3.14664 -t
//step 3.14663 -t

clearOutput {outputName}

// close files
quit
