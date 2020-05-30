"""
The GEOTRACES transects are not necessarily ordered in a nice way for plotting

Here is some predefined functionality to plot them nicely ordered

The code used for each transect was close to
```
cruise_list = unique(GEOTRACES.list_of_cruises())
ct = GEOTRACES.cruisetrack(c)
# Plot with rainbow to help seeing the problematic "jumps"
plot([(st.lon, st.lat) for st in ct.stations], m=:circle, zcolor=mod.(1:length(ct),10), color=:rainbow)
ic = sortperm(ct)
# Plot again after reordering
plot([(st.lon, st.lat) for st in ct.stations[ic]], m=:circle, zcolor=mod.(1:length(ct),10), color=:rainbow)

```


"""