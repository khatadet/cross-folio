from typing import List, Optional
from datetime import datetime

# นำเข้าไลบรารีที่จำเป็น
from sqlmodel import SQLModel, Field, Relationship, Session, create_engine, select
from sqlalchemy.orm import selectinload  # สำหรับการโหลดความสัมพันธ์

# กำหนดชื่อไฟล์ฐานข้อมูล SQLite และสร้าง engine
sqlite_file_name = "database.db"
sqlite_url = f"sqlite:///{sqlite_file_name}"
engine = create_engine(sqlite_url)

# กำหนดโมเดลของตารางต่าง ๆ

class AcademicYear(SQLModel, table=True):
    __tablename__ = "academicyear"  # ชื่อตาราง ปีการศึกษา
    id: Optional[int] = Field(default=None, primary_key=True)  # รหัส ID ที่เพิ่มเองอัตโนมัติ
    name: str = Field(unique=True)  # ชื่อปีการศึกษา ที่ไม่ซ้ำกัน (unique)
    semesters: List["Semester"] = Relationship(back_populates="academic_year")  # ความสัมพันธ์กับตาราง Semester (ภาคการศึกษา)

class SemesterName(SQLModel, table=True):
    __tablename__ = "semestername"  # ชื่อตาราง ชื่อภาคการศึกษา
    id: Optional[int] = Field(default=None, primary_key=True)  # รหัส ID ที่เพิ่มเองอัตโนมัติ
    name: str = Field(unique=True)  # ชื่อภาคการศึกษา ที่ไม่ซ้ำกัน (unique)
    semesters: List["Semester"] = Relationship(back_populates="semester_name")  # ความสัมพันธ์กับตาราง Semester

class Semester(SQLModel, table=True):
    __tablename__ = "semester"  # ชื่อตาราง ภาคการศึกษา
    id: Optional[int] = Field(default=None, primary_key=True)  # รหัส ID ที่เพิ่มเองอัตโนมัติ
    academic_year_id: int = Field(foreign_key="academicyear.id")  # Foreign Key เชื่อมกับ AcademicYear
    semester_name_id: int = Field(foreign_key="semestername.id")  # Foreign Key เชื่อมกับ SemesterName

    academic_year: "AcademicYear" = Relationship(back_populates="semesters")  # ความสัมพันธ์กับ AcademicYear
    semester_name: "SemesterName" = Relationship(back_populates="semesters")  # ความสัมพันธ์กับ SemesterName
    education_data: List["EducationData"] = Relationship(back_populates="semester")  # ความสัมพันธ์กับ EducationData

class Subject(SQLModel, table=True):
    __tablename__ = "subject"  # ชื่อตาราง วิชาที่สอน
    id: Optional[int] = Field(default=None, primary_key=True)  # รหัส ID ที่เพิ่มเองอัตโนมัติ
    name: str = Field(unique=True)  # ชื่อวิชา ที่ไม่ซ้ำกัน (unique)
    education_data: List["EducationData"] = Relationship(back_populates="subject")  # ความสัมพันธ์กับ EducationData

class EducationData(SQLModel, table=True):
    __tablename__ = "educationdata"  # ชื่อตาราง ตารางข้อมูลการศึกษา
    id: Optional[int] = Field(default=None, primary_key=True)  # รหัส ID ที่เพิ่มเองอัตโนมัติ
    detail: str  # รายละเอียดของข้อมูลการศึกษา

    semester_id: int = Field(foreign_key="semester.id")  # Foreign Key เชื่อมกับ Semester
    subject_id: int = Field(foreign_key="subject.id")  # Foreign Key เชื่อมกับ Subject

    semester: "Semester" = Relationship(back_populates="education_data")  # ความสัมพันธ์กับ Semester
    subject: "Subject" = Relationship(back_populates="education_data")  # ความสัมพันธ์กับ Subject

# สร้างตารางในฐานข้อมูล
SQLModel.metadata.create_all(engine)

# ฟังก์ชัน CRUD (Create, Read, Update, Delete) สำหรับแต่ละตาราง

# ฟังก์ชันสำหรับตาราง AcademicYear (ปีการศึกษา)

def create_academic_year(session: Session, name: str):
    academic_year = AcademicYear(name=name)
    session.add(academic_year)
    session.commit()
    session.refresh(academic_year)
    return academic_year

def get_academic_year(session: Session, academic_year_id: int):
    return session.get(AcademicYear, academic_year_id)

