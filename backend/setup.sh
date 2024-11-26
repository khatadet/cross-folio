#!/bin/bash

# ชื่อโปรเจกต์
PROJECT_NAME="project"

# สร้างโครงสร้างโฟลเดอร์
echo "Creating project directory structure..."
mkdir -p $PROJECT_NAME/models
mkdir -p $PROJECT_NAME/controllers
mkdir -p $PROJECT_NAME/views

# สร้างไฟล์ database.py
echo "Creating database.py..."
cat <<EOF > $PROJECT_NAME/database.py
from sqlmodel import SQLModel, create_engine
from sqlalchemy.orm import sessionmaker

# กำหนดชื่อไฟล์ฐานข้อมูล SQLite และสร้าง engine
sqlite_file_name = "database.db"
sqlite_url = f"sqlite:///{sqlite_file_name}"
engine = create_engine(sqlite_url, echo=True)

# สร้าง SessionLocal สำหรับการใช้งาน Session
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def init_db():
    from models.academic_year import AcademicYear
    from models.semester_name import SemesterName
    from models.semester import Semester
    from models.subject import Subject
    from models.education_data import EducationData
    # สร้างตารางในฐานข้อมูล
    SQLModel.metadata.create_all(engine)
EOF

# สร้างไฟล์ models/__init__.py
echo "Creating models/__init__.py..."
cat <<EOF > $PROJECT_NAME/models/__init__.py
from .academic_year import AcademicYear
from .semester_name import SemesterName
from .semester import Semester
from .subject import Subject
from .education_data import EducationData
EOF

# สร้างไฟล์ models/academic_year.py
echo "Creating models/academic_year.py..."
cat <<EOF > $PROJECT_NAME/models/academic_year.py
from typing import List, Optional
from sqlmodel import SQLModel, Field, Relationship

class AcademicYear(SQLModel, table=True):
    __tablename__ = "academicyear"  # ชื่อตาราง ปีการศึกษา
    id: Optional[int] = Field(default=None, primary_key=True)  # รหัส ID ที่เพิ่มเองอัตโนมัติ
    name: str = Field(unique=True)  # ชื่อปีการศึกษา ที่ไม่ซ้ำกัน (unique)
    semesters: List["Semester"] = Relationship(back_populates="academic_year")  # ความสัมพันธ์กับตาราง Semester (ภาคการศึกษา)
EOF

# สร้างไฟล์ models/semester_name.py
echo "Creating models/semester_name.py..."
cat <<EOF > $PROJECT_NAME/models/semester_name.py
from typing import List, Optional
from sqlmodel import SQLModel, Field, Relationship

class SemesterName(SQLModel, table=True):
    __tablename__ = "semestername"  # ชื่อตาราง ชื่อภาคการศึกษา
    id: Optional[int] = Field(default=None, primary_key=True)  # รหัส ID ที่เพิ่มเองอัตโนมัติ
    name: str = Field(unique=True)  # ชื่อภาคการศึกษา ที่ไม่ซ้ำกัน (unique)
    semesters: List["Semester"] = Relationship(back_populates="semester_name")  # ความสัมพันธ์กับตาราง Semester
EOF

# สร้างไฟล์ models/semester.py
echo "Creating models/semester.py..."
cat <<EOF > $PROJECT_NAME/models/semester.py
from typing import List, Optional
from sqlmodel import SQLModel, Field, Relationship

class Semester(SQLModel, table=True):
    __tablename__ = "semester"  # ชื่อตาราง ภาคการศึกษา
    id: Optional[int] = Field(default=None, primary_key=True)  # รหัส ID ที่เพิ่มเองอัตโนมัติ
    academic_year_id: int = Field(foreign_key="academicyear.id")  # Foreign Key เชื่อมกับ AcademicYear
    semester_name_id: int = Field(foreign_key="semestername.id")  # Foreign Key เชื่อมกับ SemesterName

    academic_year: "AcademicYear" = Relationship(back_populates="semesters")  # ความสัมพันธ์กับ AcademicYear
    semester_name: "SemesterName" = Relationship(back_populates="semesters")  # ความสัมพันธ์กับ SemesterName
    education_data: List["EducationData"] = Relationship(back_populates="semester")  # ความสัมพันธ์กับ EducationData
EOF

# สร้างไฟล์ models/subject.py
echo "Creating models/subject.py..."
cat <<EOF > $PROJECT_NAME/models/subject.py
from typing import List, Optional
from sqlmodel import SQLModel, Field, Relationship

