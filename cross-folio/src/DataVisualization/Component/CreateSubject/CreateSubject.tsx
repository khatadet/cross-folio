import React, { useEffect, useState } from 'react';
import logo from './logo.svg';
import './CreateSubject.css'
import config from '../../../config';
import Grid from '@mui/material/Grid2';
import Card from '@mui/material/Card';
import Box from '@mui/material/Box';
import TextField from '@mui/material/TextField';
import InputLabel from '@mui/material/InputLabel';
import MenuItem from '@mui/material/MenuItem';
import FormControl from '@mui/material/FormControl';
import Select, { SelectChangeEvent } from '@mui/material/Select';
import Button from '@mui/material/Button';

interface obj {
  name: string,
  id: number
}

function CreateSubject() {

  const [name, setName] = React.useState<string>('');
  const [code, setCode] = React.useState<string>('');




  function getList_Data(path: string, setter: Function) {
    fetch(config['backend'] + path)
      .then(response => response.json())
      .then(data => {
        const res = data.res;
        setter(res);
        console.log('Fetched Data:', res);  // Logs fetched data correctly
      })
      .catch(error => {
        console.error('Error fetching semester year: ', error);
      });
  }

  


  useEffect(() => {
   

  }, []); // This effect runs only once on mount



  const handleChange = (event: any, setter: Function) => {
    setter(Object(Object(event).target).value);  // Updates the URL when changed
    console.log('handleChangeInput', event.target.value);
  };


  const submit = async () => {
    const data = {
      name,
      code
    };
    console.log(data);

    try {
      const response = await fetch(config['backend'] + '/add_subject', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(data),
      });

      // Check if the request was successful
      if (response.ok) {
        const responseData = await response.json();
        alert('Success: ' + responseData.message);
        // window.location.reload();
      } else {
        alert('Error: ' + response.statusText);
      }
    } catch (error) {
      alert('Error: ' + Object(error).message);
    }

  };

  return (
    <div>
      <Grid container spacing={2}>
        {/* <Grid size={4} /> */}
        <Grid size={4}> </Grid>
        <Grid size={4} >
          <Card variant="outlined" className = "Card">
            <FormControl sx={{ m: '2%', minWidth: 80, width: '96%' }}>
              <TextField
                id="url-field"
                label="Subjec Name"
                variant="outlined"
                multiline
                value={name}
                onChange={(e) => handleChange(e, setName)}   // This now updates the URL state
              />
            </FormControl>
            <FormControl sx={{ m: '2%', minWidth: 80, width: '96%' }}>
              <TextField
                id="url-field"
                label="Subjec Code"
                variant="outlined"
                multiline
                value={code}
                onChange={(e) => handleChange(e, setCode)}   // This now updates the URL state
              />
            </FormControl>

            <FormControl sx={{ m: '2%', minWidth: 80, width: '96%' }}>
              <Button variant="contained" size="large"
                onClick={submit}
              >
                submit
              </Button>
            </FormControl>


          </Card>
        </Grid>
        <Grid size={4}> </Grid>
      </Grid>
    </div>
  );
}

export default CreateSubject;
