-- nuke_rising_grey_smoke_spawner
-- nuke_rising_grey_smoke_sub
-- nuke_rising_orange_smoke_spawner
-- nuke_rising_orange_smoke_sub

return {
  ["nuke_rising_grey_smoke_sub"] = {
    rocks = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        airdrag            = 0.97,
        colormap           = [[0.0 0.0 0.0 0.01
                               0.8 0.8 0.8 1.00
                               0.8 0.8 0.8 1.00
                               0.8 0.8 0.8 1.00
                               0.8 0.8 0.8 1.00
                               0.8 0.8 0.8 1.00
                               0.8 0.8 0.8 1.00
                               0.0 0.0 0.0 0.01]],
        directional        = false,
        emitrot            = 120,
        emitrotspread      = 10,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0.001 r-0.002, 0.01 r-0.02, 0.001 r-0.002]],
        numparticles       = 1,
        particlelife       = 150,
        particlelifespread = 150,
        particlesize       = 170,
        particlesizespread = 170,
        particlespeed      = 5,
        particlespeedspread = 5,
        pos                = [[0, 0, 0]],
        sizegrowth         = 0.05,
        sizemod            = 1.0,
        texture            = [[smokesmall]],
      },
    },
  },

  ["nuke_rising_orange_smoke_sub"] = {
    rocks = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        airdrag            = 0.97,
        colormap           = [[0.0 0.0 0.0 0.01
                               1.0 0.6 0.0 1.00
                               1.0 0.7 0.3 1.00
                               1.0 0.7 0.5 1.00
                               1.0 0.8 0.6 1.00
                               0.8 0.8 0.8 1.00
                               0.0 0.0 0.0 0.01]],
        directional        = false,
        emitrot            = 90,
        emitrotspread      = 10,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0.001 r-0.002, 0.01 r-0.02, 0.001 r-0.002]],
        numparticles       = 1,
        particlelife       = 150,
        particlelifespread = 150,
        particlesize       = 90,
        particlesizespread = 90,
        particlespeed      = 5,
        particlespeedspread = 5,
        pos                = [[0, 0, 0]],
        sizegrowth         = 0.05,
        sizemod            = 1.0,
        texture            = [[smokesmall]],
      },
    },
  },

  ["nuke_rising_orange_smoke_spawner"] = {
    nw = {
      air                = true,
      class              = [[CExpGenSpawner]],
      count              = 150,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        delay              = [[0  i4]],
        explosiongenerator = [[custom:nuke_rising_orange_smoke_sub]],
        pos                = [[20 r40, i20, -20 r40]],
      },
    },
  },

  ["nuke_rising_grey_smoke_spawner"] = {
    nw = {
      air                = true,
      class              = [[CExpGenSpawner]],
      count              = 150,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        delay              = [[0  i4]],
        explosiongenerator = [[custom:nuke_rising_grey_smoke_sub]],
        pos                = [[20 r40, i20, -20 r40]],
      },
    },
  },

}

