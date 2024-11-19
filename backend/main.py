

from fastapi import FastAPI
from pydantic import BaseModel
from typing import Union
app = FastAPI()
from fastapi.middleware.cors import CORSMiddleware
from sqlmodel import  Session
import MVC as MVC
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

    with Session(MVC.engine) as session:
        subjects = MVC.get_academic_years_with_relations(session)
        res = MVC.convert_academic_years_to_dict(subjects)

        return {"res": res}

@app.get("/All_data")
async def get_data1():
    with Session(MVC.engine) as session:
        subjects = MVC.get_academic_years_with_relations(session)
        res = MVC.convert_academic_years_to_dict(subjects)

        return {"res": res}

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