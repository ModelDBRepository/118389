


function makeCurrentOutput(outputName)

  str outputName

  echo "makeCurrentOutput: This assumes that clock 1 is used for plotting"
  
  str outputObj = "/output/"@{outputName}@"cur"
  str outputFile = "UTDATA/"@{outputName}@"-current.data"

  create asc_file {outputObj}
  setfield {outputObj} leave_open 1 append 0 notime 0 filename {outputFile}
  useclock {outputObj} 1

end

function addCurrentOutput(outputName, objectPath)

  str outputName
  str objectPath

  str outputObj = "/output/"@{outputName}@"cur"

  echo "Sending "{objectPath}"'s current to "{outputName}
  addmsg {objectPath} {outputObj} SAVE Ik

end
