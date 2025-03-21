$ontext
This is the DICE-2013R model, version DICE2013Rv2_102213_vanilla_v24b.gms, revised from April version.
The vanilla version includes only the optimal and baseline scenarios.
These are determined by setting the "ifopt" control at 1 (optimal) or 0 (baseline).
This version has write ("put") output but does not have subroutines ("include").
A full discussion is included in the "DICE 2013R Manual" on the web at dicemodel.net.
$offtext

$title        DICE-2013R October 2013

set        t  Time periods (5 years per period)                    /1*60/ 
          N        Number of different betta                            /1*30/;

parameters

**Time Step
        tstep    Years per Period                                    /5/

** If optimal control
        ifopt    Indicator where optimized is 1 and base is 0        /1/

** Preferences
        elasmu   Elasticity of marginal utility of consumption     /  1.45 /
        elasmu1   Elasticity of marginal utility of consumption worker     /  2.4452 /
        elasmu2   Elasticity of marginal utility of consumption producer     /  1.1894 /
        prstp    Initial rate of social time preference per year   / .015  /

** Population and technology
        gama     Capital elasticity in production function        /.300    /
        pop0     Initial world population (millions)              /6838    /
        beta_min     Minimal proportion of producers                   /0.25    /
        beta_max     Maximum proportion of producers                   /0.75    /
        betta     Maximum proportion of producers               
        q        Proportion of producers (multiply L by this number) /0.3227    /
        popadj   Growth rate to calibrate to 2050 pop projection  /0.134   /
        popasym  Asymptotic population (millions)                 /10500   /
        dk       Depreciation rate on capital (per year)          /.100    /
        q0       Initial world gross output (trill 2005 USD)      /63.69   /
        k0       Initial capital value (trill 2005 USD)           /135     /
        a0       Initial level of total factor productivity       /3.80    /
        ga0      Initial growth rate for TFP per 5 years          /0.079   /
        dela     Decline rate of TFP per 5 years                  /0.006   /

** Emissions parameters
        gsigma1  Initial growth of sigma (per year)                   /-0.01   /
        dsig     Decline rate of decarbonization (per period)         /-0.001  /
        eland0   Carbon emissions from land 2010 (GtCO2 per year)     / 3.3    /
        deland   Decline rate of land emissions (per period)          / .2     /
        e0       Industrial emissions 2010 (GtCO2 per year)           /33.61   /
        miu0     Initial emissions control rate for base case 2010    /.039    /

** Carbon cycle
* Initial Condition
        mat0   Initial Concentration in atmosphere 2010 (GtC)        /830.4   /
        mu0    Initial Concentration in upper strata 2010 (GtC)      /1527.   /
        ml0    Initial Concentration in lower strata 2010 (GtC)      /10010.  /
        mateq  Equilibrium concentration atmosphere  (GtC)           /588     /
        mueq   Equilibrium concentration in upper strata (GtC)       /1350    /
        mleq   Equilibrium concentration in lower strata (GtC)       /10000   /

* Flow paramaters
        b12      Carbon cycle transition matrix                      /.088   /
        b23      Carbon cycle transition matrix                      /0.00250/

* These are for declaration and are defined later
        b11      Carbon cycle transition matrix
        b21      Carbon cycle transition matrix
        b22      Carbon cycle transition matrix
        b32      Carbon cycle transition matrix
        b33      Carbon cycle transition matrix
        sig0     Carbon intensity 2010 (kgCO2 per output 2005 USD 2010)

** Climate model parameters
        t2xco2   Equilibrium temp impact (oC per doubling CO2)    / 2.9   /
        fex0     2010 forcings of non-CO2 GHG (Wm-2)              / 0.25  /
        fex1     2100 forcings of non-CO2 GHG (Wm-2)              / 0.70  /
        tocean0  Initial lower stratum temp change (C from 1900)  /.0068  /
        tatm0    Initial atmospheric temp change (C from 1900)    /0.80   /

        c10      Initial climate equation coefficient for upper level /0.098  /
        c1beta   Regression slope coefficient(SoA~Equil TSC)          /0.01243/

        c1       Climate equation coefficient for upper level     /0.098  /
        c3       Transfer coefficient upper to lower stratum      /0.088  /
        c4       Transfer coefficient for lower level             /0.025  /
        fco22x   Forcings of equilibrium CO2 doubling (Wm-2)      /3.8    /

** Climate damage parameters
        a10       Initial damage intercept                         /0       /
        a20       Initial damage quadratic term                    /0.00267 /
        a1        Damage intercept                                 /0       /
        a2        Damage quadratic term                            /0.00267 /
        a3        Damage exponent                                  /2.00    /

