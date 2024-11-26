#!/bin/bash

# สคริปต์นี้จะสร้างโครงสร้างโฟลเดอร์และไฟล์สำหรับโปรเจค MVC

# ชื่อโปรเจค
PROJECT_NAME="Backend"

# สร้างโฟลเดอร์หลัก
mkdir -p "$PROJECT_NAME"

cd "$PROJECT_NAME" || exit

# สร้างโฟลเดอร์ model, controller, view พร้อมไฟล์ __init__.py
mkdir -p model controller view

touch model/__init__.py
touch controller/__init__.py
touch view/__init__.py

# สร้างไฟล์ model/database.py
cat << 'EOF' > model/database.py
from sqlmodel import SQLModel, create_engine, Session

sqlite_file_name = "database.db"
sqlite_url = f"sqlite:///{sqlite_file_name}"
engine = create_engine(sqlite_url, echo=True)

def get_session():
    with Session(engine) as session:
        yield session
EOF

# สร้างไฟล์ model/academic_year.py
cat << 'EOF' > model/academic_year.py
from typing import List, Optional
from sqlmodel import SQLModel, Field, Relationship

class AcademicYear(SQLModel, table=True):
    __tablename__ = "academicyear"
    id: Optional[int] = Field(default=None, primary_key=True)
    name: str = Field(unique=True)
    semesters: List["Semester"] = Relationship(back_populates="academic_year")
EOF

# สร้างไฟล์ model/semester_name.py
cat << 'EOF' > model/semester_name.py
from typing import List, Optional
from sqlmodel import SQLModel, Field, Relationship

class SemesterName(SQLModel, table=True):
    __tablename__ = "semestername"
    id: Optional[int] = Field(default=None, primary_key=True)
    name: str = Field(unique=True)
    semesters: List["Semester"] = Relationship(back_populates="semester_name")
EOF

# สร้างไฟล์ model/semester.py
cat << 'EOF' > model/semester.py
from typing import List, Optional
from sqlmodel import SQLModel, Field, Relationship

class Semester(SQLModel, table=True):
    __tablename__ = "semester"
    id: Optional[int] = Field(default=None, primary_key=True)
    academic_year_id: int = Field(foreign_key="academicyear.id")
    semester_name_id: int = Field(foreign_key="semestername.id")

    academic_year: "AcademicYear" = Relationship(back_populates="semesters")
    semester_name: "SemesterName" = Relationship(back_populates="semesters")
    education_data: List["EducationData"] = Relationship(back_populates="semester")
EOF

# สร้างไฟล์ model/subject.py
cat << 'EOF' > model/subject.py
from typing import List, Optional
from sqlmodel import SQLModel, Field, Relationship

class Subject(SQLModel, table=True):
    __tablename__ = "subject"
    id: Optional[int] = Field(default=None, primary_key=True)
    name: str = Field(unique=True)
    code: str = Field(unique=True)
    education_data: List["EducationData"] = Relationship(back_populates="subject")
EOF

# สร้างไฟล์ model/education_data.py
cat << 'EOF' > model/education_data.py
from typing import Optional
from sqlmodel import SQLModel, Field, Relationship

class EducationData(SQLModel, table=True):
    __tablename__ = "educationdata"
    id: Optional[int] = Field(default=None, primary_key=True)
    detail: str

    semester_id: int = Field(foreign_key="semester.id")
    subject_id: int = Field(foreign_key="subject.id")

    semester: "Semester" = Relationship(back_populates="education_data")
    subject: "Subject" = Relationship(back_populates="education_data")
EOF

# สร้างไฟล์ model/__init__.py
cat << 'EOF' > model/__init__.py
from .database import engine
from .academic_year import AcademicYear
from .semester_name import SemesterName
from .semester import Semester
from .subject import Subject
from .education_data import EducationData

# สร้างตารางในฐานข้อมูล
SQLModel.metadata.create_all(engine)
EOF

# สร้างไฟล์ controller/academic_year_controller.py
cat << 'EOF' > controller/academic_year_controller.py
from typing import List, Optional
from sqlmodel import Session, select
from model.academic_year import AcademicYear

