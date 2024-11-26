import * as React from 'react';

import './style.css'
import Typography from '@mui/material/Typography';
import Markdown from 'react-markdown'
import Card from '@mui/material/Card';
import FormControl from '@mui/material/FormControl';

function DataDisplay(arg: any) {
    let data = arg.data as any;
    if (!data) {
        return (
            <div >
            </div>
        )
    } else {
        let name = Object(Object(data).subject).name as String;
        let detail = data.detail as String;

        return (
            <div >
                <FormControl sx={{ m: '2%', minWidth: 80, width: '96%', textAlign: 'center' }}>
                    <h1 >{name}</h1>
                </FormControl>

                <Card variant="outlined" className="Card">
                    <div className="Card">
                    <FormControl sx={{ m: '2%', minWidth: 80, width: '96%' }}>
                    <Markdown>{detail as string}</Markdown>

                        </FormControl>
                       

                    </div>
                </Card>

            </div>
        );
    }
}

export default DataDisplay;