#
# movingframes3dplotter.py
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

t, x1hat, y1hat, x2hat, y2hat = loadtxt('data/solutioncomov.dat', unpack=True)

fig = plt.figure()
ax = fig.gca(projection='3d')

ax.plot(x1hat, x2hat, y2hat, linewidth=0.3)
ax.set_xlabel('$\hat{x}_1$', fontsize=16)
ax.set_ylabel('$\hat{x}_2$', fontsize=16)
ax.set_zlabel('$\hat{y}_2$', fontsize=16)
#ax.view_init(15,30)
savefig('image/solvedcomov.png', bbox_inches='tight', dpi=150)

#fig2 = plt.figure()
#plt.plot(t,np.mod(phi, 2*np.pi))
#xlabel('Time', fontsize=16)
#ylabel('$\phi (t)$', fontsize=16)

redref = 0

if redref:
	
	indexref = np.where(y2hat<0)
	
	y2hatrefred = np.copy(y2hat)
	y2hatrefred[indexref] = -y2hat[indexref]
	x2hatrefred = np.copy(x2hat)
	x2hatrefred[indexref] = -x2hat[indexref]

	fig = plt.figure()
	ax=fig.gca(projection='3d')
	ax.plot(x1hat, y1hat, y2hatrefred, linewidth=0.3)
	ax.set_xlabel('$\hat{x}_{1}$', fontsize=16)
	ax.set_ylabel('$\hat{y}_1$', fontsize=16)
	ax.set_zlabel('$\hat{y}_{2,refred}$', fontsize=16)
	ax.view_init(30,100)
	savefig('image/onslicerefred.png', bbox_inches='tight', dpi=150)

	
plt.tight_layout()
plt.show()
