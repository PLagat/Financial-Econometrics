use "D:\FIN ECONOMETRICS\MINI ESSAYS\archexc.dta" 
gen monthly = mofd(Date)
format monthly %tm
tsset monthly

//TEST FOR ASYMMETRY
regress kshusdreturns L.kshusdreturns
predict epsilon, residuals
gen sqres=epsilon^2
gen dunmeg=1 if epsilon<0
gen dunmeglag=1 if L.epsilon<0 //what we are looking for
replace dunmeglag=0 if L.epsilon>0
regress sqres dunmeglag

//KSHUSD
gen kshusdreturns = ln(KSHUSD/L.KSHUSD)
//Testing ARCH effects
regress kshusdreturns L.kshusdreturns
estat archlm

arch kshusdreturns, arch(1/1) arima(1,0,0)
armadiag, arch table  //has captured all autocorrelations, BIC is -910

arch kshusdreturns, arch(1/1) garch(1/1) arima(1,0,0)
armadiag, arch table      //BIC is -912

//KSHSterlingpound
gen kshpoundreturns =ln( KSHSterlingpound/L.KSHSterlingpound)
//Testing ARCH effects
regress kshpoundreturns L.kshpoundreturns
estat archlm

arch kshpoundreturns, arch(1/1) arima(1,0,0)
armadiag, arch table //has not captured all

arch kshpoundreturns, arch(1/1) arima(1,0,1)
armadiag, arch table //has not captured all

arch kshpoundreturns, arch(1/1) garch(1/1) arima(1,0,0)
armadiag, arch table //garch coefficient is insignificant and still not captured all

arch kshpoundreturns, arch(1/1) garch(1/2) archm arima(1,0,0) //this has WORKED!
armadiag, arch table //has captured all autocorrelations
estat ic

arch kshpoundreturns, arch(1/1) arima(1,0,0)
predict condvar2, variance
twoway (line condvar2 kshpoundreturns)

//KSHEuro
gen ksheuroreturns = ln(KSHEuro/L.KSHEuro)
//testing arch effects
regress ksheuroreturns L.ksheuroreturns //rsquared is 0.0939
estat archlm #presence of arch effects

arch ksheuroreturns, ar(1) arch(1/1)
armadiag, arch table #presence of autocorrelations
estat ic

arch ksheuroreturns , ar(1) ma(1) arch(1/1)
armadiag, arch table  #autocorrelations still present
estat ic

arch ksheuroreturns, arch(1/1) garch(1/1) arima(1,0,0) //chosen
armadiag, arch table

arch ksheuroreturns, arch(1/1) garch(1/1) arima(1,0,0)
predict condvar3,variance
twoway (line condvar3 monthly)


arch ksheuroreturns, arch(1/1) garch(1/1) arima(1,0,0)
estat ic
arch ksheuroreturns, arch(1/2) garch(1/2) arima(1,0,0)
estat ic