def create_academic_year(session: Session, name: str) -> AcademicYear:
    academic_year = AcademicYear(name=name)
    session.add(academic_year)
    session.commit()
    session.refresh(academic_year)
    return academic_year

def get_academic_year(session: Session, academic_year_id: int) -> Optional[AcademicYear]:
    return session.get(AcademicYear, academic_year_id)

def get_all_academic_years(session: Session) -> List[AcademicYear]:
    return session.exec(select(AcademicYear)).all()

def update_academic_year(session: Session, academic_year_id: int, name: str) -> Optional[AcademicYear]:
    academic_year = session.get(AcademicYear, academic_year_id)
    if academic_year:
        academic_year.name = name
        session.add(academic_year)
        session.commit()
        session.refresh(academic_year)
        return academic_year
    else:
        return None

def delete_academic_year(session: Session, academic_year_id: int) -> bool:
    academic_year = session.get(AcademicYear, academic_year_id)
    if academic_year:
        session.delete(academic_year)
        session.commit()
        return True
    else:
        return False
EOF

# สร้างไฟล์ controller/semester_name_controller.py
cat << 'EOF' > controller/semester_name_controller.py
from typing import List, Optional
from sqlmodel import Session, select
from model.semester_name import SemesterName

def create_semester_name(session: Session, name: str) -> SemesterName:
    semester_name = SemesterName(name=name)
    session.add(semester_name)
    session.commit()
    session.refresh(semester_name)
    return semester_name

def get_semester_name(session: Session, semester_name_id: int) -> Optional[SemesterName]:
    return session.get(SemesterName, semester_name_id)

def get_all_semester_names(session: Session) -> List[SemesterName]:
    return session.exec(select(SemesterName)).all()

def update_semester_name(session: Session, semester_name_id: int, name: str) -> Optional[SemesterName]:
    semester_name = session.get(SemesterName, semester_name_id)
    if semester_name:
        semester_name.name = name
        session.add(semester_name)
        session.commit()
        session.refresh(semester_name)
        return semester_name
    else:
        return None

def delete_semester_name(session: Session, semester_name_id: int) -> bool:
    semester_name = session.get(SemesterName, semester_name_id)
    if semester_name:
        session.delete(semester_name)
        session.commit()
        return True
    else:
        return False
EOF

# สร้างไฟล์ controller/semester_controller.py
cat << 'EOF' > controller/semester_controller.py
from typing import List, Optional
from sqlmodel import Session, select
from model.semester import Semester
from controller.academic_year_controller import get_academic_year
from controller.semester_name_controller import get_semester_name, create_semester_name, create_semester

def create_semester(session: Session, academic_year_id: int, semester_name_id: int) -> Semester:
    semester = Semester(academic_year_id=academic_year_id, semester_name_id=semester_name_id)
    session.add(semester)
    session.commit()
    session.refresh(semester)
    return semester

def get_semester(session: Session, semester_id: int) -> Optional[Semester]:
    return session.get(Semester, semester_id)

def get_semester_by_year_name(session: Session, academic_year_id: int, semester_name_id: int) -> Optional[Semester]:
    semester = session.exec(
        select(Semester).where(
            Semester.academic_year_id == academic_year_id,
            Semester.semester_name_id == semester_name_id
        )
    ).first()
    if not semester:
        semester = create_semester(session, academic_year_id, semester_name_id)
        print('Created new Semester')
    else:
        print('Existing Semester found')
    return semester

def get_all_semesters(session: Session) -> List[Semester]:
    return session.exec(select(Semester)).all()

def update_semester(session: Session, semester_id: int, academic_year_id: int, semester_name_id: int) -> Optional[Semester]:
    semester = session.get(Semester, semester_id)
    if semester:
        semester.academic_year_id = academic_year_id
        semester.semester_name_id = semester_name_id
        session.add(semester)
        session.commit()
        session.refresh(semester)
        return semester
    else:
        return None

