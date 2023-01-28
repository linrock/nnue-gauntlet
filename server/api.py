import asyncio
from glob import glob
import os.path
from pathlib import Path
import random

from fastapi import FastAPI, UploadFile
from fastapi.responses import FileResponse
from pydantic import BaseModel


API_KEY = 'stsRvxw3RbM6zaI1qXwknZQQ30xQ9QtEFKZedcusTC2y5nx7'
app = FastAPI()

async def periodic_task():
    while True:
        # print('hello world', flush=True)
        await asyncio.sleep(60)

@app.on_event("startup")
async def schedule_periodic():
    loop = asyncio.get_event_loop()
    loop.create_task(periodic_task())

@app.get('/match')
def get_match(api_key = ''):
    if api_key != API_KEY: return {"error": "Unauthorized"}
    return {
        "name": random.choice(glob('nn/nn-*.nnue')).split("/")[-1],
        "tc": random.choices(["25k", "stc", "ltc"], weights=[1, 4, 12])[0]
    }

@app.get('/nn')
def get_nn(api_key = '', name = ''):
    if api_key != API_KEY: return {"error": "Unauthorized"}
    nn_filepath = f'nn/{name}'
    if os.path.isfile(nn_filepath):
        return FileResponse(nn_filepath,
            media_type='application/octet-stream',
            filename=name)
    else:
        return {"error": "File not found"}

@app.post('/pgns')
def create_pgn(api_key: str, pgn: UploadFile, nn_name: str):
    if api_key != API_KEY: return {"error": "Unauthorized"}
    nn_pgn_dir = f'pgns/{nn_name}'
    Path(nn_pgn_dir).mkdir(parents=True, exist_ok=True)
    print(f'Saving file: {pgn.filename} to {nn_pgn_dir}')
    contents = pgn.file.read()
    with open(f'{nn_pgn_dir}/{pgn.filename}', 'wb') as f:
        f.write(contents)
    pgn.file.close()
    return {"success": f'{pgn.filename} saved to {nn_pgn_dir}'}
