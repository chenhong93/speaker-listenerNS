# -*- coding: utf-8 -*-
"""
Created on Mon Aug  4 16:07:34 2025

@author: BMI
"""

import sys
import numpy as np
# namemod="GPT-4.1"


namemod=sys.argv[1]
namefile=sys.argv[2]
ndim=int(sys.argv[3])
npermall=sys.argv[4]


for nperm in range(2,int(npermall)):
    pathsave='gptres/' + namefile + '-' + str(ndim) +'-'+str(nperm)+ '.mat'
    # scio.savemat(pathsave,{'res':namemod})
    
    api_key="your poe api key"
    
    
    if ndim==1:
    
        import openai
        
          
        client = openai.OpenAI(
            api_key=api_key, # or os.getenv("POE_API_KEY")
            base_url="https://api.poe.com/v1",
        )
        
        import scipy.io as scio
        import pandas as pd
        fm=pd.read_excel(r"Book1-pd.xlsx",sheet_name="Sheet1")
        
        
        cc1="你的任务是根据每个词语的感知觉程度进行打分。感知觉是指词语的含义能够在多大程度上使你容易想起视觉、听觉、触觉、味觉等感知觉信息。评分范围是1到7分，1分：非常低感知觉性，完全无法触发任何感知觉信息。2分：较低感知觉性，几乎无法触发感知觉信息。3分：中等偏低感知觉性，能触发一些模糊的感知觉信息，但非常不清晰。4分：中等感知觉性，能触发较为清晰的感知觉信息，但不够生动。5分：中等偏高感知觉性，能触发具体、清晰的感知觉信息。6分：较高感知觉性，能触发非常清晰、生动的感知觉信息。7分：非常高感知觉性，能触发极其鲜明、生动的感知觉信息。需要打分的词语是:"
        cc2=""
        res=[];
        for i in range(767):
            temp=fm['词语'][i]
            ccc=cc1+temp+cc2
            chat = client.chat.completions.create(
                model=namemod,#"GPT-3.5-Turbo",#
                messages=[{"role": "user", "content": ccc}],
            )
            res.append(chat.choices[0].message.content)
            print(i)
            if np.mod(i,10)==0:
                scio.savemat(pathsave,{'res':res})
        scio.savemat(pathsave,{'res':res})
    
    
    
    
    
    elif ndim==2:
    
        import openai
          
        client = openai.OpenAI(
            api_key=api_key, # or os.getenv("POE_API_KEY")
            base_url="https://api.poe.com/v1",
        )
        
        import scipy.io as scio
        import pandas as pd
        fm=pd.read_excel(r"Book1-pd.xlsx",sheet_name="Sheet1")
        
        
        cc1="你的任务是根据每个词语的动作性（即动作相关程度）进行打分。动作性是指词语的含义在多大程度上能够使你容易在脑海中触发相应的动作。评分范围是1到7分，1分：非常低动作性，完全无法触发任何动作。2分：较低动作性，几乎无法触发动作。3分：中等偏低动作性，能触发一些模糊的动作，但非常不清晰。4分：中等动作性，能触发较为清晰的动作，但不够具体。5分：中等偏高动作性，能触发具体、清晰的动作。6分：较高动作性，能触发非常清晰、具体的动作。7分：非常高动作性，能触发极其鲜明、具体的动作。需要打分的词语是："
        cc2=""
        res=[];
        for i in range(767):
            temp=fm['词语'][i]
            ccc=cc1+temp+cc2
            chat = client.chat.completions.create(
                model=namemod,#"GPT-3.5-Turbo",
                messages=[{"role": "user", "content": ccc}],
            )
            res.append(chat.choices[0].message.content)
            print(i)
            if np.mod(i,10)==0:
                scio.savemat(pathsave,{'res':res})
        scio.savemat(pathsave,{'res':res})
    
    
    
    
    elif ndim==3:
    
        
        import openai
          
        client = openai.OpenAI(
            api_key=api_key, # or os.getenv("POE_API_KEY")
            base_url="https://api.poe.com/v1",
        )
        
        import scipy.io as scio
        import pandas as pd
        fm=pd.read_excel(r"Book1-pd.xlsx",sheet_name="Sheet1")
        
        
        cc1="你的任务是根据每个词语的社会性进行打分。社会性是指词语的含义在多大程度上与人与人之间的关系或互动相关联。评分范围是1到7分，1分：非常低社会性，与人与人之间的关系或互动完全无关。2分：较低社会性，几乎不涉及人与人之间的关系或互动。3分：中等偏低社会性，能间接涉及人与人之间的关系或互动。4分：中等社会性，较为直接地涉及人与人之间的关系或互动。5分：中等偏高社会性，直接涉及人与人之间的关系或互动。6分：较高社会性，非常直接且频繁地涉及人与人之间的关系或互动。7分：非常高社会性，极其直接且深刻地涉及人与人之间的关系或互动。需要打分的词语是:"
        cc2=""
        res=[];
        for i in range(767):
            temp=fm['词语'][i]
            ccc=cc1+temp+cc2
            chat = client.chat.completions.create(
                model=namemod,#"GPT-3.5-Turbo",
                messages=[{"role": "user", "content": ccc}],
            )
            res.append(chat.choices[0].message.content)
            print(i)
            if np.mod(i,10)==0:
                scio.savemat(pathsave,{'res':res})
        scio.savemat(pathsave,{'res':res})
    
    
    
    
    
    elif ndim==4:
    
        import openai
          
        client = openai.OpenAI(
            api_key=api_key, # or os.getenv("POE_API_KEY")
            base_url="https://api.poe.com/v1",
        )
        
        import scipy.io as scio
        import pandas as pd
        fm=pd.read_excel(r"Book1-pd.xlsx",sheet_name="Sheet1")
        
        
        cc1="你的任务是根据每个词语的情绪性进行打分。情绪性是指词语的含义在多大程度上与积极（正分，即0~6分）或消极（负分，即-6~0分）的情绪情感相关联。评分范围是-6到6分，-6分：非常强烈的消极情绪。-3分：中等强度的消极情绪。0分：中性，无明显情绪色彩。3分：中等强度的积极情绪。6分：非常强烈的积极情绪。需要打分的词语是:"
        cc2=""
        res=[];
        for i in range(767):
            temp=fm['词语'][i]
            ccc=cc1+temp+cc2
            chat = client.chat.completions.create(
                model=namemod,#"GPT-3.5-Turbo",
                messages=[{"role": "user", "content": ccc}],
            )
            res.append(chat.choices[0].message.content)
            print(i)
            if np.mod(i,10)==0:
                scio.savemat(pathsave,{'res':res})
        scio.savemat(pathsave,{'res':res})
    
    
    
    
    elif ndim==5:
    
    
        import openai
          
        client = openai.OpenAI(
            api_key=api_key, # or os.getenv("POE_API_KEY")
            base_url="https://api.poe.com/v1",
        )
        
        import scipy.io as scio
        import pandas as pd
        fm=pd.read_excel(r"Book1-pd.xlsx",sheet_name="Sheet1")
        
        
        cc1="你的任务是根据每个词语的时间性进行打分。时间性是指词语的含义多大程度上与时间相关，包括时间的早或晚、长度、顺序、频率等。评分范围是1到7分，1分：非常低时间性，与时间完全无关。2分：较低时间性，几乎不涉及时间。3分：中等偏低时间性，能间接涉及时间。4分：中等时间性，较为直接地涉及时间。5分：中等偏高时间性，直接涉及时间。6分：较高时间性，非常直接且频繁地涉及时间。7分：非常高时间性，极其直接且深刻地涉及时间。需要打分的词语是:"
        cc2=""
        res=[];
        for i in range(767):
            temp=fm['词语'][i]
            ccc=cc1+temp+cc2
            chat = client.chat.completions.create(
                model=namemod,#"GPT-3.5-Turbo",
                messages=[{"role": "user", "content": ccc}],
            )
            res.append(chat.choices[0].message.content)
            print(i)
            if np.mod(i,10)==0:
                scio.savemat(pathsave,{'res':res})
        scio.savemat(pathsave,{'res':res})
    
    
    
    
    
    elif ndim==6:
    
        import openai
          
        client = openai.OpenAI(
            api_key=api_key, # or os.getenv("POE_API_KEY")
            base_url="https://api.poe.com/v1",
        )
        
        import scipy.io as scio
        import pandas as pd
        fm=pd.read_excel(r"Book1-pd.xlsx",sheet_name="Sheet1")
        
        
        cc1="你的任务是根据每个词语的空间性进行打分。空间性是指词语的含义多大程度上与空间信息相关联，包括位置、方向、距离、路径、场景等。评分范围是1到7分，1分：非常低空间性，与空间完全无关。2分：较低空间性，几乎不涉及空间。3分：中等偏低空间性，能间接涉及空间。4分：中等空间性，较为直接地涉及空间。5分：中等偏高空间性，直接涉及空间。6分：较高空间性，非常直接且频繁地涉及空间。7分：非常高空间性，极其直接且深刻地涉及空间。需要打分的词语是:"
        cc2=""
        res=[];
        for i in range(767):
            temp=fm['词语'][i]
            ccc=cc1+temp+cc2
            chat = client.chat.completions.create(
                model=namemod,#"GPT-3.5-Turbo",
                messages=[{"role": "user", "content": ccc}],
            )
            res.append(chat.choices[0].message.content)
            print(i)
            if np.mod(i,10)==0:
                scio.savemat(pathsave,{'res':res})
        scio.savemat(pathsave,{'res':res})
    
    
    
    
    
    elif ndim==7:
    
        import openai
          
        client = openai.OpenAI(
            api_key=api_key, # or os.getenv("POE_API_KEY")
            base_url="https://api.poe.com/v1",
        )
        
        import scipy.io as scio
        import pandas as pd
        fm=pd.read_excel(r"Book1-pd.xlsx",sheet_name="Sheet1")
        
        
        cc1="你的任务是根据每个词语的生命性进行打分。生命性是指词语的含义多大程度上与动物的生命性相关，人类相关的评分最高，哺乳动物、鸟类、爬行动物、鱼类、无脊椎动物评分依次递减，非动物类别的评分最低。评分范围是1到7分，7分：与人类高度相关（如“医生”“婴儿”）。6分：与哺乳动物相关（如“狮子”“狗”）。5分：与鸟类相关（如“鹰”“鹦鹉”）。4分：与爬行动物相关（如“蛇”“乌龟”）。3分：与鱼类相关（如“鲨鱼”“金鱼”）。2分：与无脊椎动物相关（如“蚂蚁”“章鱼”）。1分：与非动物类别相关（如“石头”“电脑”）。需要打分的词语是:"
        cc2=""
        res=[];
        for i in range(767):
            temp=fm['词语'][i]
            ccc=cc1+temp+cc2
            chat = client.chat.completions.create(
                model=namemod,#"GPT-3.5-Turbo",
                messages=[{"role": "user", "content": ccc}],
            )
            res.append(chat.choices[0].message.content)
            print(i)
            if np.mod(i,10)==0:
                scio.savemat(pathsave,{'res':res})
        scio.savemat(pathsave,{'res':res})
    
    
    
    
    
    elif ndim==8:
    
        import openai
          
        client = openai.OpenAI(
            api_key=api_key, # or os.getenv("POE_API_KEY")
            base_url="https://api.poe.com/v1",
        )
        
        import scipy.io as scio
        import pandas as pd
        fm=pd.read_excel(r"Book1-pd.xlsx",sheet_name="Sheet1")
        
        
        cc1="你的任务是根据每个词语的关系性进行打分。关系性是指词语的含义多大程度上与因果或相关关系相关联，比如由先前的事件、动作或情景等所影响，或造成了其他事件的发生，或事件之间存在相关关系。评分范围是1到7分，1分：非常低关系性，与因果或相关关系完全无关。2分：较低关系性，几乎不涉及因果或相关关系。3分：中等偏低关系性，能间接涉及因果或相关关系。4分：中等关系性，较为直接地涉及因果或相关关系。5分：中等偏高关系性，直接涉及因果或相关关系。6分：较高关系性，非常直接且频繁地涉及因果或相关关系。7分：非常高关系性，极其直接且深刻地涉及因果或相关关系。需要打分的词语是:"
        cc2=""
        res=[];
        for i in range(767):
            temp=fm['词语'][i]
            ccc=cc1+temp+cc2
            chat = client.chat.completions.create(
                model=namemod,#"GPT-3.5-Turbo",
                messages=[{"role": "user", "content": ccc}],
            )
            res.append(chat.choices[0].message.content)
            print(i)
            if np.mod(i,10)==0:
                scio.savemat(pathsave,{'res':res})
        scio.savemat(pathsave,{'res':res})
    
    
    
    
    
    elif ndim==9:
    
        import openai
          
        client = openai.OpenAI(
            api_key=api_key, # or os.getenv("POE_API_KEY")
            base_url="https://api.poe.com/v1",
        )
        
        import scipy.io as scio
        import pandas as pd
        fm=pd.read_excel(r"Book1-pd.xlsx",sheet_name="Sheet1")
        
        
        cc1="你的任务是根据每个词语的动机相关程度进行打分。动机是指词语的含义多大程度上与对某个人或事物的动机、动力或需求相关联。评分范围是1到7分，1分：完全与动机无关（如“静止”）。2分：几乎与动机无关（如“被动”）。3分：与较弱的动机相关（如“随意”）。4分：与一般性的动机或需求相关（如“选择”）。5分：与中等程度的动机相关（如“兴趣”）。6分：与较强的动机或动力相关（如“奋斗”）。7分：与高度强烈的动机或需求直接相关（如“渴望”）。需要打分的词语是:"
        cc2=""
        res=[];
        for i in range(767):
            temp=fm['词语'][i]
            ccc=cc1+temp+cc2
            chat = client.chat.completions.create(
                model=namemod,#"GPT-3.5-Turbo",
                messages=[{"role": "user", "content": ccc}],
            )
            res.append(chat.choices[0].message.content)
            print(i)
            if np.mod(i,10)==0:
                scio.savemat(pathsave,{'res':res})
        scio.savemat(pathsave,{'res':res})
    
    
    
    
    
    elif ndim==10:
    
        import openai
          
        client = openai.OpenAI(
            api_key=api_key, # or os.getenv("POE_API_KEY")
            base_url="https://api.poe.com/v1",
        )
        
        import scipy.io as scio
        import pandas as pd
        fm=pd.read_excel(r"Book1-pd.xlsx",sheet_name="Sheet1")
        
        
        cc1="你的任务是根据每个词语的注意相关程度进行打分。注意是指词语的含义多大程度上与人的注意、警觉、兴奋等状态相关联。评分范围是1到7分，1分：非常低注意性，与注意完全无关。2分：较低注意性，几乎不涉及注意。3分：中等偏低注意性，能间接涉及注意。4分：中等注意性，较为直接地涉及注意。5分：中等偏高注意性，直接涉及注意。6分：较高注意性，非常直接且频繁地涉及注意。7分：非常高注意性，极其直接且深刻地涉及注意。需要打分的词语是:"
        cc2=""
        res=[];
        for i in range(767):
            temp=fm['词语'][i]
            ccc=cc1+temp+cc2
            chat = client.chat.completions.create(
                model=namemod,#"GPT-3.5-Turbo",
                messages=[{"role": "user", "content": ccc}],
            )
            res.append(chat.choices[0].message.content)
            print(i)
            if np.mod(i,10)==0:
                scio.savemat(pathsave,{'res':res})
        scio.savemat(pathsave,{'res':res})
    
    
    
    
    
    
    
    
    
    
    