def delete_semester(session: Session, semester_id: int) -> bool:
    semester = session.get(Semester, semester_id)
    if semester:
        session.delete(semester)
        session.commit()
        return True
    else:
        return False
EOF

# สร้างไฟล์ controller/subject_controller.py
cat << 'EOF' > controller/subject_controller.py
from typing import List, Optional
from sqlmodel import Session, select
from model.subject import Subject

def create_subject(session: Session, name: str, code: str) -> Subject:
    subject = Subject(name=name, code=code)
    session.add(subject)
    session.commit()
    session.refresh(subject)
    return subject

def get_subject(session: Session, subject_id: int) -> Optional[Subject]:
    return session.get(Subject, subject_id)

def get_all_subjects(session: Session) -> List[Subject]:
    return session.exec(select(Subject)).all()

def update_subject(session: Session, subject_id: int, name: str, code: str) -> Optional[Subject]:
    subject = session.get(Subject, subject_id)
    if subject:
        subject.name = name
        subject.code = code
        session.add(subject)
        session.commit()
        session.refresh(subject)
        return subject
    else:
        return None

def delete_subject(session: Session, subject_id: int) -> bool:
    subject = session.get(Subject, subject_id)
    if subject:
        session.delete(subject)
        session.commit()
        return True
    else:
        return False
EOF

# สร้างไฟล์ controller/education_data_controller.py
cat << 'EOF' > controller/education_data_controller.py
from typing import List, Optional
from sqlmodel import Session, select
from model.education_data import EducationData

def create_education_data(session: Session, detail: str, semester_id: int, subject_id: int) -> EducationData:
    education_data = EducationData(detail=detail, semester_id=semester_id, subject_id=subject_id)
    session.add(education_data)
    session.commit()
    session.refresh(education_data)
    return education_data

def get_education_data(session: Session, education_data_id: int) -> Optional[EducationData]:
    return session.get(EducationData, education_data_id)

def get_all_education_data(session: Session) -> List[EducationData]:
    return session.exec(select(EducationData)).all()

def get_education_data_by_semester_subject(session: Session, semester_id: int, subject_id: int) -> List[EducationData]:
    education_data = session.exec(select(EducationData)).all()
    res = [i for i in education_data if i.semester_id == semester_id and i.subject_id == subject_id]
    return res

def update_education_data(session: Session, education_data_id: int, detail: str, semester_id: int, subject_id: int) -> Optional[EducationData]:
    education_data = session.get(EducationData, education_data_id)
    if education_data:
        education_data.detail = detail
        education_data.semester_id = semester_id
        education_data.subject_id = subject_id
        session.add(education_data)
        session.commit()
        session.refresh(education_data)
        return education_data
    else:
        return None

def delete_education_data(session: Session, education_data_id: int) -> bool:
    education_data = session.get(EducationData, education_data_id)
    if education_data:
        session.delete(education_data)
        session.commit()
        return True
    else:
        return False
EOF

# สร้างไฟล์ controller/utils.py
cat << 'EOF' > controller/utils.py
from typing import List
from sqlmodel import Session, select, selectinload
from datetime import datetime
from model.academic_year import AcademicYear
from controller.academic_year_controller import create_academic_year
from controller.semester_name_controller import create_semester_name, get_semester_name
from controller.semester_controller import create_semester
from controller.education_data_controller import create_education_data
from controller.subject_controller import create_subject
from model.semester import Semester
from model.education_data import EducationData
from model.subject import Subject
from model.semester_name import SemesterName

def get_academic_years_with_relations(session: Session) -> List[AcademicYear]:
    academic_years = session.exec(
        select(AcademicYear).options(
            selectinload(AcademicYear.semesters).selectinload(Semester.semester_name),
            selectinload(AcademicYear.semesters).selectinload(Semester.education_data).selectinload(EducationData.subject)
        )
    ).all()
    return academic_years

