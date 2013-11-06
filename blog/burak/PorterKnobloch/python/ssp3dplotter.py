#
# ssp3dplotter.py
#
"""
Plot the solution generated by invpolsolver.py
"""

from __future__ import unicode_literals
from numpy import loadtxt
from pylab import figure, plot, xlabel, ylabel, grid, hold, legend, title, savefig
from matplotlib.font_manager import FontProperties
import matplotlib as mpl
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
import numpy as np

mpl.rcParams['text.usetex']=True
mpl.rcParams['text.latex.unicode']=True

t, x1, y1, x2, y2 = loadtxt('data/sspsolution.dat', unpack=True)

fig = plt.figure()
ax = fig.gca(projection='3d')

ax.plot(x1, x2, y2, linewidth=0.3)
ax.set_xlabel('$x_1$', fontsize=16)
ax.set_ylabel('$x_2$', fontsize=16)
ax.set_zlabel('$y_2$', fontsize=16)
#ax.view_init(15,30)
savefig('image/ssp.png', bbox_inches='tight', dpi=150)

redref = 0

if redref:
	
	indexref = np.where(y2<0)
	
	y2refred = np.copy(y2)
	y2refred[indexref] = -y2[indexref]
	x2refred = np.copy(x2)
	x2refred[indexref] = -x2[indexref]

	fig = plt.figure()
	ax=fig.gca(projection='3d')
	ax.plot(x1, y2refred, y1, linewidth=0.3)
	ax.set_xlabel('$x_1$', fontsize=16)
	ax.set_ylabel('$y_2$', fontsize=16)
	ax.set_zlabel('$y_1$', fontsize=16)
	savefig('image/ssprefred.png', bbox_inches='tight', dpi=150)

plt.tight_layout()
plt.show()
