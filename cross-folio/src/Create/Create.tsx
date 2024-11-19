import React, { useEffect, useState } from 'react';
import logo from './logo.svg';
import './Create.css'
import config from '../config';
import Grid from '@mui/material/Grid2';
import Card from '@mui/material/Card';
import Box from '@mui/material/Box';
import TextField from '@mui/material/TextField';
import InputLabel from '@mui/material/InputLabel';
import MenuItem from '@mui/material/MenuItem';
import FormControl from '@mui/material/FormControl';
import Select, { SelectChangeEvent } from '@mui/material/Select';
import Button from '@mui/material/Button';

function Create() {
  const [subject, setSubject] = React.useState<string>('');
  const [url, setUrl] = React.useState<string>('');
  const [semester, setSemester] = React.useState<string>('');
  const [semesterArray, setSemesterArray] = useState<string[]>([]);

  useEffect(() => {
    fetch(config['backend'] + '/semester')
      .then(response => response.json())
      .then(data => {
        const semesters = data.res;
        setSemesterArray(semesters);
        console.log('Fetched semesters:', semesters);  // Logs fetched data correctly
      })
      .catch(error => {
        console.error('Error fetching semester data: ', error);
      });
  }, []); // This effect runs only once on mount

  const handleChangeSubject = (event: React.ChangeEvent<HTMLInputElement>) => {
    setSubject(event.target.value);  // Updates the subject when changed
  };

  const handleChangeUrl = (event: React.ChangeEvent<HTMLInputElement>) => {
    setUrl(event.target.value);  // Updates the URL when changed
  };

  const handleChangeSemester = (event: SelectChangeEvent) => {
    setSemester(event.target.value);  // Updates semester when selected
    console.log('Selected semester:', event.target.value);
  };
  const handleClick = async () => {
    const data = {
      subject,
      url,
      semester,
    };
    try {
      const response = await fetch(config['backend'] +'/add_subject', {
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
        <Grid size={4} />
        <Grid size={4}>
          <Card variant="outlined">
            <FormControl sx={{ m: '2%', minWidth: 80, width: '96%' }}>
              <InputLabel id="semester-select-label">Semester</InputLabel>
              <Select
                labelId="semester-select-label"
                id="semester-select"
                value={semester}
                onChange={handleChangeSemester}
                autoWidth
                label="Semester"
              >
                {semesterArray.map((item, index) => (
                  <MenuItem key={index} value={item}>
                    <em>{item}</em>
                  </MenuItem>
                ))}
              </Select>
            </FormControl>

            <FormControl sx={{ m: '2%', minWidth: 80, width: '96%' }}>
              <TextField
                id="subject-field"
                label="Subject Name"
                variant="outlined"
                value={subject}
                onChange={handleChangeSubject}  // This now updates the subject state
              />
            </FormControl>

            <FormControl sx={{ m: '2%', minWidth: 80, width: '96%' }}>
              <TextField
                id="url-field"
                label="URL"
                variant="outlined"
                value={url}
                onChange={handleChangeUrl}  // This now updates the URL state
              />
            </FormControl>

            <FormControl sx={{ m: '2%', minWidth: 80, width: '96%' }}>
              <Button variant="contained" size="large"
                onClick={handleClick}
              >
                submit
              </Button>
            </FormControl>
          </Card>
        </Grid>
        <Grid size={4} />
      </Grid>
    </div>
  );
}

export default Create;
