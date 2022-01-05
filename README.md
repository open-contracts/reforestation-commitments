# Reforestation Commitments

What if carbon credits actually represented a binding commitment to emissions reductions?
Let's find out! This contract allows anyone to deposit USDC tokens, which can only be claimed in small chunks, once a month by one of two actors:
  1. The [Government of Brazil](https://twitter.com/govbrazil) by [making an appropriate tweet](https://opencontracts.io/#/open-contracts/pay-a-twitter), but only as much as `price*(forest_area(current_month)-forest_area(Jan_01_2021))`
  2. The Depositor, but only as much as `price*(forest_area(Jan_01_2021)-forest_area(current_month))`

Why the President and not farmers? Because the property rights for the Brazilian rainforest generally [seem to be assigned to the Brazilian state](https://spectator.clingendael.org/en/publication/who-owns-brazilian-rainforest), and it seems difficult to verify that a given person actually owns (and is able to enforce) the property rights to a given piece of the rainforest.

TODOs: 
- Improve Mechanism Design, to the point where we can compute e.g. expected CO2 abatement per USDC invested and actually sell carbon credits
- Integrate 3D lidar measurements of forest structure from [GEDI ISS Module](https://en.wikipedia.org/wiki/Global_Ecosystem_Dynamics_Investigation)