def convert_academic_years_to_dict(academic_years: List[AcademicYear]) -> List[dict]:
    result = []
    for ay in academic_years:
        ay_dict = {
            "id": ay.id,
            "name": ay.name,
            "semesters": []
        }
        for sem in ay.semesters:
            sem_dict = {
                "id": sem.id,
                "name": sem.semester_name.name,
                "education_data": []
            }
            for edu_data in sem.education_data:
                edu_dict = {
                    "id": edu_data.id,
                    "detail": edu_data.detail,
                    "subject": {
                        "id": edu_data.subject.id,
                        "name": edu_data.subject.name,
                        "code": edu_data.subject.code
                    }
                }
                sem_dict["education_data"].append(edu_dict)
            ay_dict["semesters"].append(sem_dict)
        result.append(ay_dict)
    return result

def check_and_create_required_data(session: Session):
    # ตรวจสอบปีการศึกษาปัจจุบัน
    current_year = datetime.now().year + 543  # แปลงเป็นปีพุทธศักราช
    academic_year_name = f"ปีการศึกษา {current_year}"
    academic_year = session.exec(
        select(AcademicYear).where(AcademicYear.name == academic_year_name)
    ).first()
    if not academic_year:
        academic_year = create_academic_year(session, academic_year_name)
        print(f"Created AcademicYear: {academic_year.name}")
    else:
        print(f"AcademicYear {academic_year.name} already exists.")

    # ตรวจสอบชื่อภาคการศึกษา "ภาคการศึกษาที่ 1", "ภาคการศึกษาที่ 2", "ภาคการศึกษาที่ 3"
    semester_names = [f"ภาคการศึกษาที่ {i}" for i in ["1", "2", "3"]]
    for sem_name in semester_names:
        semester_name = session.exec(
            select(SemesterName).where(SemesterName.name == sem_name)
        ).first()
        if not semester_name:
            semester_name = create_semester_name(session, sem_name)
            print(f"Created SemesterName: {semester_name.name}")
        else:
            print(f"SemesterName {semester_name.name} already exists.")

    # ตรวจสอบและสร้างภาคการศึกษา
    for sem_name in semester_names:
        semester_name = session.exec(
            select(SemesterName).where(SemesterName.name == sem_name)
        ).first()
        semester = session.exec(
            select(Semester)
            .where(Semester.academic_year_id == academic_year.id)
            .where(Semester.semester_name_id == semester_name.id)
        ).first()
        if not semester:
            semester = create_semester(session, academic_year.id, semester_name.id)
            print(f"Created Semester for AcademicYear {academic_year.name} and SemesterName {semester_name.name}")
        else:
            print(f"Semester for AcademicYear {academic_year.name} and SemesterName {semester_name.name} already exists.")

    # ตรวจสอบปีการศึกษาปีที่แล้ว
    previous_year = current_year - 1
    academic_year_prev = session.exec(
        select(AcademicYear).where(AcademicYear.name == f"ปีการศึกษา {previous_year}")
    ).first()
    if not academic_year_prev:
        academic_year_prev = create_academic_year(session, f"ปีการศึกษา {previous_year}")
        print(f"Created AcademicYear: {academic_year_prev.name}")
    else:
        print(f"AcademicYear {academic_year_prev.name} already exists.")

    # ตรวจสอบและสร้างภาคการศึกษาในปีการศึกษาปีที่แล้ว
    for sem_name in semester_names:
        semester_name = session.exec(
            select(SemesterName).where(SemesterName.name == sem_name)
        ).first()
        semester = session.exec(
            select(Semester)
            .where(Semester.academic_year_id == academic_year_prev.id)
            .where(Semester.semester_name_id == semester_name.id)
        ).first()
        if not semester:
            semester = create_semester(session, academic_year_prev.id, semester_name.id)
            print(f"Created Semester for AcademicYear {academic_year_prev.name} and SemesterName {semester_name.name}")
        else:
            print(f"Semester for AcademicYear {academic_year_prev.name} and SemesterName {semester_name.name} already exists.")
EOF

