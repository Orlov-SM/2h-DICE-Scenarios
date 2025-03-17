2h-DICE: A Heterogeneous Agent Extension of DICE
This repository contains GAMS implementations of the 2h-DICE model, an extension of the DICE2013R model that incorporates heterogeneous agents: wage-dependent (WD) households and capital-owning (CO) households. The model builds on the Ramsey framework with a Cobb-Douglas production function, following the approach suggested by Mankiw (2000).

Files and Scenarios
The repository includes five GAMS files, each corresponding to a specific scenario:

**2h-DICE.gms – The baseline heterogeneous-agent DICE model with social planner optimization. The planner maximizes social welfare, distributing resources between CO and WD households.
CO_scenario.gms – A scenario where CO households optimize for their own welfare, setting m_t ≡ 0, meaning CO households bear none of the abatement costs.
CO_no_mitigation.gms – A scenario with no climate mitigation efforts, setting the mitigation control variable μ_t ≡ 0.
CO_with_transfers.gms – A model incorporating wealth transfers, where a fixed share τ of WD household income is transferred to CO households at each time step. These transfers increase CO household consumption but can also contribute to abatement.
CO_optimal_transfer.gms – A scenario where τ_t is optimized dynamically to ensure that WD household welfare does not fall below its level in the CO scenario.
CO_with_matching.gms -  A scenario implementing a matching mechanism for abatement costs, where m is fixed at different values between 1/3 and 3, reflecting how much additional abatement CO households contribute relative to WD households.

Dependencies
GAMS (General Algebraic Modeling System)

License
This code is released under the MIT License, allowing for broad reuse while maintaining attribution.