** Abatement cost
        expcost2  Exponent of control cost function               / 2.8  /
        pback     Cost of backstop 2005$ per tCO2 2010            / 344  /
        gback     Initial cost decline backstop cost per period   / .025 /
        limmiu    Upper limit on control rate after 2150          / 1.2  /
        tnopol    Period before which no emissions controls base  / 45   /
        cprice0   Initial base carbon price (2005$ per tCO2)      / 1.0  /
        gcprice   Growth rate of base carbon price per year       /.02   /

** Participation parameters
        periodfullpart Period at which have full participation           /21  /
        partfract2010  Fraction of emissions under control in 2010       / 1  /
        partfractfull  Fraction of emissions under control at full time  / 1  /

** Availability of fossil fuels
        fosslim        Maximum cumulative extraction fossil fuels (GtC) /6000/

** Scaling and inessential parameters
* Note that these are unnecessary for the calculations but are for convenience
        scale1      Multiplicative scaling coefficient              /0.016408662 /
        scale2      Additive scaling coefficient                    /-3855.106895/
;

* Program control variables
sets     tfirst(t), tlast(t), tearly(t), tlate(t);

PARAMETERS
        l(t)          Level of population and labor (workers)
        p(t)          Level of population and labor (producers)
        al(t)         Level of total factor productivity
        sigma(t)      CO2-equivalent-emissions output ratio
        rr(t)         Average utility social discount rate
        ga(t)         Growth rate of productivity from
        forcoth(t)    Exogenous forcing for other greenhouse gases
        gl(t)         Growth rate of labor
        gcost1        Growth of cost factor
        gsig(t)       Change in sigma (cumulative improvement of energy efficiency)
        etree(t)      Emissions from deforestation
        cost1(t)      Adjusted cost for backstop
        partfract(t)  Fraction of emissions in control regime
        lam           Climate model parameter
        gfacpop(t)    Growth factor population
        pbacktime(t)  Backstop price
        optlrsav      Optimal long-run savings rate used for transversality
        scc(t)        Social cost of carbon
        cpricebase(t) Carbon price in base case
        photel(t)     Carbon Price under no damages (Hotelling rent condition);

* Program control definitions
        tfirst(t) = yes$(t.val eq 1);
        tlast(t)  = yes$(t.val eq card(t));

* Parameters for long-run consistency of carbon cycle
        b11 = 1 - b12;
        b21 = b12*MATEQ/MUEQ;
        b22 = 1 - b21 - b23;
        b32 = b23*mueq/mleq;
        b33 = 1 - b32 ;

* Further definitions of parameters
        sig0 = e0/(q0*(1-miu0));
        lam = fco22x/ t2xco2;
        l("1") = pop0;
        loop(t, l(t+1)=l(t););
        loop(t, l(t+1)=l(t)*(popasym/L(t))**popadj ;);
        loop(t, p(t)=l(t)*q;);
        loop(t, l(t)=l(t)*(1-q););

        ga(t)=ga0*exp(-dela*5*((t.val-1)));
        al("1") = a0; loop(t, al(t+1)=al(t)/((1-ga(t))););

        gsig("1")=gsigma1; loop(t,gsig(t+1)=gsig(t)*((1+dsig)**tstep) ;);
        sigma("1")=sig0;   loop(t,sigma(t+1)=(sigma(t)*exp(gsig(t)*tstep)););

        pbacktime(t)=pback*(1-gback)**(t.val-1);
        cost1(t) = pbacktime(t)*sigma(t)/expcost2/1000;

        etree(t) = eland0*(1-deland)**(t.val-1);
        rr(t) = 1/((1+prstp)**(tstep*(t.val-1)));
        forcoth(t) = fex0+ (1/18)*(fex1-fex0)*(t.val-1)$(t.val lt 19)+ (fex1-fex0)$(t.val ge 19);
        optlrsav = (dk + .004)/(dk + .004*elasmu + prstp)*gama;

        partfract(t)$(ord(T)>periodfullpart) = partfractfull;
        partfract(t)$(ord(T)<periodfullpart+1) = partfract2010+(partfractfull-partfract2010)*(ord(t)-1)/periodfullpart;

        partfract("1")= partfract2010;

*Transient TSC Correction ("Speed of Adjustment Parameter")
        c1 =  c10 + c1beta*(t2xco2-2.9);

*Base Case      Carbon Price
        cpricebase(t)= cprice0*(1+gcprice)**(5*(t.val-1));