# สร้างไฟล์ view/main.py
cat << 'EOF' > view/main.py
from fastapi import FastAPI, Response, status
from pydantic import BaseModel
from typing import Union
from fastapi.middleware.cors import CORSMiddleware
from sqlmodel import Session
from model import database, __init__  # Import โมเดลและการสร้างตาราง
from controller import (
    academic_year_controller as ay_ctrl,
    semester_name_controller as sn_ctrl,
    semester_controller as sem_ctrl,
    subject_controller as subj_ctrl,
    education_data_controller as edu_ctrl,
    utils
)

app = FastAPI()

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

# กำหนด Pydantic models สำหรับ request bodies
class AddEducationData(BaseModel):
    year: int 
    subject: int 
    semester: int 
    detail: Union[str, None] = None

class AddSubject(BaseModel):
    name: str
    code: str

# Event สำหรับการเริ่มต้นแอป
@app.on_event("startup")
def on_startup():
    # สร้างตารางในฐานข้อมูล
    __init__.SQLModel.metadata.create_all(database.engine)
    # ตรวจสอบและสร้างข้อมูลที่จำเป็น
    with Session(database.engine) as session:
        utils.check_and_create_required_data(session)

@app.get("/")
async def get_data():
    with Session(database.engine) as session:
        academic_years = utils.get_academic_years_with_relations(session)
        res = utils.convert_academic_years_to_dict(academic_years)
        return {"res": res}

@app.get("/All_data")
async def get_all_data():
    with Session(database.engine) as session:
        academic_years = utils.get_academic_years_with_relations(session)
        res = utils.convert_academic_years_to_dict(academic_years)
        return {"res": res}

@app.get("/getList_semester_names")
async def get_semester_names():
    with Session(database.engine) as session:
        semester_names = sn_ctrl.get_all_semester_names(session)
        return {"res": semester_names}

@app.get("/getList_year")
async def get_years():
    with Session(database.engine) as session:
        academic_years = ay_ctrl.get_all_academic_years(session)
        return {"res": academic_years}

@app.get("/getList_subject")
async def get_subjects():
    with Session(database.engine) as session:
        subjects = subj_ctrl.get_all_subjects(session)
        return {"res": subjects}

@app.post("/add_education_data/", status_code=200)
async def add_education_data(item: AddEducationData, response: Response):
    print(item)
    with Session(database.engine) as session:
        semester = sem_ctrl.get_semester_by_year_name(session, item.year, item.semester)
        check = edu_ctrl.get_education_data_by_semester_subject(session, semester.id, item.subject)
        if check:
            response.status_code = status.HTTP_400_BAD_REQUEST
            return {"message": "error: Education data already exists for this semester and subject."}
        edu_ctrl.create_education_data(
            session,
            detail=item.detail,
            semester_id=semester.id,
            subject_id=item.subject,
        )
    return {"message": "Save Success"}

@app.post("/add_subject/", status_code=200)
async def add_subject(item: AddSubject, response: Response):
    with Session(database.engine) as session:
        subject = subj_ctrl.create_subject(session, item.name, item.code)
        print(subject)
    return {"message": "Save Success"}

@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}

# รันแอปด้วยคำสั่ง:
# uvicorn view.main:app --reload
EOF

# สร้างไฟล์ requirements.txt
cat << 'EOF' > requirements.txt
fastapi
uvicorn
sqlmodel
sqlalchemy
pydantic
EOF

# สร้างไฟล์ run.sh
cat << 'EOF' > run.sh
#!/bin/sh
dirpath=$(dirname "$(readlink -f "$0")")
# echo "Directory ปัจจุบันของไฟล์คือ: $dirpath"
cd "$dirpath/view"
fastapi dev main.py
# python3 main.py
EOF

# แสดงข้อความเมื่อเสร็จสิ้น
echo "โครงสร้างโปรเจค MVC ถูกสร้างเรียบร้อยแล้วในโฟลเดอร์ '$PROJECT_NAME'"
echo "คุณสามารถติดตั้ง dependencies ด้วยคำสั่ง:"
echo "  pip install -r requirements.txt"
echo "และรันแอปพลิเคชันด้วยคำสั่ง:"
echo "  uvicorn view.main:app --reload"
