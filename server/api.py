from glob import glob
import os.path
import random
from fastapi import FastAPI, UploadFile
from fastapi.responses import FileResponse
from pathlib import Path
from pydantic import BaseModel

API_KEY = 'stsRvxw3RbM6zaI1qXwknZQQ30xQ9QtEFKZedcusTC2y5nx7'
app = FastAPI()

@app.get('/match')
def get_match(api_key = ''):
    if api_key != API_KEY: return {"error": "Unauthorized"}
    return {
        "name": random.choice(glob('nn/nn-*.nnue')).split("/")[-1],
        "tc": random.choices(["25k", "stc", "ltc"], weights=[1, 3, 6])[0]
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
def create_pgn(api_key: str, uploaded: UploadFile, name: str):
    if api_key != API_KEY: return {"error": "Unauthorized"}
    nn_pgn_dir = f'pgns/{name}/{uploaded.filename}'
    Path(nn_pgn_dir).mkdir(parents=True, exist_ok=True)
    print(f'Saving file: {uploaded.filename} to {nn_pgn_dir}')
    contents = uploaded.file.read()
    with open(f'{nn_pgn_dir}/{uploaded.filename}', 'wb') as f:
        f.write(contents)
    uploaded.file.close()
    return {"success": f'{uploaded.filename} saved to {nn_pgn_dir}'}
