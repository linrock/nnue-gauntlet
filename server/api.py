from glob import glob
import os.path
import random
from fastapi import FastAPI
from fastapi.responses import FileResponse
from pydantic import BaseModel

app = FastAPI()
API_KEY = 'stsRvxw3RbM6zaI1qXwknZQQ30xQ9QtEFKZedcusTC2y5nx7'

@app.get('/match')
def get_match(api_key = ''):
    if api_key != API_KEY: return {"error": "Unauthorized"}
    return {
        "name": random.choice(glob('nn/nn-*.nnue')),
        "tc": random.choice(["25k", "stc", "ltc"])
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

class JsonRequestData(BaseModel):
    api_key: str = ''
    pgns: str

@app.post('/pgns')
def post_pgns(req: JsonRequestData):
    if api_key != API_KEY: return {"error": "Unauthorized"}
    return {"success": "pgn saved"}
