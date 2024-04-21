import uvicorn
import asyncio
import random
import pandas as pd
import sqlite3
import re

from fastapi import FastAPI
from pydantic import BaseModel
from joblib import load
from nltk.corpus import stopwords

app = FastAPI()

conn = sqlite3.connect('gds-hackaton.db')
cursor = conn.cursor()

# Greeting
@app.post('/greeting')
async def greeting(answer: dict) -> dict:
    try:
        language = answer.get('language')

        df: pd
        
        if language == 'en':
            df = pd.read_csv('./datasets/greeting/greeting_en.csv')
        
        if language == 'kk':
            df = pd.read_csv('./datasets/greeting/greeting_kk.csv')

        if language == 'ru':
            df = pd.read_csv('./datasets/greeting/greeting_ru.csv')

        lng = language

        random_index = random.randint(0, len(df) - 1)

        answer = df.loc[random_index, 'answer']

        return {"result": answer}
    except Exception as e:
        print(e)


@app.post('/trending-question')
async def trending_question(answer: dict) -> dict:
    try:
        language = answer.get('language')

        df: pd

        if language == 'en':
            df = pd.read_csv('./datasets/trending/trending_en.csv')
        
        if language == 'kk':
            df = pd.read_csv('./datasets/trending/trending_kk.csv')

        if language == 'ru':
            df = pd.read_csv('./datasets/trending/trending_ru.csv')

        random_index = random.randint(0, len(df) - 1)

        answer = df.loc[random_index, 'answer']

        return {"result": answer}
    except Exception as e:
        print(e)


@app.post('/trending')
async def trending(answer: dict) -> dict:
    try:
        language = answer.get('language')

        df: pd

        if language == 'en':
            df = pd.read_csv('./datasets/attractions/attractions_data_en.csv')
        
        if language == 'kk':
            df = pd.read_csv('./datasets/attractions/attractions_data_kk.csv')

        if language == 'ru':
            df = pd.read_csv('./datasets/attractions/attractions_data_ru.csv')

        cursor.execute('''
            SELECT id FROM trends ORDER BY transition_counts DESC LIMIT 5
        ''')

        trendings_id = cursor.fetchall()

        trendings_id = [int(item[0]) for item in trendings_id]
    
        result = []

        for idx in df.index:
            for trend_id in trendings_id:
                if idx == trend_id:
                    result.append(df.iloc[idx].to_dict())

        
        return {"result": result}
    except Exception as e:
        print(e)

@app.post('/attraction-question')
async def attraction_question(answer: dict) -> dict:
    try:
        sentence = [answer.get('request')]
        
        sentence_df = pd.DataFrame({"question": sentence})

        pre_process = nlp_process(sentence_df)

       

        title = answer.get('title')

        df = pd.read_csv('./datasets/attractions/attractions_data_en.csv')

        index: int  # Initialize with a default value indicating it hasn't been assigned

        for idx in df.index:
        
            if df['Title'][idx] == title:
                index = idx

        # Handle the case where index is not assigned inside the loop
        if index == -1:
            # Do something when title is not found
            pass

        loaded_model = load(f'./datasets/about/predict_model_{index}.joblib')
        # Предсказание ответов на вопросы
        for i, sentence in enumerate(pre_process['question']):
            predicted_class = loaded_model.predict([sentence])
            print(f"Question {i + 1}: {sentence}")
            print(f"Predicted Answer: {predicted_class[0]}")

            print("-------------------------------------")
        result = loaded_model.predict(pre_process['question'])
        
        return {"result": result[0]}

    except Exception as e:
        print(e)

@app.post('/attractions-all')
async def attractions_all(answer: dict) -> dict:
    try:
        language = answer.get('language')

        if language == 'en':
            df = pd.read_csv('./datasets/attractions/attractions_data_en.csv')
            
        if language == 'kk':
            df = pd.read_csv('./datasets/attractions/attractions_data_kk.csv')

        if language == 'ru':
            df = pd.read_csv('./datasets/attractions/attractions_data_ru.csv')

        result = []
        for idx in df.index:
            result.append(df.iloc[idx].to_dict())

        return {"result": result}

    except Exception as e:
        print(e)

