//
// protodefs.g - Includes the functions needed and creates the library
//               structure that contains prototypes for all objects used
//
// Modified june 2005 by Johannes Hjorth, hjorth@nada.kth.se
// 
//
//

include ../genesisScripts/errorHandler
include compartments
include ../genesisScripts/channels

include ../genesisScripts/cellMorphology

// Old files, used for single cell simulations earlier
//
//   include insignalGenerator
//   include insignalManager
//   include correlatedCellNoise

include ../genesisScripts/fsNeuron
include ../genesisScripts/fsConnect

create neutral /library
disable /library

ce /library

make_cylind_compartment

make_K3132_channel
make_K13_channel
make_A_channel
make_AMPA_channel
make_GABA_channel
make_Na_channel

makeFsNeuron

ce /
