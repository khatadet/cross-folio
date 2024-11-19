

from fastapi import FastAPI
from pydantic import BaseModel
from typing import Union
app = FastAPI()
from fastapi.middleware.cors import CORSMiddleware
origins = [
    "http://localhost:3000",  # ต้นทางของแอป React ของคุณ
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # หรือใช้ ["*"] ในการพัฒนา แต่ไม่แนะนำในโปรดักชัน
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
subject_init = { "detail" :"string",
"url":"#string"}
subject = [{'subject_name':i,'subject':[subject_init,subject_init]} for i in ['a' , 'b' , 'c']]
semester = list()
for i in range(2562,2568):
    for j in range(1,4):
        semester.append({'semester_name':f'ภาคการศึกษาที่ {j} / {i}','semester':subject})
"""
semester
    [{
    semester_name : str,
    semester : [{
        subject_name : str
        subject: [{
            detail : str
            url : str
            }]
        }]
    }]
"""

class add_subject(BaseModel):
    subject: str | None = None
    url: str | None = None
    semester: str | None = None


@app.get("/")
async def get_data():
    return {"res": semester}

@app.get("/semester")
async def get_semester():
    res = [i['semester_name'] for i in semester]
    return {"res": res}

@app.post("/add_subject/")
async def create_item(item: add_subject):
    print(item)
    return {"message":"Save Success"}

@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}