import React, { useEffect, useState } from 'react';

import './style.css'
import Typography from '@mui/material/Typography';
import Markdown from 'react-markdown'
import Card from '@mui/material/Card';
import FormControl from '@mui/material/FormControl';
import TextField from '@mui/material/TextField';
import config from '../../../config';
import Button from '@mui/material/Button';
import Grid from '@mui/material/Grid2';


function DataEdit(arg: any) {
    let data = arg.data as any;

   
    
    const handleChange = (event: any, setter: Function) => {
        setter(Object(Object(event).target).value);  // Updates the URL when changed
        console.log('handleChangeInput', event.target.value);
    };
    const submit = async () => {
        const data = {
            id,
            detail,
        };

        try {
            const response = await fetch(config['backend'] + '/update_education_data', {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(data),
            });

            // Check if the request was successful
            if (response.ok) {
                const responseData = await response.json();
                alert('Success: ' + responseData.message);
               
            } else {
                alert('Error: ' + response.statusText);
            }
        } catch (error) {
            alert('Error: ' + Object(error).message);
        }

    };


    const [name, setName] = React.useState<string>('');
    const [id, setId] = React.useState<number>(0);
    const [detail, setDetail] = React.useState<string>('');

    console.log('con', [data && id !== Object(Object(data).subject).id as Number]);
    console.log('data', data);

    useEffect(() => {
        console.log("data= ", data)
        if (data) {
            let name_ = Object(Object(data).subject).name as String;
            setName(name_ as string);
            let id_ = data.id as Number;
            setId(id_ as number);
            let detail_ = data.detail as String;
            setDetail(detail_ as string);

        }

    }, [data && id !== data.id as Number]);


    if (!data) {
        return (
            <div >
            </div>
        )
    }


   



        return (
            <div >
                <FormControl sx={{ m: '2%', minWidth: 80, width: '96%', textAlign: 'center' }}>
                    <h1 >{name}</h1>
                </FormControl>

                <Card variant="outlined" className="Card">
                    <div className="Card">
                        <FormControl sx={{ m: '2%', minWidth: 80, width: '96%' }}>
                            <TextField
                                id="url-field"
                                label="detail"
                                variant="outlined"
                                multiline
                                value={detail}
                                onChange={(e) => handleChange(e, setDetail)}   // This now updates the URL state
                            />
                        </FormControl>

                    </div>
                    <div className="Card">
                    
                        <Grid container spacing={2} sx={{ m: '2%', minWidth: 80, width: '96%'}}>
                            <Grid size={8} />
                            <Grid size={4}>
                                <FormControl sx={{  minWidth: 80, width: '100%', textAlign: 'left' }}>
                                    <Button variant="contained" size="large"
                                        onClick={submit}
                                    >
                                        Edit
                                    </Button>
                                </FormControl>
                            </Grid>
                        </Grid>
                        

                    </div>
                </Card>
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

export default DataEdit;