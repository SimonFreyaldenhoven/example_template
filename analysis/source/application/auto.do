sysuse auto, clear
set scheme s1color
global dir_graph "../output/application"


scatter price mpg
graph export "$dir_graph/scatter.eps", replace
