//////////////////////////////////////////////////////////////////////////
//
// Johannes Hjorth, june 2005
// hjorth@nada.kth.se
//
// fsNeuron.g - Creates a fast spiking neuron in the library
//
//////////////////////////////////////////////////////////////////////////
//
// makeFsNeuron -- Creates the library template for a FS-neuron 
// copyFsNeuron -- Makes multiple copies of the FS-neuron
//
// Example:
//   copyFsNeuron "/fs"  10
//
//////////////////////////////////////////////////////////////////////////


str fsLibraryPath = "/library/fs"


//////////////////////////////////////////////////////////////////////////

function makeFsNeuron

//  readcell fsMorphTEST.p {fsLibraryPath}
  readcell fsMorphology.p {fsLibraryPath}

// Number of inputs to each compartmenttype

  addfield {fsLibraryPath} somaDensityAMPA
  addfield {fsLibraryPath} somaDensityNMDA
  addfield {fsLibraryPath} somaDensityGABA

  addfield {fsLibraryPath} primDensityAMPA
  addfield {fsLibraryPath} primDensityNMDA
  addfield {fsLibraryPath} primDensityGABA

  addfield {fsLibraryPath} secDensityAMPA
  addfield {fsLibraryPath} secDensityNMDA
  addfield {fsLibraryPath} secDensityGABA

  addfield {fsLibraryPath} tertDensityAMPA
  addfield {fsLibraryPath} tertDensityNMDA
  addfield {fsLibraryPath} tertDensityGABA

// Weights of each input

  addfield {fsLibraryPath} somaWeightAMPA
  addfield {fsLibraryPath} somaWeightNMDA
  addfield {fsLibraryPath} somaWeightGABA

  addfield {fsLibraryPath} primWeightAMPA
  addfield {fsLibraryPath} primWeightNMDA
  addfield {fsLibraryPath} primWeightGABA

  addfield {fsLibraryPath} secWeightAMPA
  addfield {fsLibraryPath} secWeightNMDA
  addfield {fsLibraryPath} secWeightGABA

  addfield {fsLibraryPath} tertWeightAMPA
  addfield {fsLibraryPath} tertWeightNMDA
  addfield {fsLibraryPath} tertWeightGABA


// Set default values for densities

  setfield {fsLibraryPath} somaDensityAMPA 1
  setfield {fsLibraryPath} somaDensityNMDA 1
  setfield {fsLibraryPath} somaDensityGABA 3

  setfield {fsLibraryPath} primDensityAMPA 1
  setfield {fsLibraryPath} primDensityNMDA 1
  setfield {fsLibraryPath} primDensityGABA 3

  setfield {fsLibraryPath} secDensityAMPA  1
  setfield {fsLibraryPath} secDensityNMDA  1
  setfield {fsLibraryPath} secDensityGABA  3

  setfield {fsLibraryPath} tertDensityAMPA 1
  setfield {fsLibraryPath} tertDensityNMDA 1
  setfield {fsLibraryPath} tertDensityGABA 0


// Set default values for synapse weights

  setfield {fsLibraryPath} somaWeightAMPA 1.0
  setfield {fsLibraryPath} somaWeightNMDA 1.0
  setfield {fsLibraryPath} somaWeightGABA 1.0

  setfield {fsLibraryPath} primWeightAMPA 1.0
  setfield {fsLibraryPath} primWeightNMDA 1.0
  setfield {fsLibraryPath} primWeightGABA 1.0

  setfield {fsLibraryPath} secWeightAMPA  1.0
  setfield {fsLibraryPath} secWeightNMDA  1.0
  setfield {fsLibraryPath} secWeightGABA  1.0

  setfield {fsLibraryPath} tertWeightAMPA 1.0
  setfield {fsLibraryPath} tertWeightNMDA 1.0
  setfield {fsLibraryPath} tertWeightGABA 1.0

end

//////////////////////////////////////////////////////////////////////////

function copyFsNeuron(destination, number)

  str destination
  int number

  copy {fsLibraryPath} {destination}[0] -repeat {number}

end

//////////////////////////////////////////////////////////////////////////

function connectFsNeuron(pre, post)
  echo "Function not implemented yet. How to specify insynapse?"
end