@app.post('/attraction')
async def attraction(answer: dict) -> dict:
    try:
        language = answer.get('language')
        title = answer.get('title')

        df: pd

        result = []

        if language == 'en':
            df = pd.read_csv('./datasets/attractions/attractions_data_en.csv')
            
        if language == 'kk':
            df = pd.read_csv('./datasets/attractions/attractions_data_kk.csv')

        if language == 'ru':
            df = pd.read_csv('./datasets/attractions/attractions_data_ru.csv')
        
        for idx in df.index:
            if df['Title'][idx] == title:
                result.append(df.iloc[idx].to_dict())

        return {"result": result}
        

    except Exception as e:
        print(e)

@app.post('/astana-bot')
async def astana_bot(answer: dict) -> dict:
    try:
        result = []

        sentence = [answer.get('request')]
        
        sentence_df = pd.DataFrame({"question": sentence})

        pre_process = nlp_process(sentence_df)


        loaded_model = load(f'./datasets/about/astanamodel.joblib')
            # Предсказание ответов на вопросы
        for i, sentence in enumerate(pre_process['question']):
            predicted_class = loaded_model.predict([sentence])
            print(f"Question {i + 1}: {sentence}")
            print(f"Predicted Answer: {predicted_class[0]}")

            print("-------------------------------------")
        result = loaded_model.predict(pre_process['question'])
                
        return {"result": result[0]}


    except Exception as e:
        print(e)


# NLP processing
", ".join(stopwords.words('english'))
STOPWORDS = set(stopwords.words('english'))

def remove_urls(text):
    url_remove = re.compile(r'https?://\S+|www\.\S+')
    return url_remove.sub(r'', text)

def remove_html(text):
    html=re.compile(r'<.*?>')
    return html.sub(r'',text)

def lower(text):
    low_text= text.lower()
    return low_text

def remove_num(text):
    remove= re.sub(r'\d+', '', text)
    return remove

def punct_remove(text):
    punct = re.sub(r"[^\w\s\d]","", text)
    return punct

def remove_stopwords(text):
    """custom function to remove the stopwords"""
    return " ".join([word for word in str(text).split() if word not in STOPWORDS])

def remove_mention(x):
    text=re.sub(r'@\w+','',x)
    return text

def remove_hash(x):
    text=re.sub(r'#\w+','',x)
    return text

def remove_space(text):
    space_remove = re.sub(r"\s+"," ",text).strip()
    return space_remove

def nlp_process(df):
    df['question']=df['question'].apply(lambda x:remove_urls(x))
    df['question']=df['question'].apply(lambda x:remove_html(x))
    df['question']=df['question'].apply(lambda x:lower(x))
    df['question']=df['question'].apply(lambda x:remove_num(x))
    df['question']=df['question'].apply(lambda x:punct_remove(x))
    df['question']=df['question'].apply(lambda x:remove_stopwords(x))
    df['question']=df['question'].apply(lambda x:remove_mention(x))
    df['question']=df['question'].apply(lambda x:remove_hash(x))
    df['question']=df['question'].apply(lambda x:remove_space(x))
    return df

# Server Settings && Main
async def main():
    config = uvicorn.Config("server:app", host = '0.0.0.0', port = 3000, log_level = 'info')
    server = uvicorn.Server(config = config)
    # Remove if db is not created!
    #await db_config()
    await server.serve()

# Database for Trending & Configuration
class Trend(BaseModel):
    id: int
    transition_counts: int

async def db_config():
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS trends (
            id INTEGER PRIMARY KEY,
            transition_counts INTEGER
        )
    ''')
    conn.commit()

    df = pd.read_csv('./datasets/attractions/attractions_data_en.csv')

    for idx in df.index:

        cursor.execute('''
            INSERT INTO trends (id, transition_counts)
            VALUES (?, ?)
        ''', (idx, 0))

        conn.commit()


if __name__ == '__main__':
    asyncio.run(main())