VARIABLES
        MIU(t)          Emission control rate GHGs
        FORC(t)         Increase in radiative forcing (watts per m2 from 1900)
        TATM(t)         Increase temperature of atmosphere (degrees C from 1900)
        TOCEAN(t)       Increase temperatureof lower oceans (degrees C from 1900)
        MAT(t)          Carbon concentration increase in atmosphere (GtC from 1750)
        MU(t)           Carbon concentration increase in shallow oceans (GtC from 1750)
        ML(t)           Carbon concentration increase in lower oceans (GtC from 1750)
        E(t)            Total CO2 emissions (GtCO2 per year)
        EIND(t)         Industrial emissions (GtCO2 per year)
        C_W(t)          Consumption (trillions 2005 US dollars per year)
        C_P(t)          Consumption (trillions 2005 US dollars per year)
        K(t)            Capital stock (trillions 2005 US dollars)
        CPC_W(t)        Per capita consumption (thousands 2005 USD per year)
        CPC_P(t)        Per capita consumption (thousands 2005 USD per year)
        I(t)            Investment (trillions 2005 USD per year)
        S(t)            Gross savings rate as fraction of gross world product
        RI(t)           Real interest rate (per annum)
        YGROSS(t)       Gross world product GROSS of abatement and damages (trillions 2005 USD per year)
*        TAXCOST(t)      Amount of taxes
*        B(t)            Bonds
        YNET(t)         Output net of damages equation (trillions 2005 USD per year)
        DAMAGES(t)      Damages (trillions 2005 USD per year)
        DAMFRAC(t)      Damages as fraction of gross output
        ABATECOST(t)    Cost of emissions reductions  (trillions 2005 USD per year)
        MCABATE(t)      Marginal cost of abatement (2005$ per ton CO2)
        CCA(t)          Cumulative industrial carbon emissions (GTC)
*        PERIODU(t)      One period utility function
        PERIODU_W(t)      One period utility function
        PERIODU_P(t)      One period utility function
        CPRICE(t)       Carbon price (2005$ per ton of CO2)
        CEMUTOTPER(t)   Period utility
        J(t)            Welfare function of time
        TRANSFER(t)     Intra transfer
        UTILITY         Welfare function
;

NONNEGATIVE VARIABLES  MIU, TATM, MAT, MU, ML, Y, YGROSS, C, K, I, TAU, B;

EQUATIONS
*Emissions and Damages
        EEQ(t)           Emissions equation
        EINDEQ(t)        Industrial emissions
        CCACCA(t)        Cumulative carbon emissions

        FORCE(t)         Radiative forcing equation
        DAMFRACEQ(t)     Equation for damage fraction
        DAMEQ(t)         Damage equation

        ABATEEQ(t)       Cost of emissions reductions equation
        MCABATEEQ(t)     Equation for MC abatement
        CARBPRICEEQ(t)   Carbon price equation from abatement

*Climate and carbon cycle
        MMAT(t)          Atmospheric concentration equation
        MMU(t)           Shallow ocean concentration
        MML(t)           Lower ocean concentration
        TATMEQ(t)        Temperature-climate equation for atmosphere
        TOCEANEQ(t)      Temperature-climate equation for lower oceans

*Economic variables
        YGROSSEQ(t)      Output gross equation
        YNETEQ(t)        Output net of damages equation
*        TAXEQ(t)         Amount of taxes equation
        CW(t)            Consumption equation
        CP(t)            Consumption equation
        CPCW(t)          Per capita consumption definition
        CPCP(t)          Per capita consumption definition
*        cpc(t)
        SEQ(t)           Savings rate equation
        KK(t)            Capital balance equation
        RIEQ(t)          Interest rate equation
*        BB(t)            Bonds equation
        JJ(t)            Utility equation
*        tax(t)

* Utility
        CEMUTOTPEREQ(t)  Period utility
        PERIODUPEQ(t)     Instantaneous utility function equation
        PERIODUWEQ(t)     Instantaneous utility function equation
*        PERIODUEQ(t)     Instantaneous utility function equation
        UTIL             Objective function
        JJJ
*CONSEQ(t)
;

