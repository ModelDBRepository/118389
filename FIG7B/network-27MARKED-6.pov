#include "colors.inc"

camera {
  location <4.00, 3.00, -7.00>
  look_at <0.00,0.00,0.00>

}
#declare FSneuron =
sphere { <0.00, 0.00, -1000.00>, 0.10
  pigment { color rgb<1.00, 1.00, 1.00> }

  finish {
    phong 1
  }
}
#declare FSneuronMARKED =
sphere { <0.00, 0.00, -1000.00>, 0.17
  pigment { color rgb<0.10, 0.10, 0.10> }

  finish {
    phong 1
  }
}
light_source { <17.00, 95.00, -35.00> color White}

light_source { <-16.00, 20.00, 50.00> color White}

object {FSneuron}
object { FSneuron
  translate <-2.00, -2.00, 998.00>
}

object { FSneuron
  translate <-2.00, -1.00, 998.00>
}

object { FSneuron
  translate <-2.00, 0.00, 998.00>
}

object { FSneuron
  translate <-2.00, 1.00, 998.00>
}

object { FSneuron
  translate <-2.00, 2.00, 998.00>
}

object { FSneuron
  translate <-1.00, -2.00, 998.00>
}

object { FSneuron
  translate <-1.00, -1.00, 998.00>
}

object { FSneuron
  translate <-1.00, 0.00, 998.00>
}

object { FSneuron
  translate <-1.00, 1.00, 998.00>
}

object { FSneuron
  translate <-1.00, 2.00, 998.00>
}

object { FSneuron
  translate <0.00, -2.00, 998.00>
}

object { FSneuron
  translate <0.00, -1.00, 998.00>
}

object { FSneuron
  translate <0.00, 0.00, 998.00>
}

object { FSneuron
  translate <0.00, 1.00, 998.00>
}

object { FSneuron
  translate <0.00, 2.00, 998.00>
}

object { FSneuron
  translate <1.00, -2.00, 998.00>
}

object { FSneuron
  translate <1.00, -1.00, 998.00>
}

object { FSneuron
  translate <1.00, 0.00, 998.00>
}

object { FSneuron
  translate <1.00, 1.00, 998.00>
}

object { FSneuron
  translate <1.00, 2.00, 998.00>
}

object { FSneuron
  translate <2.00, -2.00, 998.00>
}

object { FSneuron
  translate <2.00, -1.00, 998.00>
}

object { FSneuron
  translate <2.00, 0.00, 998.00>
}

object { FSneuron
  translate <2.00, 1.00, 998.00>
}

object { FSneuron
  translate <2.00, 2.00, 998.00>
}

object { FSneuron
  translate <-2.00, -2.00, 999.00>
}

object { FSneuron
  translate <-2.00, -1.00, 999.00>
}

object { FSneuron
  translate <-2.00, 0.00, 999.00>
}

object { FSneuron
  translate <-2.00, 1.00, 999.00>
}

object { FSneuron
  translate <-2.00, 2.00, 999.00>
}

object { FSneuron
  translate <-1.00, -2.00, 999.00>
}

object { FSneuronMARKED
  translate <-1.00, -1.00, 999.00>
}

object { FSneuronMARKED
  translate <-1.00, 0.00, 999.00>
}

object { FSneuronMARKED
  translate <-1.00, 1.00, 999.00>
}

object { FSneuron
  translate <-1.00, 2.00, 999.00>
}

object { FSneuron
  translate <0.00, -2.00, 999.00>
}

object { FSneuronMARKED
  translate <0.00, -1.00, 999.00>
}

object { FSneuronMARKED
  translate <0.00, 0.00, 999.00>
}

object { FSneuronMARKED
  translate <0.00, 1.00, 999.00>
}

object { FSneuron
  translate <0.00, 2.00, 999.00>
}

object { FSneuron
  translate <1.00, -2.00, 999.00>
}

object { FSneuronMARKED
  translate <1.00, -1.00, 999.00>
}

object { FSneuronMARKED
  translate <1.00, 0.00, 999.00>
}

object { FSneuronMARKED
  translate <1.00, 1.00, 999.00>
}

object { FSneuron
  translate <1.00, 2.00, 999.00>
}

