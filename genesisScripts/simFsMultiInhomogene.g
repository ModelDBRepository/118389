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
//

echo "### Start of script ###################"
echo "Johannes Hjorth (hjorth@nada.kth.se)"
echo "Last updated: Mars 2007"
echo " "

// Read information about input data

str indataInfoFile = "INDATA/inputInfo.txt"
openfile {indataInfoFile} r

str indataType     = {readfile {indataInfoFile}}
float corrRudolph  = {readfile {indataInfoFile}}
float upFreq       = {readfile {indataInfoFile}}
float noiseFreq    = {readfile {indataInfoFile}}
float maxInputTime = {readfile {indataInfoFile}}
int allowVar       = {readfile {indataInfoFile}}
int randSeed       = {readfile {indataInfoFile}}
int numCellsInput  = {readfile {indataInfoFile}}
// Next data item is the gamma-shape of the curve, not used.

closefile {indataInfoFile}


// Read maxTime from parameter file!

str parFile = "INDATA/parameters.txt"
openfile {parFile} r

str outputName = {readfile {parFile}}
float maxTime  = {readfile {parFile}}
int numCells   = {readfile {parFile}}

if({numCells} != {numCellsInput})
  echo "Number of cells: "{numCells}, "Input generated for : "{numCellsInput}
  echo "Not enough input generated"
  quit
end

echo "Simulating "{numCells}" FS neurons for "{maxTime}" seconds"
echo "Indata used randSeed: "{randSeed}
echo "Writing output to "{outputName}

if({maxTime} > {maxInputTime})
  echo "ERROR: Only have input for "{maxInputTime}" seconds"
  quit
end

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
randseed {{randSeed} + 4711}

// Create neuron -- We use non-identical neurons, dont copy!
// echo "Creating "{numCells}" FS neurons"
// copyFsNeuron "/fs" {numCells}

// Connect input

int cellCtr

for(cellCtr = 0; cellCtr < numCells; cellCtr = cellCtr + 1)

  readInputFromFile "AMPAinsignal_"{cellCtr}"_" \
                    "INDATA/AMPAinsignal_"{{cellCtr}+1}"_" \
                    {nAMPA}

  readInputFromFile "GABAinsignal_"{cellCtr}"_" \
                    "INDATA/GABAinsignal_"{{cellCtr}+1}"_" \
                    {nGABA}

  readInputFromFile "AMPAnoise_"{cellCtr}"_" \
                    "INDATA/AMPAnoise_"{{cellCtr}+1}"_" \
                    {nAMPA}

  readInputFromFile "GABAnoise_"{cellCtr}"_" \
                    "INDATA/GABAnoise_"{{cellCtr}+1}"_" \
                    {nGABA}

end

for(cellCtr = 0; cellCtr < {numCells}; cellCtr = cellCtr + 1)
  connectFsInsignalToCell /fs[{cellCtr}] "/input/AMPAinsignal_"{cellCtr}"_" "AMPA"
  connectFsInsignalToCell /fs[{cellCtr}] "/input/GABAinsignal_"{cellCtr}"_" "GABA"
  connectFsInsignalToCell /fs[{cellCtr}] "/input/AMPAnoise_"{cellCtr}"_" "AMPA"
  connectFsInsignalToCell /fs[{cellCtr}] "/input/GABAnoise_"{cellCtr}"_" "GABA"
end

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

closefile {parFile}

check

  
makeOutput "/fs" {outputName} {vmOutDt}

reset       
reset

step {maxTime} -t

clearOutput {outputName}

// close files
quit
