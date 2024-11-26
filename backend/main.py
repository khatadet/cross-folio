


from fastapi import FastAPI, Response, status
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

class add_education_data(BaseModel):
    year: int 
    subject: int 
    semester: int 
    detail: str | None = None

class add_subject(BaseModel):
    code:str | None = None
    name:str | None = None

class update_education_data(BaseModel):
    id:int 
    detail:str | None = None

class     add_education_data_v2(BaseModel):
    semester_id:int
    subject_id:int
    detail:str | None = None

class body_year(BaseModel):
    year: str | None = None
    

with Session(MVC.engine) as session:
    MVC.check_and_create_required_data(session)

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

@app.get("/getList_semester_names")
async def get_semesters():

    with Session(MVC.engine) as session:
        subjects = MVC.get_all_semester_names(session)
        res = subjects

        return {"res": res}

@app.get("/getList_year")
async def get_semesters():

    with Session(MVC.engine) as session:
        subjects = MVC.get_all_academic_years(session)
        res = subjects
        return {"res": res}

@app.get("/getList_subject")
async def get_semesters():

    with Session(MVC.engine) as session:
        subjects = MVC.get_all_subjects(session)
        res = subjects
        return {"res": res}

@app.post("/add_subject")
async def func_add_subject(item:add_subject):

    # print(item)
    with Session(MVC.engine) as session:
        subject = MVC.create_subject(session,item.name,item.code)
        print(subject)

    return {"message":"Save Success"}

@app.post("/add_education_data/", status_code=200)
async def func_add_education_data(item: add_education_data, response: Response):
    print(item)
    with Session(MVC.engine) as session:
        semester = MVC.get_semester_by_year_name(session,item.year,item.semester)
        check = MVC.get_education_data_by_semester_subject(session,semester.id,item.subject)
        if check:
            response.status_code = status.HTTP_400_BAD_REQUEST
            return {"message":"error"}
        MVC.create_education_data(
            session,
                detail=item.detail,
                semester_id=semester.id,
                subject_id=item.subject,
        )

    return {"message":"Save Success"}


@app.post("/add_education_data_v2/", status_code=200)
async def func_add_education_data_v2(item: add_education_data_v2, response: Response):
    print(item)
    with Session(MVC.engine) as session:
        
        check = MVC.get_education_data_by_semester_subject(session,item.semester_id,item.subject_id)
        if check:
            response.status_code = status.HTTP_400_BAD_REQUEST
            return {"message":"error"}
        MVC.create_education_data(
            session,
                detail=item.detail,
                semester_id=item.semester_id,
                subject_id=item.subject_id,
        )

    return {"message":"Save Success"}

@app.post("/manual_add_semester/", status_code=200)
async def func_manual_add_semester(item:body_year, response: Response ):
    print(item.year)
    with Session(MVC.engine) as session:
        academic_year_name = "ปีการศึกษา "+str(item.year)
        academic_year = session.exec(MVC.select(MVC.AcademicYear).where(MVC.AcademicYear.name == academic_year_name)).first()
        
        if academic_year:
            response.status_code = status.HTTP_400_BAD_REQUEST
            return {"message":"error"}
        academic_year = MVC.create_academic_year(session, academic_year_name)

        semester_names = MVC.get_all_semester_names(session)
        for i in semester_names:
            MVC.create_semester(session,academic_year_id= academic_year.id,semester_name_id= i.id)
        
    return {"message":"Save Success"}

@app.put("/update_education_data")
async def func_update_education_data(item:update_education_data):

    print(item)
    with Session(MVC.engine) as session:

        subject = MVC.update_detail_education_data(session,item.id,item.detail)
        print(subject)

    return {"message":"Save Success"}

@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}

# if __name__ == "__main__":
#     import uvicorn
#     uvicorn.run("main:app", host="localhost", port=8000, reload=True)