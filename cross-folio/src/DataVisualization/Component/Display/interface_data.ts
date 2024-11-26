export interface interface_subject_init {
    detail: string,
    url: string
}

export interface interface_education_data {
    id: number,
    subject_name: string,
    subject: Array<interface_education_data>
}

export interface interface_semester {
    id: number,
    semester_name: string,
    education_data: Array<interface_education_data>
}
 
export interface interface_year {
    id: number,
    name: string,
    semesters: Array<interface_semester>
}
 