class Subject(SQLModel, table=True):
    __tablename__ = "subject"  # ชื่อตาราง วิชาที่สอน
    id: Optional[int] = Field(default=None, primary_key=True)  # รหัส ID ที่เพิ่มเองอัตโนมัติ
    name: str = Field(unique=True)  # ชื่อวิชา ที่ไม่ซ้ำกัน (unique)
    code: str = Field(unique=True)  # code ที่ไม่ซ้ำกัน (unique)
    education_data: List["EducationData"] = Relationship(back_populates="subject")  # ความสัมพันธ์กับ EducationData
EOF

# สร้างไฟล์ models/education_data.py
echo "Creating models/education_data.py..."
cat <<EOF > $PROJECT_NAME/models/education_data.py
from typing import Optional
from sqlmodel import SQLModel, Field, Relationship

class EducationData(SQLModel, table=True):
    __tablename__ = "educationdata"  # ชื่อตาราง ตารางข้อมูลการศึกษา
    id: Optional[int] = Field(default=None, primary_key=True)  # รหัส ID ที่เพิ่มเองอัตโนมัติ
    detail: str  # รายละเอียดของข้อมูลการศึกษา

    semester_id: int = Field(foreign_key="semester.id")  # Foreign Key เชื่อมกับ Semester
    subject_id: int = Field(foreign_key="subject.id")  # Foreign Key เชื่อมกับ Subject

    semester: "Semester" = Relationship(back_populates="education_data")  # ความสัมพันธ์กับ Semester
    subject: "Subject" = Relationship(back_populates="education_data")  # ความสัมพันธ์กับ Subject
EOF

# สร้างไฟล์ controllers/__init__.py
echo "Creating controllers/__init__.py..."
cat <<EOF > $PROJECT_NAME/controllers/__init__.py
from .academic_year_controller import *
from .semester_name_controller import *
from .semester_controller import *
from .subject_controller import *
from .education_data_controller import *
EOF

# สร้างไฟล์ controllers/academic_year_controller.py
echo "Creating controllers/academic_year_controller.py..."
cat <<EOF > $PROJECT_NAME/controllers/academic_year_controller.py
from typing import List, Optional
from sqlmodel import Session, select
from models.academic_year import AcademicYear

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

# สร้างไฟล์ controllers/semester_name_controller.py
echo "Creating controllers/semester_name_controller.py..."
cat <<EOF > $PROJECT_NAME/controllers/semester_name_controller.py
from typing import List, Optional
from sqlmodel import Session, select
from models.semester_name import SemesterName

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

# สร้างไฟล์ controllers/semester_controller.py
echo "Creating controllers/semester_controller.py..."
cat <<EOF > $PROJECT_NAME/controllers/semester_controller.py
from typing import List, Optional
from sqlmodel import Session, select, selectinload
from models.semester import Semester
from models.academic_year import AcademicYear
from models.semester_name import SemesterName

def create_semester(session: Session, academic_year_id: int, semester_name_id: int) -> Semester:
    semester = Semester(academic_year_id=academic_year_id, semester_name_id=semester_name_id)
    session.add(semester)
    session.commit()
    session.refresh(semester)
    return semester

def get_semester(session: Session, semester_id: int) -> Optional[Semester]:
    return session.get(Semester, semester_id)

def get_semester_by_year_name(session: Session, academic_year_id: int, semester_name_id: int) -> Optional[Semester]:
    semesters = session.exec(select(Semester)).all()
    semester_res = [i for i in semesters if i.academic_year_id == academic_year_id and i.semester_name_id == semester_name_id]
    if not semester_res:
        semester = create_semester(session, academic_year_id, semester_name_id)
        print('สร้างภาคการศึกษาใหม่')
        return semester
    else:
        print('ภาคการศึกษามีอยู่แล้ว')
        return semester_res[0]

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

# สร้างไฟล์ controllers/subject_controller.py
echo "Creating controllers/subject_controller.py..."
cat <<EOF > $PROJECT_NAME/controllers/subject_controller.py
from typing import List, Optional
from sqlmodel import Session, select
from models.subject import Subject

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

# สร้างไฟล์ controllers/education_data_controller.py
echo "Creating controllers/education_data_controller.py..."
cat <<EOF > $PROJECT_NAME/controllers/education_data_controller.py
from typing import List, Optional
from sqlmodel import Session, select
from models.education_data import EducationData

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
    return [i for i in education_data if i.semester_id == semester_id and i.subject_id == subject_id]

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

# สร้างไฟล์ views/main.py
echo "Creating views/main.py..."
cat <<EOF > $PROJECT_NAME/views/main.py
from database import SessionLocal, init_db
from controllers import (
    create_academic_year,
    get_all_academic_years,
    create_semester_name,
    create_semester,
    get_all_semester_names,
    get_all_semesters,
    create_subject,
    get_all_subjects,
    update_subject,
    create_education_data,
    get_all_education_data
)
from models import AcademicYear, SemesterName, Semester, Subject, EducationData
from datetime import datetime
from sqlmodel import select, selectinload

