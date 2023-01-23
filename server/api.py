from glob import glob
import os.path
import random
from fastapi import FastAPI, UploadFile
from fastapi.responses import FileResponse
from pydantic import BaseModel

API_KEY = 'stsRvxw3RbM6zaI1qXwknZQQ30xQ9QtEFKZedcusTC2y5nx7'
app = FastAPI()

@app.get('/match')
def get_match(api_key = ''):
    if api_key != API_KEY: return {"error": "Unauthorized"}
    return {
        "name": random.choice(glob('nn/nn-*.nnue')).split("/")[-1],
        "tc": random.choice(["25k", "stc", "stc", "stc", "ltc", "ltc", "ltc", "ltc", "ltc", "ltc"])
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
def post_pgns(api_key: str, file: UploadFile):
    if api_key != API_KEY: return {"error": "Unauthorized"}
    print(f'Saving file: {file.filename}')
    contents = file.file.read()
    with open(f'pgns/{file.filename}', 'wb') as f:
        f.write(contents)
    file.file.close()
    return {"success": f'{file.filename} saved'}
