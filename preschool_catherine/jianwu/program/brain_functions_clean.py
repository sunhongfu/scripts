#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import pandas as pd
import warnings
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
import lmfit
import seaborn as sns
from scipy import stats
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import PolynomialFeatures
import statsmodels.api as sm
import statsmodels.formula.api as smf
from sklearn.metrics import r2_score, explained_variance_score as EVS, mean_squared_error as MSE


# In[ ]:


# import data
brain_scans=pd.read_table('D:\导师\sub_all_meas_clean.csv',sep=',')
brain_data=pd.DataFrame(data=brain_scans)
# regulate data
birthdays=brain_data.iloc[0:,4]
examdate=brain_data.iloc[0:,7]
age=pd.to_datetime(examdate)-pd.to_datetime(birthdays)
ages=age.to_frame()
days = ages.astype('timedelta64[D]')

# arrange data
L_SLF=brain_data.iloc[:,24:31] # 1
Fornix=brain_data.iloc[:,32:39]# 2
R_Cingulum=brain_data.iloc[:,40:47]# 3
R_ILF=brain_data.iloc[:,48:55]# 4
CC_Genu=brain_data.iloc[:,56:63]# 5
L_ILF=brain_data.iloc[:,64:71]# 6
L_Uncinate=brain_data.iloc[:,72:79]# 7 
R_Uncinate=brain_data.iloc[:,80:87]# 8
L_Pyramidal=brain_data.iloc[:,88:95]# 9
R_SLF=brain_data.iloc[:,96:103]# 10
CC_Splenium=brain_data.iloc[:,104:111]# 11
R_IFO=brain_data.iloc[:,112:119]#  12
CC_Body=brain_data.iloc[:,120:127]# 13
L_IFO=brain_data.iloc[:,128:135]# 14
R_Pyramidal=brain_data.iloc[:,136:143]# 15


# In[ ]:


def age_data(Left,Right=pd.DataFrame()):
    
    if not Right.empty:
        LR_data=pd.concat([Left,Right],axis=1)
        data=pd.DataFrame(columns=['FA','MD','RD','QSM1','QSM2','QSM3','QSM4'])
        for i in range(data.shape[1]):
            data.iloc[:,i ]=LR_data.apply(lambda x: x.iloc[i]/2 + x.iloc[i+7]/2, axis=1)
    else:
        data=Left
    age_data=pd.concat([brain_data.iloc[:,2:4],days,data],axis=1)
    age_data.columns =['subject','sex','age', 'FA', 'MD','RD','QSM1','QSM2','QSM3','QSM4']
    age_data=age_data.fillna(age_data.mean())
    age_data=age_data.sort_values(by='age')
    return age_data


# In[ ]:


age_SLF=age_data(L_SLF,R_SLF)# 1
age_ILF=age_data(L_ILF,R_ILF)# 2
age_Uncinate=age_data(L_Uncinate,R_Uncinate)# 3
age_Pyramidal=age_data(L_Pyramidal,R_Pyramidal)# 4
age_IFO=age_data(L_IFO,R_IFO)# 5

age_Fornix=age_data(Fornix) # 6

age_Cingulum=age_data(R_Cingulum)# 7

age_CC_Genu=age_data(CC_Genu)# 8
age_CC_Splenium=age_data(CC_Splenium) # 9
age_CC_Body=age_data(CC_Body)#10

tract_dict={"superior longitudinal fasciculus":age_SLF,"inferior longitudinal fasciculus":age_ILF,"Uncinate":age_Uncinate,
            "Pyramidal":age_Pyramidal,"inferior fronto-occipital fasciculus":age_IFO,"Fornix":age_Fornix,"Cingulum":age_Cingulum,
            "Corpus Callosum Genu":age_CC_Genu,"Corpus Callosum Splenium":age_CC_Splenium,"Corpus Callosum Body":age_CC_Body}


# In[ ]:


# selection performed base on average distance
def selection(raw_data,measure):
    selected_data=raw_data.sort_values(by=measure).reset_index(drop=True)
    data_diff=selected_data.loc[:,[measure]].diff()

    mean=float(data_diff.mean())

    screen_factor=10 # any data point with a distance to the nearest neighbor greater than screen_factor * mean will be eliminated
    elimination_num= 10 # max_num of elimination ( not trigger in this study)

    for row in data_diff.iterrows():
        if np.isnan(row[1][0]): # if the difference is nan, then pass
            pass
        elif row[1][0] > (screen_factor  *  mean):
            if row[0]< elimination_num:
                drop_list=selected_data.index[:row[0]]
                #
            elif row[0]>selected_data.shape[0]-elimination_num:
                drop_list=selected_data.index[row[0]+1:]
            else:
                drop_list=[]
            #
            for i in drop_list:
                if i in selected_data.index:
                    selected_data.drop(i,axis = 0,inplace = True)
    selected_data.reset_index(drop=True,inplace=True)
    return mean,selected_data


# In[ ]:


# to test how many data remain after selection
def selection_test(raw_data):
    
    data=pd.DataFrame(columns=['FA','MD','RD','QSM1','QSM2','QSM3','QSM4'])

    data.loc[0,'FA']=selection(raw_data,'FA')[1].shape[0]
    data.loc[0,'MD']=selection(raw_data,'MD')[1].shape[0]
    data.loc[0,'RD']=selection(raw_data,'RD')[1].shape[0]
    data.loc[0,'QSM1']=selection(raw_data,'QSM1')[1].shape[0]
    data.loc[0,'QSM2']=selection(raw_data,'QSM2')[1].shape[0]
    data.loc[0,'QSM3']=selection(raw_data,'QSM3')[1].shape[0]
    data.loc[0,'QSM4']=selection(raw_data,'QSM4')[1].shape[0]   

    return data


# In[ ]:


# the end product select_form represents how many data are left after screening
s_SLF=selection_test(age_SLF)
s_ILF=selection_test(age_ILF)
s_Uncinate=selection_test(age_Uncinate)
s_Pyramidal=selection_test(age_Pyramidal)
s_IFO=selection_test(age_IFO)
s_Fornix=selection_test(age_Fornix)
s_Cingulum=selection_test(age_Cingulum)
s_CC_Genu=selection_test(age_CC_Genu)
s_Splenium=selection_test(age_CC_Splenium)
s_CC_Body=selection_test(age_CC_Body)
selected_form = pd.concat([s_SLF,s_ILF,s_Uncinate,s_Pyramidal,s_IFO,s_Fornix,s_Cingulum,s_CC_Genu,s_Splenium,s_CC_Body],axis=0)
selected_form.reset_index(inplace=True,drop=True)
form_index=pd.DataFrame({'row_name':['SLF','ILF','Uncinate','Pyramidal','IFO','Fornix','Cingulum','CC_Genu','Splenium','CC_Body']})
select_form =pd.concat([selected_form,form_index],axis=1)
select_form.set_index('row_name',inplace=True)


# In[ ]:


# helper function for tract_plot:'to collapse the data points into one' 
def pj(i,j,igroup):
    return (igroup.iloc[i,j]+igroup.iloc[i+1,j])/2
def pingjun(i,igroup):
    result=[]
    for n in range(igroup.shape[1]-2):
        result.append(pj(i,n+2,igroup))
    return result


# In[ ]:


# helper function for tract_plot :" the repeating part of the program"
def one_tract_plot(X,Y,deg=2):
    polynomial_features= PolynomialFeatures(degree=deg,include_bias=True)
    x_poly = polynomial_features.fit_transform(X)

    linear_regressor = LinearRegression(fit_intercept=False)
    linear_regressor.fit(x_poly, Y)        

    coef =pd.DataFrame(linear_regressor.coef_).iloc[:,::-1]

    xx = np.linspace(X.min(), X.max(), 100)
    xx_poly = polynomial_features.transform(xx.reshape(xx.shape[0], 1))
    Y_pred = linear_regressor.predict(xx_poly)
    return xx,Y_pred,coef


# In[ ]:


# helper function for tract_plot : ( to set the canvas)
def runplt(measure,measure1='age'):
    plt.figure()
    plt.title(measure+'-'+measure1+' curver')
    if measure1=='age':
        plt.xlabel(u'days')
    else:
        plt.xlabel(measure1)
    plt.ylabel(measure,rotation=0)
#     hYLabel = get(gca,'YLabel')
#     set(hYLabel,'rotation',0,'VerticalAlignment','middle')
    return plt


# In[ ]:


'''
selection based on individual
if an individual measured mutiple times within short time, get the average
'''
def selection_2(igroup):
    interval=23
    min_participation=4
    igroup=igroup.reset_index(drop=True)
    for i in range(igroup.shape[0]-1):
        if igroup['age'].iloc[i+1]-igroup['age'].iloc[i]<interval and igroup.shape[0]<min_participation:               
            igroup.loc[i,2:] = pingjun(i,igroup)                
            igroup.drop([i+1],axis = 0,inplace = True)

        if igroup.shape[0]-i<=2:
            break
    return igroup


# In[ ]:


# main fucntion in this program
def tract_plot(raw_data,measure,measure1='age',dgr=2):    
    plt = runplt(measure,measure1)
    # the data point which is 4 times further to its closest point than that of average should be excluded
    mean,data=selection(raw_data,measure)
      
    for person in data['subject'].drop_duplicates():
        igroup=data[data.subject==person].sort_values(by=measure1)
        igroupe=selection_2(igroup)
        
    
        X = igroup[measure1].values.reshape(-1, 1) 
        Y = igroup[measure].values.reshape(-1, 1)

        
        xx,Y_pred,_=one_tract_plot(X,Y,dgr)
        
        # if a curve is so curvy that it breach the upper bound allowed by selection() use linear instead of quadratic.
        if dgr==2:
            for i in Y_pred:
                if i[0]>data[measure].values.max()+ 5 * mean:
                    xx,Y_pred,_=one_tract_plot(X,Y,1)                        
                    break                
                if i[0]<data[measure].values.min()- 5 * mean:
                    xx,Y_pred,_=one_tract_plot(X,Y,1)                        
                    break 
        # end of screening
        
        # draw boys and girls separately
        if igroup['sex'].iloc[0]=='f':
            plt.plot(xx,Y_pred,linewidth=0.5,color='red')
            plt.scatter(X, Y,s=3,c='pink')
        if igroup['sex'].iloc[0]=='m':
            plt.plot(xx,Y_pred,linewidth=0.5,color='blue')
            plt.scatter(X, Y,s=1,c='purple')

    W = data[measure1].values.reshape(-1, 1)
    X = data.loc[:, [measure1,'sex']].replace(['f','m'],[-1,1]).values.reshape(-1, 2)
    Y = data[measure].values.reshape(-1, 1)
    
    xx,Y_pred,coefficients=one_tract_plot(W,Y,dgr)    

    plt.plot(xx, Y_pred, color='black',linewidth=2)
    
    polynomial_features= PolynomialFeatures(degree=dgr,include_bias=True)
    x_poly = polynomial_features.fit_transform(X)
    if dgr==2:
        x_poly = np.delete(x_poly,0,axis = 1)
    
    linear_regressor = LinearRegression(fit_intercept=False)
    linear_regressor.fit(x_poly, Y)
    
    if dgr==2:
        coef =pd.DataFrame(linear_regressor.coef_)#.iloc[:,::-1]
        coef.columns =['sex*'+measure1, measure1+'²','sex',measure1, 'intercept']
    elif dgr==1:
        coef =pd.DataFrame(linear_regressor.coef_).iloc[:,::-1]
        coef.columns =['sex,',measure1, 'intercept']
        
        # p value
    data.reset_index(drop=True,inplace=True)    
    p_data=pd.concat([pd.DataFrame(x_poly),data.loc[:, ['subject',measure]]],axis=1)
    if dgr==2:
        p_data.columns =[measure1,'sex',measure1+'_2','sex_'+measure1, 'intercept','subject',measure]
        md = smf.mixedlm(measure+" ~ "+measure1+" + sex + "+measure1+"_2 + sex_"+measure1, p_data, groups=p_data["subject"])
    elif dgr==1:
        p_data.columns =[ 'intercept',measure1,'sex','subject',measure]
        md = smf.mixedlm(measure+" ~ "+measure1+" + sex", p_data, groups=p_data["subject"])
    with warnings.catch_warnings():
        warnings.filterwarnings("ignore")
        mdf = md.fit()
        
        # end of p value
    
    plt.show()
    print(coef)
    print(mdf.summary())


# In[ ]:


def plot_by_tract(measure,measure1='age',dgr=2):
    for name,data in tract_dict.items():
            print("********************"+name+"*****************")
            tract_plot(data,measure,measure1,dgr)


# In[ ]:


def plot_by_measure(data,measure1='age',dgr=2):
    tract_plot(data,'FA',measure1,dgr)
    tract_plot(data,'MD',measure1,dgr)
    tract_plot(data,'RD',measure1,dgr)
    tract_plot(data,'QSM1',measure1,dgr)
    tract_plot(data,'QSM2',measure1,dgr)
    tract_plot(data,'QSM3',measure1,dgr)
    tract_plot(data,'QSM4',measure1,dgr)


# In[ ]:


combined_data=pd.concat([
    L_SLF,Fornix,R_Cingulum,R_ILF,CC_Genu,L_ILF,L_Uncinate,R_Uncinate,L_Pyramidal,R_SLF,CC_Splenium,R_IFO,CC_Body,L_IFO,R_Pyramidal
                        ],axis=1)
average_all=pd.DataFrame(columns=['FA','MD','RD','QSM1','QSM2','QSM3','QSM4','QSM'])

for i in range(average_all.shape[1]-1):
    def ave(x):
        result=0
        for j in range(15):
            result+=x.iloc[i+7*j]/15
        return result
    average_all.iloc[:,i]=combined_data.apply(ave,axis=1)
    
def ave_qsm(x):
    result=x.iloc[3]/4+x.iloc[4]/4+x.iloc[5]/4+x.iloc[6]/4
    return result  
    
average_all.iloc[:,7]= average_all.apply(ave_qsm,axis=1)

age_average_all=pd.concat([brain_data.iloc[:,2:4],days,average_all],axis=1)
age_average_all.columns =['subject','sex','age', 'FA', 'MD','RD','QSM1','QSM2','QSM3','QSM4','QSM']
age_average_all=age_average_all.fillna(age_average_all.mean())


# In[ ]:


def whole_brain_qsm():
    tract_plot(age_average_all,'QSM1')
    tract_plot(age_average_all,'QSM2')
    tract_plot(age_average_all,'QSM3')
    tract_plot(age_average_all,'QSM4')
    tract_plot(age_average_all,'QSM')
    tract_plot(age_average_all,'FA')
    tract_plot(age_average_all,'MD')
    tract_plot(age_average_all,'RD')

