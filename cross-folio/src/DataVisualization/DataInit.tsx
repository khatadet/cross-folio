import * as React from 'react';
import { interface_semester, interface_subject, interface_subject_init } from './interface_data';
import Typography from '@mui/material/Typography';

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
                    <Typography>{item.detail}</Typography>
                    <Typography>{item.url}</Typography>
                    
                   </div>
                        
                    
                ))
                    
                }
            </div>
        );
    }
}

export default DataInit;