def get_all_academic_years(session: Session):
    return session.exec(select(AcademicYear)).all()

def update_academic_year(session: Session, academic_year_id: int, name: str):
    academic_year = session.get(AcademicYear, academic_year_id)
    if academic_year:
        academic_year.name = name
        session.add(academic_year)
        session.commit()
        session.refresh(academic_year)
        return academic_year
    else:
        return None

def delete_academic_year(session: Session, academic_year_id: int):
    academic_year = session.get(AcademicYear, academic_year_id)
    if academic_year:
        session.delete(academic_year)
        session.commit()
        return True
    else:
        return False

# ฟังก์ชันสำหรับดึงข้อมูล AcademicYear และข้อมูลที่มีความสัมพันธ์ทั้งหมด

def get_academic_years_with_relations(session: Session):
    academic_years = session.exec(
        select(AcademicYear).options(
            selectinload(AcademicYear.semesters).options(
                selectinload(Semester.semester_name),
                selectinload(Semester.education_data).options(
                    selectinload(EducationData.subject)
                )
            )
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
                "semester_name": sem.semester_name.name,
                "education_data": []
            }
            for edu_data in sem.education_data:
                edu_dict = {
                    "id": edu_data.id,
                    "detail": edu_data.detail,
                    "subject": {
                        "id": edu_data.subject.id,
                        "name": edu_data.subject.name
                    }
                }
                sem_dict["education_data"].append(edu_dict)
            ay_dict["semesters"].append(sem_dict)
        result.append(ay_dict)
    return result

# ฟังก์ชันสำหรับตาราง SemesterName (ชื่อภาคการศึกษา)

def create_semester_name(session: Session, name: str):
    semester_name = SemesterName(name=name)
    session.add(semester_name)
    session.commit()
    session.refresh(semester_name)
    return semester_name

def get_semester_name(session: Session, semester_name_id: int):
    return session.get(SemesterName, semester_name_id)

def get_all_semester_names(session: Session):
    return session.exec(select(SemesterName)).all()

def update_semester_name(session: Session, semester_name_id: int, name: str):
    semester_name = session.get(SemesterName, semester_name_id)
    if semester_name:
        semester_name.name = name
        session.add(semester_name)
        session.commit()
        session.refresh(semester_name)
        return semester_name
    else:
        return None

def delete_semester_name(session: Session, semester_name_id: int):
    semester_name = session.get(SemesterName, semester_name_id)
    if semester_name:
        session.delete(semester_name)
        session.commit()
        return True
    else:
        return False

# ฟังก์ชันสำหรับตาราง Semester (ภาคการศึกษา)

def create_semester(session: Session, academic_year_id: int, semester_name_id: int):
    semester = Semester(academic_year_id=academic_year_id, semester_name_id=semester_name_id)
    session.add(semester)
    session.commit()
    session.refresh(semester)
    return semester

def get_semester(session: Session, semester_id: int):
    return session.get(Semester, semester_id)

def get_all_semesters(session: Session):
    return session.exec(select(Semester)).all()

def update_semester(session: Session, semester_id: int, academic_year_id: int, semester_name_id: int):
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

def delete_semester(session: Session, semester_id: int):
    semester = session.get(Semester, semester_id)
    if semester:
        session.delete(semester)
        session.commit()
        return True
    else:
        return False

# ฟังก์ชันสำหรับตาราง Subject (วิชาที่สอน)

def create_subject(session: Session, name: str):
    subject = Subject(name=name)
    session.add(subject)
    session.commit()
    session.refresh(subject)
    return subject

def get_subject(session: Session, subject_id: int):
    return session.get(Subject, subject_id)

def get_all_subjects(session: Session):
    return session.exec(select(Subject)).all()

def update_subject(session: Session, subject_id: int, name: str):
    subject = session.get(Subject, subject_id)
    if subject:
        subject.name = name
        session.add(subject)
        session.commit()
        session.refresh(subject)
        return subject
    else:
        return None

def delete_subject(session: Session, subject_id: int):
    subject = session.get(Subject, subject_id)
    if subject:
        session.delete(subject)
        session.commit()
        return True
    else:
        return False

# ฟังก์ชันสำหรับตาราง EducationData (ตารางข้อมูลการศึกษา)

def create_education_data(session: Session, detail: str, semester_id: int, subject_id: int):
    education_data = EducationData(detail=detail, semester_id=semester_id, subject_id=subject_id)
    session.add(education_data)
    session.commit()
    session.refresh(education_data)
    return education_data

def get_education_data(session: Session, education_data_id: int):
    return session.get(EducationData, education_data_id)

def get_all_education_data(session: Session):
    return session.exec(select(EducationData)).all()

def update_education_data(session: Session, education_data_id: int, detail: str, semester_id: int, subject_id: int):
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

def delete_education_data(session: Session, education_data_id: int):
    education_data = session.get(EducationData, education_data_id)
    if education_data:
        session.delete(education_data)
        session.commit()
        return True
    else:
        return False

# ฟังก์ชันสำหรับตรวจสอบและสร้างข้อมูลที่จำเป็น

def check_and_create_required_data(session: Session):
    # ตรวจสอบปีการศึกษาปัจจุบัน
    current_year = datetime.now().year + 543  # แปลงเป็นปีพุทธศักราช
    academic_year_name = "ปีการศึกษา "+str(current_year)
    academic_year = session.exec(select(AcademicYear).where(AcademicYear.name == academic_year_name)).first()
    if not academic_year:
        academic_year = create_academic_year(session, academic_year_name)
        print(f"Created AcademicYear: {academic_year.name}")
    else:
        print(f"AcademicYear {academic_year.name} already exists.")

    # ตรวจสอบปีการศึกษาปัจจุบัน
    current_year = datetime.now().year + 543 - 1 # แปลงเป็นปีพุทธศักราช
    academic_year_name = "ปีการศึกษา "+str(current_year)
    academic_year = session.exec(select(AcademicYear).where(AcademicYear.name == academic_year_name)).first()
    if not academic_year:
        academic_year = create_academic_year(session, academic_year_name)
        print(f"Created AcademicYear: {academic_year.name}")
    else:
        print(f"AcademicYear {academic_year.name} already exists.")

    # ตรวจสอบชื่อภาคการศึกษา "1", "2", "3"
    semester_names =  [ "ภาคการศึกษาที่ " + i for i in ["1", "2", "3"] ]
    for sem_name in semester_names:
        semester_name = session.exec(select(SemesterName).where(SemesterName.name == sem_name)).first()
        if not semester_name:
            semester_name = create_semester_name(session, sem_name)
            print(f"Created SemesterName: {semester_name.name}")
        else:
            print(f"SemesterName {semester_name.name} already exists.")

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
            print(f"Created Semester for AcademicYear {academic_year.name} and SemesterName {semester_name.name}")
        else:
            print(f"Semester for AcademicYear {academic_year.name} and SemesterName {semester_name.name} already exists.")



      
        

        


# ตัวอย่างการใช้งาน
if __name__ == "__main__":
    with Session(engine) as session:
        # ตรวจสอบและสร้างข้อมูลที่จำเป็น
        check_and_create_required_data(session)

        # ดึงข้อมูล AcademicYear และข้อมูลที่มีความสัมพันธ์ทั้งหมด
        academic_years = get_academic_years_with_relations(session)
        print("ข้อมูลปีการศึกษาและความสัมพันธ์ทั้งหมด:")
        print(academic_years)
        for ay in academic_years:
            print(f"ปีการศึกษา: {ay.name}")
            for sem in ay.semesters:
                print(f"  ภาคการศึกษา: {sem.semester_name.name}")
                for edu_data in sem.education_data:
                    print(f"    วิชา: {edu_data.subject.name}, รายละเอียด: {edu_data.detail}")


        exit()
        # สร้างวิชาใหม่
        subject = create_subject(session, "คณิตศาสตร์")
        print(f"สร้างวิชา: {subject.name}")

        # ดึงและแสดงวิชาทั้งหมด
        subjects = get_all_subjects(session)
        print("รายชื่อวิชาทั้งหมด:")
        for subj in subjects:
            print(f"- {subj.name}")

        # อัปเดตชื่อวิชา
        updated_subject = update_subject(session, subject.id, "คณิตศาสตร์ขั้นสูง")
        print(f"อัปเดตชื่อวิชาเป็น: {updated_subject.name}")

        # สร้าง EducationData ใหม่
        # ดึงข้อมูลภาคการศึกษาและวิชาที่ต้องการใช้
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

        # ลบวิชา
        delete_subject(session, subject.id)
        print(f"ลบวิชาที่มี ID {subject.id}")