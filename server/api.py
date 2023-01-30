import asyncio
from glob import glob
import os.path
from pathlib import Path
import random

from fastapi import FastAPI, HTTPException, Security, UploadFile
from fastapi.responses import FileResponse
from fastapi.security.api_key import APIKeyHeader
from pydantic import BaseModel


API_KEY = 'stsRvxw3RbM6zaI1qXwknZQQ30xQ9QtEFKZedcusTC2y5nx7'
API_KEY_HEADER = 'X-Api-Key'

api_key_header_auth = APIKeyHeader(name=API_KEY_HEADER, auto_error=False)
app = FastAPI()

async def require_api_key(api_key_header: str = Security(api_key_header_auth)):
    if api_key_header != API_KEY:
        raise HTTPException(status_code=401, detail="Unauthorized")

async def periodic_task():
    while True:
        # print('hello world', flush=True)
        await asyncio.sleep(60)

@app.on_event("startup")
async def schedule_periodic():
    loop = asyncio.get_event_loop()
    loop.create_task(periodic_task())

@app.get('/match', dependencies=[Security(require_api_key)])
def get_match():
    return {
        "name": random.choice(glob('nn/nn-*.nnue')).split("/")[-1],
        "tc": random.choices(["25k", "stc", "ltc"], weights=[1, 4, 12])[0]
    }

@app.get('/nn', dependencies=[Security(require_api_key)])
def get_nn(name = ''):
    nn_filepath = f'nn/{name}'
    if os.path.isfile(nn_filepath):
        return FileResponse(nn_filepath,
            media_type='application/octet-stream',
            filename=name)
    else:
        raise HTTPException(status_code=404, detail="File not found")

@app.post('/pgns', dependencies=[Security(require_api_key)])
def create_pgn(pgn: UploadFile, nn_name: str):
    nn_pgn_dir = f'pgns/{nn_name}'
    Path(nn_pgn_dir).mkdir(parents=True, exist_ok=True)
    print(f'Saving file: {pgn.filename} to {nn_pgn_dir}')
    contents = pgn.file.read()
    with open(f'{nn_pgn_dir}/{pgn.filename}', 'wb') as f:
        f.write(contents)
    pgn.file.close()
    return {"success": f'{pgn.filename} saved to {nn_pgn_dir}'}