def check_and_create_required_data(session):
    # ตรวจสอบปีการศึกษาปัจจุบัน
    current_year = datetime.now().year + 543  # แปลงเป็นปีพุทธศักราช
    academic_year_name = f"ปีการศึกษา {current_year}"
    academic_year = session.exec(select(AcademicYear).where(AcademicYear.name == academic_year_name)).first()
    if not academic_year:
        academic_year = create_academic_year(session, academic_year_name)
        print(f"สร้าง AcademicYear: {academic_year.name}")
    else:
        print(f"AcademicYear {academic_year.name} มีอยู่แล้ว.")

    # ตรวจสอบชื่อภาคการศึกษา "1", "2", "3"
    semester_names = [f"ภาคการศึกษาที่ {i}" for i in ["1", "2", "3"]]
    for sem_name in semester_names:
        semester_name = session.exec(select(SemesterName).where(SemesterName.name == sem_name)).first()
        if not semester_name:
            semester_name = create_semester_name(session, sem_name)
            print(f"สร้าง SemesterName: {semester_name.name}")
        else:
            print(f"SemesterName {semester_name.name} มีอยู่แล้ว.")

    # ตรวจสอบและสร้างภาคการศึกษา
    for sem_name in semester_names:
        semester_name = session.exec(select(SemesterName).where(SemesterName.name == sem_name)).first()
        semester = session.exec(
            select(Semester)
            .where(Semester.academic_year_id == academic_year.id)
            .where(Semester.semester_name_id == semester_name.id)
        ).first()
        if not semester:
            semester = create_semester(session, academic_year.id, semester_name.id)
            print(f"สร้าง Semester สำหรับ AcademicYear {academic_year.name} และ SemesterName {semester_name.name}")
        else:
            print(f"Semester สำหรับ AcademicYear {academic_year.name} และ SemesterName {semester_name.name} มีอยู่แล้ว.")

    #------------------------------------------------------------

    # ตรวจสอบปีการศึกษาปีที่แล้ว
    previous_year = current_year - 1
    academic_year_prev = session.exec(select(AcademicYear).where(AcademicYear.name == f"ปีการศึกษา {previous_year}")).first()
    if not academic_year_prev:
        academic_year_prev = create_academic_year(session, f"ปีการศึกษา {previous_year}")
        print(f"สร้าง AcademicYear: {academic_year_prev.name}")
    else:
        print(f"AcademicYear {academic_year_prev.name} มีอยู่แล้ว.")

    # ตรวจสอบและสร้างภาคการศึกษาสำหรับปีที่แล้ว
    for sem_name in semester_names:
        semester_name = session.exec(select(SemesterName).where(SemesterName.name == sem_name)).first()
        semester = session.exec(
            select(Semester)
            .where(Semester.academic_year_id == academic_year_prev.id)
            .where(Semester.semester_name_id == semester_name.id)
        ).first()
        if not semester:
            semester = create_semester(session, academic_year_prev.id, semester_name.id)
            print(f"สร้าง Semester สำหรับ AcademicYear {academic_year_prev.name} และ SemesterName {semester_name.name}")
        else:
            print(f"Semester สำหรับ AcademicYear {academic_year_prev.name} และ SemesterName {semester_name.name} มีอยู่แล้ว.")

def get_academic_years_with_relations(session):
    academic_years = session.exec(
        select(AcademicYear).options(
            selectinload(AcademicYear.semesters).selectinload(Semester.semester_name),
            selectinload(AcademicYear.semesters).selectinload(Semester.education_data).selectinload(EducationData.subject)
        )
    ).all()
    return academic_years

def convert_academic_years_to_dict(academic_years):
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

