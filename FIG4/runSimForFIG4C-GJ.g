// 
// Simulation of a pair of FS neurons connected through gap junctions.
// Input is read from the INDATA directory.
//
// Johannes Hjorth, Feburary 2007
// hjorth@nada.kth.se
//
//

echo "### Start of script ###################"
echo "Johannes Hjorth (hjorth@nada.kth.se)"
echo "Last updated: December 2007"
echo " "

// Read maxTime from parameter file!


str outputName = "TWOFS-FIG4C-GJ"
float maxTime = 0.5
int numCells = 2

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
include protodefs 
include ../genesisScripts/fsInputFromFile
include ../genesisScripts/fsSomaOutput
include ../genesisScripts/fsInputInject
include fsCurrentRecorder

//setclocks
setclock 1 {vmOutDt}
setclock 0 {simDt}

// Use the SPRNG random number generator
setrand -sprng
randseed 21483789

// Read input location from parameter file

str spikeInputFile1 = "INDATA/FIG4CinputSpikes1.txt"
str spikeInputFile2 = "INDATA/FIG4CinputSpikes2.txt"

// Create neuron
echo "Creating "{numCells}" FS neurons"
copyFsNeuron "/fs" {numCells}

loadSpikeTrain {spikeInputFile1} spikeTrain1
loadSpikeTrain {spikeInputFile2} spikeTrain2

//connectNamedSpikeTrain spikeTrain1 /fs[0]/soma AMPA
connectNamedSpikeTrain spikeTrain1 /fs[0]/primdend1 AMPA
//connectNamedSpikeTrain spikeTrain1 /fs[0]/primdend3 AMPA
//connectNamedSpikeTrain spikeTrain1 /fs[0]/secdend3 AMPA
//connectNamedSpikeTrain spikeTrain1 /fs[0]/tertdend5 AMPA

connectNamedSpikeTrain spikeTrain2 /fs[1]/primdend2 AMPA
connectNamedSpikeTrain spikeTrain2 /fs[1]/secdend3 AMPA
connectNamedSpikeTrain spikeTrain2 /fs[1]/secdend2 AMPA
connectNamedSpikeTrain spikeTrain2 /fs[1]/tertdend5 AMPA
connectNamedSpikeTrain spikeTrain2 /fs[1]/tertdend6 AMPA


//include fsInputInject
//
//makeInjectInputNoRepeat cellBdepol1 0    0.10 0.025e-9 {maxTime}
//makeInjectInputNoRepeat cellBdepol2 0.10 0.20 0.030e-9 {maxTime}
//makeInjectInputNoRepeat cellBdepol3 0.20 0.30 0.035e-9 {maxTime}
//makeInjectInputNoRepeat cellBdepol4 0.30 {maxTime} 0.040e-9 {maxTime}
//connectInjectInput cellBdepol1 /fs[1]/soma
//connectInjectInput cellBdepol2 /fs[1]/soma
//connectInjectInput cellBdepol3 /fs[1]/soma
//connectInjectInput cellBdepol4 /fs[1]/soma


// Create gap junction

connectGap /fs[0]/primdend1 /fs[1]/primdend1 2e9
//connectGap /fs[0]/secdend3 /fs[1]/secdend3 2e9


makeOutput "/fs" {outputName} {vmOutDt}
// makeCurrentOutput {outputName}

// addCurrentOutput {outputName} /fs[0]/primdend1/AMPA_channel



check

  



reset       
reset

step {maxTime} -t

clearOutput {outputName}

// close files
quit
