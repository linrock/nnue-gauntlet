from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()
API_KEY = 'stsRvxw3RbM6zaI1qXwknZQQ30xQ9QtEFKZedcusTC2y5nx7'

@app.get('/gauntlet')
def get_gauntlet(api_key = ''):
    if api_key != API_KEY:
        return {"error": "Unauthorized"}
    return {"Hello": "World"}

class JsonRequestData(BaseModel):
    api_key: str = ''
    pgns: str

@app.post('/pgns')
def post_pgns(req: JsonRequestData):
    if api_key != API_KEY:
        return {"error": "Unauthorized"}
    return {"success": "pgn saved"}