** Equations of the model
*Emissions and Damages
 eeq(t)..             E(t)           =E= EIND(t) + etree(t);
 eindeq(t)..          EIND(t)        =E= sigma(t) * YGROSS(t) * (1-(MIU(t)));
 ccacca(t+1)..        CCA(t+1)       =E= CCA(t)+ EIND(t)*5/3.666;
 force(t)..           FORC(t)        =E= fco22x * ((log((MAT(t)/588.000))/log(2))) + forcoth(t);
 damfraceq(t) ..      DAMFRAC(t)     =E= (a2*TATM(t)**a3)/(1+(a2*TATM(t)**a3));
 dameq(t)..           DAMAGES(t)     =E= YGROSS(t) * DAMFRAC(t);
 abateeq(t)..         ABATECOST(t)   =E= YNET(t) * cost1(t) * (MIU(t)**expcost2) * (partfract(t)**(1-expcost2));
 mcabateeq(t)..       MCABATE(t)     =E= cost1(t) * (MIU(t)**(expcost2));
 carbpriceeq(t)..     CPRICE(t)      =E= pbacktime(t) * (MIU(t)/partfract(t))**(expcost2-1);

*Climate and carbon cycle
 mmat(t+1)..          MAT(t+1)       =E= MAT(t)*b11 + MU(t)*b21 + (E(t)*(5/3.666));
 mml(t+1)..           ML(t+1)        =E= ML(t)*b33  + MU(t)*b23;
 mmu(t+1)..           MU(t+1)        =E= MAT(t)*b12 + MU(t)*b22 + ML(t)*b32;
 tatmeq(t+1)..        TATM(t+1)      =E= TATM(t) + c1 * ((FORC(t+1)-(fco22x/t2xco2)*TATM(t))-(c3*(TATM(t)-TOCEAN(t))));
 toceaneq(t+1)..      TOCEAN(t+1)    =E= TOCEAN(t) + c4*(TATM(t)-TOCEAN(t));

*Economic variables
 ygrosseq(t)..        YGROSS(t)      =E= (al(t)*((P(t)+L(t))/1000)**(1-GAMA))*(K(t)**GAMA);
 yneteq(t)..          YNET(t)        =E= YGROSS(t)*(1-damfrac(t));
* taxeq(t)..           TAXCOST(t)     =E= YNET(t) * tau(t) * (1-GAMA);
 seq(t)..             I(t)           =E= S(t) * YNET(t);
 cw(t)..              C_W(t)         =E= (1-q)*YNET(t) * (1-GAMA)- betta*ABATECOST(t) ;
 cp(t)..              C_P(t)         =E= YNET(t) - I(t) - C_W(t) - ABATECOST(t);
* cpc(t)..              C_P(t)         =E= C_W(t);
 cpcw(t)..            CPC_W(t)       =E= 1000 * C_W(t) / L(t);
 cpcp(t)..            CPC_P(t)       =E= 1000 * C_P(t) / P(t);
 kk(t+1)..            K(t+1)         =E= (1-dk)**tstep * K(t) + tstep * I(t);
* tax(t)..            TAXCOST(t)      =E= ABATECOST(t);
* bb(t+1)..            B(t+1)         =E= (1+RI(t))**tstep * B(t) + tstep *( ABATECOST(t) - TAXCOST(t) );
* rieq(t+1)..          RI(t)          =E= (1+prstp) * (CPC(t+1)/CPC(t))**(elasmu/tstep) - 1;
 rieq(t+1)..          RI(t)          =E= GAMA *(1-damfrac(t))* al(t)*((P(t)+L(t))/1000/K(t))**(1-GAMA) - dk;

*Utility
* cemutotpereq(t)..    CEMUTOTPER(t)  =E= PERIODU(t) * L(t) * rr(t);
* periodueq(t)..       PERIODU(t)     =E= ((C(T)*1000/L(T))**(1-elasmu)-1)/(1-elasmu)-1;
* cemutotpereq(t)..    CEMUTOTPER(t)  =E= PERIODU(t) * ( L(T)+P(T) ) * rr(t);
* periodueq(t)..       PERIODU(t)     =E= (((C_W(t)+C_P(t))*1000/(L(T)+P(T)))**(1-elasmu)-1)/(1-elasmu)-1;
* periodueq(t)..       PERIODU(t)     =E= log((C_W(t)+C_P(t))*1000/(L(T)+P(T)));
* cemutotpereq(t)..    CEMUTOTPER(t)  =E= (PERIODU_W(t) * L(t) + const*PERIODU_P(t) * P(t)) * rr(t);
 cemutotpereq(t)..    CEMUTOTPER(t)  =E= PERIODU_P(t) * rr(t);