object { FSneuron
  translate <2.00, -2.00, 999.00>
}

object { FSneuron
  translate <2.00, -1.00, 999.00>
}

object { FSneuron
  translate <2.00, 0.00, 999.00>
}

object { FSneuron
  translate <2.00, 1.00, 999.00>
}

object { FSneuron
  translate <2.00, 2.00, 999.00>
}

object { FSneuron
  translate <-2.00, -2.00, 1000.00>
}

object { FSneuron
  translate <-2.00, -1.00, 1000.00>
}

object { FSneuron
  translate <-2.00, 0.00, 1000.00>
}

object { FSneuron
  translate <-2.00, 1.00, 1000.00>
}

object { FSneuron
  translate <-2.00, 2.00, 1000.00>
}

object { FSneuron
  translate <-1.00, -2.00, 1000.00>
}

object { FSneuronMARKED
  translate <-1.00, -1.00, 1000.00>
}

object { FSneuronMARKED
  translate <-1.00, 0.00, 1000.00>
}

object { FSneuronMARKED
  translate <-1.00, 1.00, 1000.00>
}

object { FSneuron
  translate <-1.00, 2.00, 1000.00>
}

object { FSneuron
  translate <0.00, -2.00, 1000.00>
}

object { FSneuronMARKED
  translate <0.00, -1.00, 1000.00>
}

object { FSneuronMARKED
  translate <0.00, 0.00, 1000.00>
}

object { FSneuronMARKED
  translate <0.00, 1.00, 1000.00>
}

object { FSneuron
  translate <0.00, 2.00, 1000.00>
}

object { FSneuron
  translate <1.00, -2.00, 1000.00>
}

object { FSneuronMARKED
  translate <1.00, -1.00, 1000.00>
}

object { FSneuronMARKED
  translate <1.00, 0.00, 1000.00>
}

object { FSneuronMARKED
  translate <1.00, 1.00, 1000.00>
}

object { FSneuron
  translate <1.00, 2.00, 1000.00>
}

object { FSneuron
  translate <2.00, -2.00, 1000.00>
}

object { FSneuron
  translate <2.00, -1.00, 1000.00>
}

object { FSneuron
  translate <2.00, 0.00, 1000.00>
}

object { FSneuron
  translate <2.00, 1.00, 1000.00>
}

object { FSneuron
  translate <2.00, 2.00, 1000.00>
}

object { FSneuron
  translate <-2.00, -2.00, 1001.00>
}

object { FSneuron
  translate <-2.00, -1.00, 1001.00>
}

object { FSneuron
  translate <-2.00, 0.00, 1001.00>
}

object { FSneuron
  translate <-2.00, 1.00, 1001.00>
}

object { FSneuron
  translate <-2.00, 2.00, 1001.00>
}

object { FSneuron
  translate <-1.00, -2.00, 1001.00>
}

object { FSneuronMARKED
  translate <-1.00, -1.00, 1001.00>
}

object { FSneuronMARKED
  translate <-1.00, 0.00, 1001.00>
}

object { FSneuronMARKED
  translate <-1.00, 1.00, 1001.00>
}

object { FSneuron
  translate <-1.00, 2.00, 1001.00>
}

object { FSneuron
  translate <0.00, -2.00, 1001.00>
}

object { FSneuronMARKED
  translate <0.00, -1.00, 1001.00>
}

object { FSneuronMARKED
  translate <0.00, 0.00, 1001.00>
}

object { FSneuronMARKED
  translate <0.00, 1.00, 1001.00>
}

object { FSneuron
  translate <0.00, 2.00, 1001.00>
}

object { FSneuron
  translate <1.00, -2.00, 1001.00>
}

object { FSneuronMARKED
  translate <1.00, -1.00, 1001.00>
}

object { FSneuronMARKED
  translate <1.00, 0.00, 1001.00>
}

object { FSneuronMARKED
  translate <1.00, 1.00, 1001.00>
}

object { FSneuron
  translate <1.00, 2.00, 1001.00>
}

object { FSneuron
  translate <2.00, -2.00, 1001.00>
}

object { FSneuron
  translate <2.00, -1.00, 1001.00>
}

object { FSneuron
  translate <2.00, 0.00, 1001.00>
}

