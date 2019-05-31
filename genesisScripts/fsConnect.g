//
// fsConnect.g - Functions to connect two fs-neurons through gap-junctions
//
// Johannes Hjorth, July 2005
// hjorth@nada.kth.se
//
// Updated by Lennart Hedlund (hedlund@kth.se), July 2006
// Added reciprocalGABAinhib
//

//////////////////////////////////////////////////////////////////////////////
//
// Connects two compartments by gapjunction
//
//////////////////////////////////////////////////////////////////////////////


function connectGap(compA, compB, resistance)

    str compA
    str compB
    float resistance

    // Gap junctions go both ways...
    addmsg {compA} {compB} RAXIAL {resistance} Vm
    addmsg {compB} {compA} RAXIAL {resistance} Vm
end


//////////////////////////////////////////////////////////////////////////////
//
// Connects two somas by GABA
//
//////////////////////////////////////////////////////////////////////////////


function reciprocalGABAinhib(cellA, cellB, delay, weight)

    str cellA
    str cellB
    float delay

    // create spike train 
    if(!{exists {cellB}/spikes})
      create spikegen {cellB}/spikes
      setfield {cellB}/spikes output_amp 1 thresh 0.0 abs_refract 0.001
    end

    addmsg {cellA} {cellB}/spikes INPUT Vm

    if({getmsg {cellB}/spikes -out -count} < 1)
      addmsg {cellB}/spikes {cellB}/GABA_channel SPIKE
    end

    setfield {cellB}/GABA_channel synapse[0].weight {weight} synapse[0].delay {delay}
end

//////////////////////////////////////////////////////////////////////////////
//
// Connects two random compartments of typeA in cellA and 
// typeB in cellB with a gapjunction.
//
//
// Ex. To connect a random primary dendrite in cell 0 with a 
//     random secondary dendrite in cell 1, resistance 3e7 ohm
// 
//     randomDendGap /fs[0] prim /fs[1] sec 3e7
//
// Valid types: soma, prim, sec, tert
//
//////////////////////////////////////////////////////////////////////////////


function randomDendGap(cellA, typeA, cellB, typeB, resistance)

    str cellA, typeA
    str cellB, typeB
    float resistance

    int numA = {getarg {el {cellA}/{typeA}#} \
                       {el {cellA}/{typeA}#/{typeA}#} \
                       -count}

    int numB = {getarg {el {cellB}/{typeB}#} \
                       {el {cellB}/{typeB}#/{typeB}#} \
                       -count}

    int idxA = {rand 1 {numA}}
    int idxB = {rand 1 {numB}}

    str pathA = {getarg {el {cellA}/{typeA}#} \
                        {el {cellA}/{typeA}#/{typeA}#} \
                        -arg {idxA}}

    str pathB = {getarg {el {cellB}/{typeB}#} \
                        {el {cellB}/{typeB}#/{typeB}#} \
                        -arg {idxB}}

    echo "Connecting "{pathA}" with "{pathB}" using gapjunction (res="{resistance}" ohm)"

    // Gap junctions go both ways...
    addmsg {pathA} {pathB} RAXIAL {resistance} Vm
    addmsg {pathB} {pathA} RAXIAL {resistance} Vm

end


//////////////////////////////////////////////////////////////////////////////

function clearGap(compA, compB)

  str compA, compB
  int msgId

  echo "Removing gapjuncton "{compA}" <-> "{compB}

  msgId = {getmsg {compA} -in -find {compB} RAXIAL}
  deletemsg {compA} {msgId} -in

  msgId = {getmsg {compB} -in -find {compA} RAXIAL}
  deletemsg {compB} {msgId} -in  

end


//////////////////////////////////////////////////////////////////////////////
//
// makeSpiking adds a spikegen object to the cell if needed
//
//
//////////////////////////////////////////////////////////////////////////////


function makeSpiking(cellPath, asbRefract)

    str cellPath
    float absRefract

    str somaPath = {cellPath}@"/soma"
    str spikePath = {somaPath}@"/spike"

    if(!{exists {somaPath}})
        error "The object "@{somaPAth}@" does not exist!"
    end

    if(!{exists {spikePath}})
        create spikegen {spikePath}
        setfield {spikePath} thresh 0 abs_refract {absRefract} output_amp 1
        addmsg {somaPath} {spikePath} INPUT Vm
    else
        echo "makeSpiking: Spike object already exists: "{spikePath}", ignoring"
    end
end


//////////////////////////////////////////////////////////////////////////////
//
// connectGABA connects the sourceCell with destCompartment 
// using weight and delay.
//
// A spikegen object must be created first in sourceCell using makeSpiking
//
//////////////////////////////////////////////////////////////////////////////


function connectGABA(sourceCell, destCompartment, weight, delay)

    str sourceCell
    str destCompartment
    float weight
    float delay

    int i = 0
    int inMsg = 0
    int inSpikes = 0

    str sourceSpike = {sourceCell}@"/soma/spike"
    str destChannel = {destCompartment}@"/GABA_channel"

    addmsg {sourceSpike} {destChannel} SPIKE

    inMsg = {getmsg {destChannel} -in -count}

    for(i = 0; i < inMsg; i = i + 1)
        if({{strcmp SPIKE {getmsg {destChannel} -type {i}}} == 0})
            inSpikes = {{inSpikes} + 1}
        end
    end

    
    int msgIdx = {{inSpikes} - 1} //First element is zero

    setfield {destChannel} synapse[{msgIdx}].weight {weight} \
                           synapse[{msgIdx}].delay {delay}

end


