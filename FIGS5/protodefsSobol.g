//
// protodefs.g - Includes the functions needed and creates the library
//               structure that contains prototypes for all objects used
//
// Modified june 2005 by Johannes Hjorth, hjorth@nada.kth.se
// Updated: 2009, feb.
//
//

include compartments
include channelsSobol

create neutral /library
disable /library

ce /library

make_cylind_compartment

make_K3132_channel
make_K13_channel
make_A_channel
// make_AMPA_channel
// make_GABA_channel
make_Na_channel

ce /

int iNeuron

for(iNeuron = 0; iNeuron < numCells; iNeuron = iNeuron + 1)
  create neutral /library/cell{iNeuron+1}
  disable /library/cell{iNeuron+1}

  readcell INDATA/FSmorph-{{iNeuron}+1}.p /fs[{iNeuron}]
end