object { FSneuron
  translate <2.00, 1.00, 1001.00>
}

object { FSneuron
  translate <2.00, 2.00, 1001.00>
}

object { FSneuron
  translate <-2.00, -2.00, 1002.00>
}

object { FSneuron
  translate <-2.00, -1.00, 1002.00>
}

object { FSneuron
  translate <-2.00, 0.00, 1002.00>
}

object { FSneuron
  translate <-2.00, 1.00, 1002.00>
}

object { FSneuron
  translate <-2.00, 2.00, 1002.00>
}

object { FSneuron
  translate <-1.00, -2.00, 1002.00>
}

object { FSneuron
  translate <-1.00, -1.00, 1002.00>
}

object { FSneuron
  translate <-1.00, 0.00, 1002.00>
}

object { FSneuron
  translate <-1.00, 1.00, 1002.00>
}

object { FSneuron
  translate <-1.00, 2.00, 1002.00>
}

object { FSneuron
  translate <0.00, -2.00, 1002.00>
}

object { FSneuron
  translate <0.00, -1.00, 1002.00>
}

object { FSneuron
  translate <0.00, 0.00, 1002.00>
}

object { FSneuron
  translate <0.00, 1.00, 1002.00>
}

object { FSneuron
  translate <0.00, 2.00, 1002.00>
}

object { FSneuron
  translate <1.00, -2.00, 1002.00>
}

object { FSneuron
  translate <1.00, -1.00, 1002.00>
}

object { FSneuron
  translate <1.00, 0.00, 1002.00>
}

object { FSneuron
  translate <1.00, 1.00, 1002.00>
}

object { FSneuron
  translate <1.00, 2.00, 1002.00>
}

object { FSneuron
  translate <2.00, -2.00, 1002.00>
}

object { FSneuron
  translate <2.00, -1.00, 1002.00>
}

object { FSneuron
  translate <2.00, 0.00, 1002.00>
}

object { FSneuron
  translate <2.00, 1.00, 1002.00>
}

object { FSneuron
  translate <2.00, 2.00, 1002.00>
}

