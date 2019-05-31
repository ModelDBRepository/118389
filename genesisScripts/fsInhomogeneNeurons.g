//////////////////////////////////////////////////////////////////////////
//
// Johannes Hjorth, Mars 2007
// hjorth@nada.kth.se
//
// fsNeuron.g - Creates fast spiking neurons from p-files
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



function makeFsInhomogeneNeuron(pFile, neuronPath)

  str pFile
  str neuronPath

  echo "Reading from "{pFile}" and creating "{neuronPath}

  readcell {pFile} {neuronPath}

// Number of inputs to each compartmenttype

  addfield {neuronPath} somaDensityAMPA
  addfield {neuronPath} somaDensityNMDA
  addfield {neuronPath} somaDensityGABA

  addfield {neuronPath} primDensityAMPA
  addfield {neuronPath} primDensityNMDA
  addfield {neuronPath} primDensityGABA

  addfield {neuronPath} secDensityAMPA
  addfield {neuronPath} secDensityNMDA
  addfield {neuronPath} secDensityGABA

  addfield {neuronPath} tertDensityAMPA
  addfield {neuronPath} tertDensityNMDA
  addfield {neuronPath} tertDensityGABA

// Weights of each input

  addfield {neuronPath} somaWeightAMPA
  addfield {neuronPath} somaWeightNMDA
  addfield {neuronPath} somaWeightGABA

  addfield {neuronPath} primWeightAMPA
  addfield {neuronPath} primWeightNMDA
  addfield {neuronPath} primWeightGABA

  addfield {neuronPath} secWeightAMPA
  addfield {neuronPath} secWeightNMDA
  addfield {neuronPath} secWeightGABA

  addfield {neuronPath} tertWeightAMPA
  addfield {neuronPath} tertWeightNMDA
  addfield {neuronPath} tertWeightGABA


// Set default values for densities

  setfield {neuronPath} somaDensityAMPA 1
  setfield {neuronPath} somaDensityNMDA 1
  setfield {neuronPath} somaDensityGABA 3

  setfield {neuronPath} primDensityAMPA 1
  setfield {neuronPath} primDensityNMDA 1
  setfield {neuronPath} primDensityGABA 3

  setfield {neuronPath} secDensityAMPA  1
  setfield {neuronPath} secDensityNMDA  1
  setfield {neuronPath} secDensityGABA  3

  setfield {neuronPath} tertDensityAMPA 1
  setfield {neuronPath} tertDensityNMDA 1
  setfield {neuronPath} tertDensityGABA 0


// Set default values for synapse weights

  setfield {neuronPath} somaWeightAMPA 1.0
  setfield {neuronPath} somaWeightNMDA 1.0
  setfield {neuronPath} somaWeightGABA 1.0

  setfield {neuronPath} primWeightAMPA 1.0
  setfield {neuronPath} primWeightNMDA 1.0
  setfield {neuronPath} primWeightGABA 1.0

  setfield {neuronPath} secWeightAMPA  1.0
  setfield {neuronPath} secWeightNMDA  1.0
  setfield {neuronPath} secWeightGABA  1.0

  setfield {neuronPath} tertWeightAMPA 1.0
  setfield {neuronPath} tertWeightNMDA 1.0
  setfield {neuronPath} tertWeightGABA 1.0

end

