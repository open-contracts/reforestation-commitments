# Reforestation Commitments

### Big picture

The market for voluntary carbon offsets has notorious credibility issues. Many offsets that are traded do not actually correspond to a unique reduction in emissions that could be transparently verified. The market for reforestation in particular has the problem that the offset emissions are calculated under the assumption that the reforested areas wont be deforested just a few years later. Unfortunately this assumption often fails, and the reforested areas are quickly deforested again, once the carbon offsets were sold.

So how can you commit money towards reforestation upfront, while guaranteeing that it will only become available to the forest owner if they maintain the reforested areas?

You guessed it: via an Open Contract! This example contract uses [NASA sattelite data](https://lpdaac.usgs.gov/products/mod13c1v006/) to measure the size of the rainforest in Brazil. Anyone can commit to pay some amount each year for every square kilometer that the rainforest adds relative to its 2021 size. 

We don't know who owns a given part of the rainforest, so we gave the right to claim the reforestation reward to the Twitter Account of [Brazil's Government](https://twitter.com/govbrazil). If the rainforest in some future year is larger than it was in 2021, they would be able to claim their reward by [proving](https://opencontracts.io/#/open-contracts/pay-a-twitter) they control the verified `@govbrazil` Twitter account as well as an Ethereum address. The government can then simply commit (under local law or a similar Open Contract) to passing on the incentives to whoever successfully reforests a given piece of the rainforest.

### Contract

Anyone can commit ETH to the reforestation of the rainforest by calling the `deposit` function, and specifying how much they value one additional square kilometer of rainforest per year. This value gets added to a list called `valuesPerKm2PerYear`, and the total amount deposited is added to a list called `deposits`. Every year, the Brazilian government can call `measureRainforest`, to claim a reforestation reward that is computed as follows:
```
reward = sum(valuesPerKm2PerYear) * km2AddedOver2021
```
They can withdraw their reward via the [Pay-A-Twitter-Account](https://dapp.opencontracts.io/#/open-contracts/pay-a-twitter-account) contract. Afterwards, the amounts in `valuesPerKm2PerYear` are subtracted from their respective `deposits`, and get removed from `valuesPerKm2PerYear` if their deposits run out.
