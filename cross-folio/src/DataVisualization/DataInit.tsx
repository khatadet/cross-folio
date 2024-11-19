import * as React from 'react';
import { interface_semester, interface_subject, interface_subject_init } from './interface_data';
import Typography from '@mui/material/Typography';
import Markdown from 'react-markdown'

function DataInit(arg: any) {
    let data = arg.data as any;
    if (!data) {
        return (
            <div >
            </div>
        )
    } else {
        let arr = arg.data.subject as Array <interface_subject_init>;
        return (
            <div >
                <h1>{data.subject_name}</h1>
                {arr.map((item, index) => (
                   <div>
                    <Markdown>{item.detail}</Markdown>
                    <Markdown>{'# Hi, *Pluto*!'}</Markdown>
                    
                   </div>
                        
                    
                ))
                    
                }
            </div>
        );
    }
}

export default DataInit;