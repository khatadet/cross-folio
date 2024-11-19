export interface interface_subject_init {
    detail: string,
    url: string
}

export interface interface_subject {
    subject_name: string,
    subject: Array<interface_subject_init>
}

export interface interface_semester {
    semester_name: string,
    semester: Array<interface_subject>
}
 