def main():
    # เริ่มต้นฐานข้อมูล
    init_db()

    with SessionLocal() as session:
        # ตรวจสอบและสร้างข้อมูลที่จำเป็น
        check_and_create_required_data(session)

        # ดึงข้อมูล AcademicYear และข้อมูลที่มีความสัมพันธ์ทั้งหมด
        academic_years = get_academic_years_with_relations(session)
        print("ข้อมูลปีการศึกษาและความสัมพันธ์ทั้งหมด:")
        for ay in academic_years:
            print(f"ปีการศึกษา: {ay.name}")
            for sem in ay.semesters:
                print(f"  ภาคการศึกษา: {sem.semester_name.name}")
                for edu_data in sem.education_data:
                    print(f"    วิชา: {edu_data.subject.name}, รายละเอียด: {edu_data.detail}")

        # สร้างวิชาใหม่
        subject = create_subject(session, "คณิตศาสตร์", "ENG 23")
        print(f"สร้างวิชา: {subject.name}")

        # ดึงและแสดงวิชาทั้งหมด
        subjects = get_all_subjects(session)
        print("รายชื่อวิชาทั้งหมด:")
        for subj in subjects:
            print(f"- {subj.name}")

        # อัปเดตชื่อวิชา
        updated_subject = update_subject(session, subject.id, "คณิตศาสตร์ขั้นสูง", "ENG 23")
        if updated_subject:
            print(f"อัปเดตชื่อวิชาเป็น: {updated_subject.name}")
        else:
            print("ไม่พบวิชาที่ต้องการอัปเดต.")

        # สร้าง EducationData ใหม่
        semester = session.exec(select(Semester)).first()  # ดึงภาคการศึกษาแรกที่พบ
        if semester:
            education_data = create_education_data(
                session,
                detail="รายละเอียดของการสอนคณิตศาสตร์ขั้นสูง",
                semester_id=semester.id,
                subject_id=updated_subject.id,
            )
            print(f"สร้างข้อมูลการศึกษาใหม่ ID: {education_data.id}, รายละเอียด: {education_data.detail}")
        else:
            print("ไม่พบภาคการศึกษาในการสร้าง EducationData")

        # ดึงและแสดงข้อมูลการศึกษาทั้งหมด
        education_datas = get_all_education_data(session)
        print("รายการข้อมูลการศึกษาทั้งหมด:")
        for edu_data in education_datas:
            print(f"- ID: {edu_data.id}, รายละเอียด: {edu_data.detail}")

        # ตัวอย่างการลบวิชา (สามารถเปิดคอมเมนต์ได้เมื่อต้องการใช้งาน)
        # delete_success = delete_subject(session, subject.id)
        # if delete_success:
        #     print(f"ลบวิชาที่มี ID {subject.id} สำเร็จ")
        # else:
        #     print(f"ไม่พบวิชาที่มี ID {subject.id} สำหรับลบ")

if __name__ == "__main__":
    main()
EOF

# สร้างไฟล์ requirements.txt
echo "Creating requirements.txt..."
cat <<EOF > $PROJECT_NAME/requirements.txt
sqlmodel
sqlalchemy
EOF

# สร้างไฟล์ README.md
echo "Creating README.md..."
cat <<EOF > $PROJECT_NAME/README.md
# Project

โครงสร้างโปรเจกต์ตามรูปแบบ Model-View-Controller (MVC) ด้วย SQLModel และ SQLAlchemy

## โครงสร้างโฟลเดอร์

\`\`\`plaintext
project/
│
├── models/
│   ├── __init__.py
│   ├── academic_year.py
│   ├── semester_name.py
│   ├── semester.py
│   ├── subject.py
│   └── education_data.py
│
├── controllers/
│   ├── __init__.py
│   ├── academic_year_controller.py
│   ├── semester_name_controller.py
│   ├── semester_controller.py
│   ├── subject_controller.py
│   └── education_data_controller.py
│
├── views/
│   └── main.py
│
├── database.py
├── requirements.txt
└── README.md
\`\`\`

## การติดตั้งและรันโปรเจกต์

1. **สร้าง Virtual Environment**:

    ```bash
    python3 -m venv venv
    source venv/bin/activate  # สำหรับ Unix/Linux
    # หรือ
    venv\Scripts\activate  # สำหรับ Windows
    ```

2. **ติดตั้ง dependencies**:

    ```bash
    pip install -r requirements.txt
    ```

3. **รันโปรแกรม**:

    ```bash
    python views/main.py
    ```

## คำอธิบายเพิ่มเติม

โครงสร้างโฟลเดอร์นี้ช่วยให้โค้ดของคุณมีความเป็นระเบียบและง่ายต่อการดูแลรักษา แต่ละส่วนมีหน้าที่เฉพาะเจาะจง ซึ่งทำให้การพัฒนาและขยายโปรเจกต์ในอนาคตเป็นไปได้อย่างราบรื่น
EOF

# สร้างไฟล์ controllers/education_data_controller.py
echo "Creating controllers/education_data_controller.py..."
cat <<EOF > $PROJECT_NAME/controllers/education_data_controller.py
from typing import List, Optional
from sqlmodel import Session, select
from models.education_data import EducationData

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
    return [i for i in education_data if i.semester_id == semester_id and i.subject_id == subject_id]

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

# # สร้าง Virtual Environment และติดตั้ง dependencies
# echo "Setting up virtual environment..."
# cd $PROJECT_NAME
# python3 -m venv venv

# echo "Activating virtual environment..."
# source venv/bin/activate

# echo "Installing dependencies..."
# pip install --upgrade pip
# pip install -r requirements.txt

# echo "Initializing the database..."
# python -c "from database import init_db; init_db()"

# echo "Setup complete!"
# echo "To activate the virtual environment in the future, run 'source venv/bin/activate' inside the project directory."
