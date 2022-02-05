# Green Electricity Carbon Credit

The whole reforestation thing sounds cool initially, but it's plagued by difficulties
- what's the right counterfactual to use if no money was spent? (in CA, growers often "legally cheat" by assuming >80% deforestation!)
- how do you guarantee the funding is there when needed, but conditional on succeeding at reliably avoiding co2
- who owns which part of the forest and can claim responsibility for improvements

Solution: Let's look at ppls energy bills instead!
- website login credentials = ownership
- cost for switch perfectly measurable (what is the price difference to cover for green energy)
- causal effect of incentive payment measurable (require registration first, proving you old provider, then provide regular evidence of green bills and get covered the price difference) and easily convertible into co2 equivalents
- result: super high quality carbon credits, super easy to implent

Implementation:
 - users generate proof that they reduced X tCO² by paying Y $ extra
 - offset buyers commit they are willing to pay up to Z $ per tCO², and can only increase Z afterwards.
 - users can claim min(Y/X,Z)*X $ payment from the commitment by deleting X
