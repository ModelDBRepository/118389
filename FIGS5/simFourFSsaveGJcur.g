// 
// This genesis script runs four FS neurons, and allows different channel 
// parameters to be changed for two of the neurons, the other two neurons 
// are kept as normal.
//
// A1, A2, B1, B2
// A1 and A2 are identical (and modified from default)
// B1 and B2 are identical (and kept at default values)
//
//
// Johannes Hjorth, March 2009
// hjorth@nada.kth.se
//

echo "### Start of script ###################"
echo "Johannes Hjorth (hjorth@nada.kth.se)"
echo "Last updated: March 2009"
echo "  "


if({argc} != 1)
  echo "This script requires a parameter file specified"
  echo "genesis simFourFSsaveGJcur myparams.txt"
  quit
end

// 
str parFile = "INDATA/"@{getarg {argv} -arg 1}

openfile {parFile} r

str outputName = {readfile {parFile}}
float maxTime  = {readfile {parFile}}
int numCells   = {readfile {parFile}}

echo "Simulating "{numCells}" FS neurons for "{maxTime}" seconds"
echo "Writing output to "{outputName}

// Read Sobol parametervariations
str sobolPars  = {readfile {parFile} -linemode}

float NaCondMod         = {getarg {arglist {sobolPars}} -arg 1}
float ACondMod          = {getarg {arglist {sobolPars}} -arg 2}
float K3132CondMod      = {getarg {arglist {sobolPars}} -arg 3}
float K13CondMod        = {getarg {arglist {sobolPars}} -arg 4}
float mNaTauSobolMod    = {getarg {arglist {sobolPars}} -arg 5}
float hNaTauSobolMod    = {getarg {arglist {sobolPars}} -arg 6}
float mATauSobolMod     = {getarg {arglist {sobolPars}} -arg 7}
float hATauSobolMod     = {getarg {arglist {sobolPars}} -arg 8}
float mK3132TauSobolMod = {getarg {arglist {sobolPars}} -arg 9}
float mK13TauSobolMod   = {getarg {arglist {sobolPars}} -arg 10}

// Simulation time and time steps
float spikeoutdt=1e-3
float vmOutDt=1e-4
float simDt=1e-5 //1e-6 needed for voltage clamp

// Number of synapse sites

int nAMPA = 127 // per cell
int nGABA = 93

//read in functions for creating and running simulations
include protodefsMOD
include fsInputFromFile
include fsSomaOutput

//setclocks
setclock 1 {vmOutDt}
setclock 0 {simDt}

// Use the SPRNG random number generator
setrand -sprng

// Read in and connect synaptic input
// Previously I read in insignal and noise separately, here they are
// in the same file (optimisation).

int cellCtr

echo "!! Neurons with index i = 2*n, share input with neuron i = 2*n + 1"

for(cellCtr = 0; cellCtr < numCells/2; cellCtr = cellCtr + 1)

  readInputFromFile "AMPAinsignal_"{cellCtr}"_" \
                    "INDATA/AMPAinsignal_"{{cellCtr}+1}"_" \
                    {nAMPA}

  readInputFromFile "GABAinsignal_"{cellCtr}"_" \
                    "INDATA/GABAinsignal_"{{cellCtr}+1}"_" \
                    {nGABA}

end

// OBS, input shared between neurons (see above), or code below

for(cellCtr = 0; cellCtr < {numCells}; cellCtr = cellCtr + 1)
  connectFsInsignalToCell /fs[{cellCtr}] "/input/AMPAinsignal_"{cellCtr/2}"_" "AMPA"
  connectFsInsignalToCell /fs[{cellCtr}] "/input/GABAinsignal_"{cellCtr/2}"_" "GABA"
end

// Read location of gap junctions from parameter file

int numGaps = {readfile {parFile}}
int gapCtr

// Set up output

makeOutput "/fs" {outputName} {vmOutDt}

// Obs we also save the compartments next to GJ, see below.

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

      // Save the voltage so we can calculate the current later
      addCompartmentOutput {gapSrc} {outputName}
      addCompartmentOutput {gapDest} {outputName}

    else
      echo "WARNING: gapRes: "{gapRes}" ohm, no gap junction created"
    end
end

closefile {parFile}

str chanName

foreach chanName ({el /fs[]/#/Na_channel_MOD} {el /fs[]/#/#/Na_channel_MOD})
  echo "Na: "{chanName}" * "{NaCondMod}
  setfield {chanName} Gbar {{getfield {chanName} Gbar} * {NaCondMod}}
end

foreach chanName ({el /fs[]/#/A_channel_MOD} {el /fs[]/#/#/A_channel_MOD})
  echo "A: "{chanName}" * "{ACondMod}
  setfield {chanName} Gbar {{getfield {chanName} Gbar} * {ACondMod}}
end

foreach chanName ({el /fs[]/#/K3132_channel_MOD} {el /fs[]/#/#/K3132_channel_MOD})
  echo "K3132: "{chanName}" * "{K3132CondMod}
  setfield {chanName} Gbar {{getfield {chanName} Gbar} * {K3132CondMod}}
end

foreach chanName ({el /fs[]/#/K13_channel_MOD} {el /fs[]/#/#/K13_channel_MOD})
  echo "K13: "{chanName}" * "{K13CondMod}
  setfield {chanName} Gbar {{getfield {chanName} Gbar} * {K13CondMod}}
end






check
  

reset       
reset

step {maxTime} -t

clearOutput {outputName}

// close files
quit
