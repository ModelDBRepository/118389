//
// protodefs.g - Includes the functions needed and creates the library
//               structure that contains prototypes for all objects used
//
// Modified june 2005 by Johannes Hjorth, hjorth@nada.kth.se
// 
//
//

include errorHandler
include compartments
include channels

include cellMorphology

// Old files, used for single cell simulations earlier
//
//   include insignalGenerator
//   include insignalManager
//   include correlatedCellNoise

include fsNeuron
include fsConnect
include fsInsignalGenerator
include fsNoiseGenerator

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