* cemutotpereq(t)..    CEMUTOTPER(t)  =E= (PERIODU_W(t) * (1-q) + const*PERIODU_P(t) * q) * rr(t);
* cemutotpereq(t)..    CEMUTOTPER(t)  =E= (PERIODU_W(t) * L(t) + PERIODU_P(t) * P(t)) * rr(t);
 perioduweq(t)..       PERIODU_W(t)  =E= (CPC_W(T)**(1-elasmu)-1)/(1-elasmu)-1;
 periodupeq(t)..       PERIODU_P(t)  =E= (CPC_P(T)**(1-elasmu)-1)/(1-elasmu)-1;
* perioduweq(t)..       PERIODU_W(t)  =E= log(CPC_W(T));
* periodupeq(t)..       PERIODU_P(t)  =E= log(CPC_P(T));
 util..               UTILITY        =E= tstep * sum(t,  CEMUTOTPER(t));
 jj(t+1)..            J(t+1)         =E= J(t)+tstep*CEMUTOTPER(t+1);
 jjj..                J('1')         =E= tstep*CEMUTOTPER('1');

*Resource limit
CCA.up(t)       = fosslim;

* Control rate limits
MIU.up(t)            = limmiu*partfract(t);
MIU.up(t)$(t.val<30) = 1;
*MIU.up(t)            = 0;

**  Upper and lower bounds for stability
K.LO(t)         = 1;
MAT.LO(t)       = 10;
MU.LO(t)        = 100;
ML.LO(t)        = 1000;
*C.LO(t)         = 2;
TOCEAN.UP(t)    = 20;
TOCEAN.LO(t)    = -1;
TATM.UP(t)      = 40;
S.UP(t)      = 0.25;
CPC_W.LO(t)     = .000001;
CPC_P.LO(t)     = .000001;
C_W.LO(t)         = 0.0001;
C_P.LO(t)         = 0.0001;

* Control variables
* Set savings rate for steady state for last 10 periods
set lag10(t) ;
lag10(t) =  yes$(t.val gt card(t)-10);
*S.FX(lag10(t)) = optlrsav;

* Initial conditions
CCA.FX(tfirst)    = 90;
K.FX(tfirst)      = k0;
MAT.FX(tfirst)    = mat0;
MU.FX(tfirst)     = mu0;
ML.FX(tfirst)     = ml0;
TATM.FX(tfirst)   = tatm0;
TOCEAN.FX(tfirst) = tocean0;
*B.FX(tlast) = 0;
*B.FX(tfirst) = 0;

** Solution options
option iterlim = 99900;
option reslim = 99999;
option solprint = on;
option limrow = 0;
option limcol = 0;
model  CO2 /all/;

* For base run, this subroutine calculates Hotelling rents
* Carbon price is maximum of Hotelling rent or baseline price
option nlp=conopt4;

miu.fx('1')$(ifopt=1) = miu0;


file results3 /COOMM_S.csv/;      results3.nd = 10 ; results3.nw = 0 ; results3.pw=1200000; results3.pc=5;
file res6 /COOMM_TATM.csv/;     res6.nd = 10 ; res6.nw = 0 ; res6.pw=1200000; res6.pc=5;
file res8 /COOMM_CPCP.csv/;     res8.nd = 10 ; res8.nw = 0 ; res8.pw=1200000; res8.pc=5;
file res81 /COOMM_CPCW.csv/;     res81.nd = 10 ; res81.nw = 0 ; res81.pw=1200000; res81.pc=5;
file res12 /COOMM_ABATECOSTtoGDP.csv/;     res12.nd = 10 ; res12.nw = 0 ; res12.pw=1200000; res12.pc=5;
file res15 /COOMM_YNET.csv/;     res15.nd = 10 ; res15.nw = 0 ; res15.pw=1200000; res15.pc=5;


loop(N,
betta = beta_min+(beta_max-beta_min)*(N.val-1)/(card(N)-1);
solve co2 maximizing utility using nlp;
put results3;
Loop (t, put S.l(t));
put /;
put res6;
Loop (t, put TATM.l(t));
put /;
put res8;
Loop (t, put CPC_P.l(t));
put /;
put res81;
Loop (t, put CPC_W.l(t));
put /;
put res12;
Loop (t, put MCABATE.l(t));
put /;
put res15;
Loop (t, put YNET.l(t));
put /;
)

putclose
putclose
putclose
putclose
putclose
putclose


** Display at bottom of output for visual inspection
option decimals=4;
display utility.l;

* Some sample results.
* Produces a file "DiceResults.csv" in the base directory
* For ALL relevant model outputs, see 'PutOutputAllT.gms' in the Include folder.
* The statement at the end of the *.lst file "Output..." will tell you where to find the file.



