import React, { useEffect, useState } from 'react';
import logo from './logo.svg';
import './style.css'
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

function Create() {

  const [detail, setDetail] = React.useState<string>('');

  const [year, setYear] = React.useState<obj>();
  const [semester, setSemester] = React.useState<obj>();
  const [subject, setSubject] = React.useState<obj>();

  const [yearArray, setYearArray] = useState<obj[]>([]);
  const [semesterArray, setSemesterArray] = useState<obj[]>([]);
  const [subjectArray, setSubjectArray] = useState<obj[]>([]);


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

  function getSelect(value_: any, array: Array<any>, setter: Function, label_: string) {
    return (
      <FormControl sx={{ m: '2%', minWidth: 80, width: '96%' }}>
        <InputLabel id="semester-select-label">{label_}</InputLabel>
        <Select
          labelId="semester-select-label"
          id="semester-select"
          value={value_}
          onChange={(e) => handleChange(e, setter)}
          autoWidth
          label={label_}
        >
          {array.map((item, index) => (
            <MenuItem key={index} value={item.id}>
              <em>{Object(item).name}</em>
            </MenuItem>
          ))}
        </Select>
      </FormControl>
    );
  }


  useEffect(() => {
    getList_Data('/getList_year', setYearArray);
    getList_Data('/getList_semester_names', setSemesterArray);
    getList_Data('/getList_subject', setSubjectArray);

  }, []); // This effect runs only once on mount



  const handleChange = (event: any, setter: Function) => {
    setter(Object(Object(event).target).value);  // Updates the URL when changed
    console.log('handleChangeInput', event.target.value);
  };


  const submit = async () => {
    const data = {
      year,
      subject,
      semester,
      detail, 
    };

    try {
      const response = await fetch(config['backend'] + '/add_education_data', {
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
        window.location.reload();
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
        <Grid size={4}>
          <Card variant="outlined" className = "Card">


            {getSelect(year, yearArray, setYear, "Year")}
            {getSelect(semester, semesterArray, setSemester, "Semester")}
            {getSelect(subject, subjectArray, setSubject, "Subject")}





            <FormControl sx={{ m: '2%', minWidth: 80, width: '96%' }}>
              <Button variant="contained" size="large"
                onClick={submit}
              >
                submit
              </Button>
            </FormControl>
          </Card>

        </Grid>
        <Grid size={8} >
          <Card variant="outlined" className = "Card">
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
          </Card>
        </Grid>
      </Grid>
    </div>
  );
}

export default Create;
