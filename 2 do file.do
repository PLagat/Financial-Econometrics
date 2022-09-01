//TEST FOR STRUCTURAL BREAKS
regress KSHUSD
estat sbsingle, swald awald
estat sbsingle, trim(2)

regress KSHUSD KSHSterlingpound
estat sbsingle, breakvars( KSHSterlingpound )

mswitch dr KSHUSD
estat transition

mswitch dr KSHUSD, switch(L.KSHUSD KSHSterlingpound KSHEuro)
predict PRKSHUSD, pr
twoway(line KSHUSD monthly)(line PRKSHUSD monthly, yaxis(2))


twoway(line KSHEuro monthly)(line PRKSHEuro monthly, yaxis(2))

threshold KSHUSD, threshvar(L.KSHUSD)
threshold KSHUSD, threshvar(L.KSHUSD) regionvars(L.KSHUSD KSHSterlingpound KSHEuro)