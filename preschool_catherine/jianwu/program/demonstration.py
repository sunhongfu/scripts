#!/usr/bin/env python
# coding: utf-8

# In[1]:


import import_ipynb
from brain_functions_clean import *
import pandas as pd
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
import lmfit
import warnings
import seaborn as sns
from scipy import stats
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import PolynomialFeatures
import statsmodels.api as sm
import statsmodels.formula.api as smf
from sklearn.metrics import r2_score, explained_variance_score as EVS, mean_squared_error as MSE


# In[4]:


select_form


# In[5]:


age_average_all


# In[2]:


whole_brain_qsm()


# In[2]:


plot_by_tract("FA")


# In[3]:


plot_by_tract("MD","QSM2",1)


# In[2]:


tract_plot(age_SLF,'FA')


# In[4]:


tract_plot(age_SLF,'FA','age',1)


# In[5]:


tract_plot(age_SLF,'FA','QSM1')


# In[6]:


tract_plot(age_SLF,'FA','QSM1',1)