object {
  cylinder { <-2.00, -2.00, -1.00>, <-2.00, -2.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, 0.00, -2.00>, <-2.00, -1.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, -1.00, -2.00>, <-2.00, 0.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, 1.00, -2.00>, <-2.00, 0.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, 0.00, -2.00>, <-2.00, 1.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, 1.00, -2.00>, <-2.00, 1.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, 2.00, -2.00>, <-2.00, 2.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, -1.00, -2.00>, <-1.00, -2.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, -2.00, -2.00>, <-1.00, -2.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, 0.00, -2.00>, <-1.00, -1.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, -1.00, -2.00>, <-1.00, -1.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, -1.00, -2.00>, <-1.00, 0.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, 1.00, -2.00>, <-1.00, 1.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, 2.00, -2.00>, <-1.00, 2.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, -2.00, -2.00>, <0.00, -2.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, -2.00, -2.00>, <0.00, -2.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, -1.00, -2.00>, <0.00, -1.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, -1.00, -2.00>, <0.00, 0.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, 0.00, -2.00>, <0.00, 0.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, 1.00, -2.00>, <0.00, 1.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, 0.00, -2.00>, <0.00, 1.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, 1.00, -2.00>, <0.00, 1.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, 2.00, -1.00>, <0.00, 2.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, -2.00, -2.00>, <1.00, -2.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, -1.00, -2.00>, <1.00, -2.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, -2.00, -2.00>, <1.00, -2.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, -1.00, -1.00>, <1.00, -1.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, -1.00, -2.00>, <1.00, 0.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, 0.00, -2.00>, <1.00, 0.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, 0.00, -1.00>, <1.00, 0.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, 0.00, -2.00>, <1.00, 1.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, 2.00, -2.00>, <1.00, 1.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, 1.00, -2.00>, <1.00, 2.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, 0.00, -2.00>, <2.00, -1.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, -1.00, -1.00>, <2.00, -1.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, -1.00, -2.00>, <2.00, 0.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, 1.00, -2.00>, <2.00, 0.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, 0.00, -1.00>, <2.00, 0.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, 2.00, -2.00>, <2.00, 1.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, 2.00, -2.00>, <2.00, 2.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, 1.00, -2.00>, <2.00, 2.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, 2.00, -1.00>, <2.00, 2.00, -2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, -1.00, -1.00>, <-2.00, -1.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, -1.00, 0.00>, <-2.00, -1.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, 1.00, -1.00>, <-2.00, 0.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, 0.00, -1.00>, <-2.00, 0.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, 0.00, 0.00>, <-2.00, 0.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, 1.00, -2.00>, <-2.00, 1.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, 2.00, -1.00>, <-2.00, 1.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, 1.00, -1.00>, <-2.00, 1.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, 2.00, -2.00>, <-2.00, 2.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, 2.00, 0.00>, <-2.00, 2.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, -2.00, -2.00>, <-1.00, -2.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, -1.00, -1.00>, <-1.00, -2.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, -2.00, -1.00>, <-1.00, -2.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, -1.00, -1.00>, <-1.00, -1.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, -2.00, -1.00>, <-1.00, -1.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, -1.00, -1.00>, <-1.00, -1.00, -1.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, 0.00, -2.00>, <-1.00, 0.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, 0.00, -1.00>, <-1.00, 0.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, 1.00, -1.00>, <-1.00, 1.00, -1.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, 1.00, 0.00>, <-1.00, 1.00, -1.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, 2.00, -2.00>, <-1.00, 2.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, 2.00, -1.00>, <-1.00, 2.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, -1.00, -1.00>, <0.00, -2.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, -2.00, -1.00>, <0.00, -1.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, 0.00, -2.00>, <0.00, 0.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, 0.00, -1.00>, <0.00, 0.00, -1.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, -1.00, -1.00>, <0.00, 0.00, -1.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, 0.00, -1.00>, <0.00, 1.00, -1.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, 1.00, -1.00>, <0.00, 1.00, -1.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, 2.00, -2.00>, <0.00, 2.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, -2.00, -2.00>, <1.00, -2.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, -2.00, 0.00>, <1.00, -2.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, -1.00, -1.00>, <1.00, -1.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, -1.00, 0.00>, <1.00, -1.00, -1.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, 0.00, -2.00>, <1.00, 0.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, 0.00, -1.00>, <1.00, 0.00, -1.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, -1.00, -1.00>, <1.00, 0.00, -1.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, 1.00, -1.00>, <1.00, 0.00, -1.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, 0.00, -1.00>, <1.00, 0.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, 2.00, -1.00>, <1.00, 1.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, 1.00, -1.00>, <1.00, 1.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, -2.00, -1.00>, <2.00, -2.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, -1.00, -1.00>, <2.00, -2.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, -2.00, 0.00>, <2.00, -2.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, -1.00, -2.00>, <2.00, -1.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, -2.00, -1.00>, <2.00, -1.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, 0.00, -1.00>, <2.00, 0.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, 1.00, -1.00>, <2.00, 0.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, 0.00, 0.00>, <2.00, 0.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, 1.00, -2.00>, <2.00, 1.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, 1.00, -1.00>, <2.00, 1.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, 2.00, -1.00>, <2.00, 1.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, 2.00, -1.00>, <2.00, 2.00, -1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, -2.00, -1.00>, <-2.00, -2.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, -2.00, 1.00>, <-2.00, -2.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, -2.00, 0.00>, <-2.00, -1.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, 0.00, 0.00>, <-2.00, -1.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, -1.00, 0.00>, <-2.00, -1.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, -1.00, 1.00>, <-2.00, -1.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, 0.00, 0.00>, <-2.00, 0.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, 0.00, 1.00>, <-2.00, 0.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, 1.00, 0.00>, <-2.00, 2.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, 2.00, 0.00>, <-2.00, 2.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, 2.00, 1.00>, <-2.00, 2.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, -2.00, -1.00>, <-1.00, -2.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, -1.00, 0.00>, <-1.00, -2.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, -2.00, 0.00>, <-1.00, -2.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, -2.00, 1.00>, <-1.00, -2.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, -1.00, -1.00>, <-1.00, -1.00, 0.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, -1.00, 0.00>, <-1.00, -1.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, -2.00, 0.00>, <-1.00, -1.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, 0.00, 0.00>, <-1.00, -1.00, 0.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, 1.00, -1.00>, <-1.00, 1.00, 0.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, 1.00, 0.00>, <-1.00, 1.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, 0.00, 0.00>, <-1.00, 1.00, 0.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, 1.00, 1.00>, <-1.00, 1.00, 0.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, 2.00, -1.00>, <-1.00, 2.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, 2.00, 0.00>, <-1.00, 2.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, -1.00, 0.00>, <0.00, -2.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, -2.00, 0.00>, <0.00, -1.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, 0.00, 0.00>, <0.00, -1.00, 0.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, -1.00, 0.00>, <0.00, -1.00, 0.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, 0.00, -1.00>, <0.00, 0.00, 0.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, -1.00, 0.00>, <0.00, 0.00, 0.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, 1.00, 0.00>, <0.00, 0.00, 0.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, 0.00, 0.00>, <0.00, 0.00, 0.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, 0.00, 1.00>, <0.00, 0.00, 0.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, 1.00, -1.00>, <0.00, 1.00, 0.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, 1.00, 0.00>, <0.00, 1.00, 0.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, 0.00, 0.00>, <0.00, 1.00, 0.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, 2.00, 0.00>, <0.00, 1.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, 1.00, 1.00>, <0.00, 1.00, 0.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, 2.00, -1.00>, <0.00, 2.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, 2.00, 1.00>, <0.00, 2.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, -2.00, 0.00>, <1.00, -2.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, -2.00, 0.00>, <1.00, -2.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, -1.00, 0.00>, <1.00, -1.00, 0.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, -1.00, 0.00>, <1.00, -1.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, 0.00, -1.00>, <1.00, 0.00, 0.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, -1.00, 0.00>, <1.00, 0.00, 0.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, 0.00, 0.00>, <1.00, 0.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, 1.00, 0.00>, <1.00, 1.00, 0.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, 0.00, 0.00>, <1.00, 1.00, 0.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, 1.00, 1.00>, <1.00, 1.00, 0.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, 2.00, 0.00>, <1.00, 2.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, 1.00, 0.00>, <1.00, 2.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, 2.00, 0.00>, <1.00, 2.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, 2.00, 1.00>, <1.00, 2.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, -2.00, 0.00>, <2.00, -2.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, -2.00, 1.00>, <2.00, -2.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, -1.00, 1.00>, <2.00, -1.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, 1.00, 0.00>, <2.00, 0.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, 0.00, 1.00>, <2.00, 0.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, 1.00, -1.00>, <2.00, 1.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, 1.00, 0.00>, <2.00, 1.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, 2.00, 0.00>, <2.00, 1.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, 1.00, 1.00>, <2.00, 1.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, 2.00, 0.00>, <2.00, 2.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, 1.00, 0.00>, <2.00, 2.00, 0.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, -1.00, 1.00>, <-2.00, -2.00, 1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, 0.00, 1.00>, <-2.00, -1.00, 1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, 0.00, 0.00>, <-2.00, 0.00, 1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, 0.00, 1.00>, <-2.00, 0.00, 1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, 1.00, 1.00>, <-2.00, 2.00, 1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, 2.00, 1.00>, <-2.00, 2.00, 1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, -2.00, 0.00>, <-1.00, -2.00, 1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, -1.00, 0.00>, <-1.00, -1.00, 1.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, -1.00, 1.00>, <-1.00, -1.00, 1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, 0.00, 1.00>, <-1.00, -1.00, 1.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, -1.00, 1.00>, <-1.00, -1.00, 1.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, -1.00, 2.00>, <-1.00, -1.00, 1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, 0.00, 1.00>, <-1.00, 0.00, 1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, -1.00, 1.00>, <-1.00, 0.00, 1.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, 1.00, 0.00>, <-1.00, 1.00, 1.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, 0.00, 1.00>, <-1.00, 1.00, 1.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, 2.00, 1.00>, <-1.00, 1.00, 1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, 1.00, 1.00>, <-1.00, 1.00, 1.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, 2.00, 0.00>, <-1.00, 2.00, 1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, 2.00, 1.00>, <-1.00, 2.00, 1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, 2.00, 1.00>, <-1.00, 2.00, 1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, 2.00, 2.00>, <-1.00, 2.00, 1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, -1.00, 1.00>, <0.00, -2.00, 1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, -2.00, 2.00>, <0.00, -2.00, 1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, -1.00, 1.00>, <0.00, -1.00, 1.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, 0.00, 1.00>, <0.00, -1.00, 1.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, -1.00, 1.00>, <0.00, -1.00, 1.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, 1.00, 1.00>, <0.00, 0.00, 1.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, 0.00, 1.00>, <0.00, 0.00, 1.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, 0.00, 2.00>, <0.00, 0.00, 1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, 1.00, 1.00>, <0.00, 1.00, 1.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, 2.00, 1.00>, <0.00, 2.00, 1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, 2.00, 2.00>, <0.00, 2.00, 1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, -2.00, 0.00>, <1.00, -2.00, 1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, -2.00, 1.00>, <1.00, -2.00, 1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, -1.00, 1.00>, <1.00, -1.00, 1.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, -2.00, 1.00>, <1.00, -1.00, 1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, 0.00, 1.00>, <1.00, -1.00, 1.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, -1.00, 2.00>, <1.00, -1.00, 1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, 1.00, 0.00>, <1.00, 1.00, 1.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, 0.00, 1.00>, <1.00, 1.00, 1.00>, 0.03
    pigment { color rgb<0.20, 0.20, 0.20> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, 1.00, 1.00>, <1.00, 2.00, 1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, -2.00, 0.00>, <2.00, -2.00, 1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, -2.00, 2.00>, <2.00, -2.00, 1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, -1.00, 1.00>, <2.00, -1.00, 1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, 0.00, 1.00>, <2.00, -1.00, 1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, -1.00, 2.00>, <2.00, -1.00, 1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, 0.00, 2.00>, <2.00, 0.00, 1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, 1.00, 1.00>, <2.00, 1.00, 1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, 0.00, 1.00>, <2.00, 1.00, 1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, 2.00, 1.00>, <2.00, 1.00, 1.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, -2.00, 1.00>, <-2.00, -2.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, -2.00, 2.00>, <-2.00, -2.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, -1.00, 2.00>, <-2.00, 0.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, 1.00, 1.00>, <-2.00, 1.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, 2.00, 2.00>, <-2.00, 1.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, -1.00, 2.00>, <-1.00, -2.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, -1.00, 2.00>, <-1.00, -1.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, 0.00, 2.00>, <-1.00, 0.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, 1.00, 2.00>, <-1.00, 0.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, 1.00, 1.00>, <-1.00, 1.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-2.00, 1.00, 2.00>, <-1.00, 1.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, 0.00, 2.00>, <-1.00, 1.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, 2.00, 1.00>, <-1.00, 2.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, -2.00, 2.00>, <0.00, -2.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, -2.00, 2.00>, <0.00, -2.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, -2.00, 2.00>, <0.00, -1.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <-1.00, 0.00, 2.00>, <0.00, 0.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, 1.00, 2.00>, <0.00, 0.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, 0.00, 2.00>, <0.00, 0.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, 0.00, 2.00>, <0.00, 1.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, 1.00, 2.00>, <0.00, 2.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, 2.00, 2.00>, <0.00, 2.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, -2.00, 2.00>, <1.00, -2.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, -2.00, 2.00>, <1.00, -2.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, -1.00, 1.00>, <1.00, -1.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, 1.00, 2.00>, <1.00, 0.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, 0.00, 2.00>, <1.00, 0.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, 0.00, 2.00>, <1.00, 1.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, 2.00, 2.00>, <1.00, 1.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, 2.00, 1.00>, <1.00, 2.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <0.00, 2.00, 2.00>, <1.00, 2.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, -2.00, 1.00>, <2.00, -2.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, -2.00, 2.00>, <2.00, -2.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, -1.00, 2.00>, <2.00, -1.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, -1.00, 2.00>, <2.00, 0.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, 1.00, 2.00>, <2.00, 0.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, 1.00, 1.00>, <2.00, 1.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <1.00, 1.00, 2.00>, <2.00, 1.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
object {
  cylinder { <2.00, 1.00, 2.00>, <2.00, 2.00, 2.00>, 0.02
    pigment { color rgb<0.50, 0.50, 0.50> }

    finish {
      phong 1
    }
  }
}
