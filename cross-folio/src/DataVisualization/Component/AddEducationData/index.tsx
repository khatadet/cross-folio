import * as React from 'react';
import Button from '@mui/material/Button';
import TextField from '@mui/material/TextField';
import Dialog from '@mui/material/Dialog';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';
import DialogContentText from '@mui/material/DialogContentText';
import DialogTitle from '@mui/material/DialogTitle';
import AddCircleIcon from '@mui/icons-material/AddCircle';
import PlaylistAddCircleIcon from '@mui/icons-material/PlaylistAddCircle';

import InputLabel from '@mui/material/InputLabel';
import MenuItem from '@mui/material/MenuItem';
import FormControl from '@mui/material/FormControl';
import Select, { SelectChangeEvent } from '@mui/material/Select';
import config from '../../../config';

interface obj {
  name: string,
  id: number
}

export default function AddEducationData(year: any, semester: any, subjects: any) {
  // console.log('year',year)
  // console.log('semester',semester)
  // console.log('subjects',subjects)
  const [open, setOpen] = React.useState(false);
  const [subject, setSubject] = React.useState<obj>();

  const handleChange = (event: any, setter: Function) => {
    setter(Object(Object(event).target).value);  // Updates the URL when changed
    console.log('handleChangeInput', event.target.value);
  };

  function getSelect(value_: any, array: Array<any>, setter: Function, label_: string) {

   
    return (
      <FormControl
      variant="standard"
      fullWidth
      required
      margin="dense"
      autoFocus
    >
        <InputLabel id={label_}>{label_}</InputLabel>
        <Select
          labelId={label_}
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


  const submit = async () => {
    let detail = '';
    let semester_id = semester.id;
    let subject_id = subject;
    const data = {
      detail,
      semester_id,
      subject_id
    };
    try {
      const response = await fetch(config['backend'] + '/add_education_data_v2', {
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

  }

  const handleClickOpen = () => {
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
  };

  return (
    <div>
      <div onClick={handleClickOpen}>
        <PlaylistAddCircleIcon />

      </div>
      <Dialog
        open={open}
        onClose={handleClose}
        PaperProps={{
          component: 'form',
          onSubmit: async (event: React.FormEvent<HTMLFormElement>) => {
            event.preventDefault();
            await submit();
          },
        }}
      >
        <DialogTitle>Add Subjects</DialogTitle>
        <DialogContent sx={{width: '300px'}}>
          <DialogContentText>

            {year}
            <br/>
            {semester.name}
        

          </DialogContentText>
          {getSelect(subject, subjects, setSubject, "Subject")}

          
        </DialogContent>
        <DialogActions>
          <Button onClick={handleClose}>Cancel</Button>
          <Button type="submit" >submit</Button>
        </DialogActions>
      </Dialog>
    </div>
  );
}
