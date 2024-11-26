import * as React from 'react';
import Button from '@mui/material/Button';
import TextField from '@mui/material/TextField';
import Dialog from '@mui/material/Dialog';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';
import DialogContentText from '@mui/material/DialogContentText';
import DialogTitle from '@mui/material/DialogTitle';
import AddCircleIcon from '@mui/icons-material/AddCircle';
import MenuBookIcon from '@mui/icons-material/MenuBook';
import EditCalendarIcon from '@mui/icons-material/EditCalendar';
import config from '../../../config';

export default function ManualAddSemester() {

  const [open, setOpen] = React.useState(false);
  const [year, setYear] = React.useState<string>('');

  const handleClickOpen = () => {
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
  };

  const handleChange = (event: any, setter: Function) => {
    setter(Object(Object(event).target).value);  // Updates the URL when changed
    // console.log('handleChangeInput', event.target.value);
  };

  const submit = async () => {
    const data = {
      year
    };
    console.log(data);

    try {
      const response = await fetch(config['backend'] + '/manual_add_semester', {
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
    <div >
      <div onClick={handleClickOpen}>
        <EditCalendarIcon />

      </div>
      <Dialog
        open={open}
        onClose={handleClose}
        PaperProps={{
          component: 'form',

          onSubmit: async (event: React.FormEvent<HTMLFormElement>) => {
            event.preventDefault();
            await submit();
          }
        }}
      >
        <DialogTitle>Academic Year</DialogTitle>
        <DialogContent>
         
          <TextField
            autoFocus
            required
            margin="dense"
            id="name"
            name="Academic Year"
            label="Academic Year"

            fullWidth
            variant="standard"

            multiline
            value={year}
            onChange={(e) => handleChange(e, setYear)}
          />
         
        </DialogContent>
        <DialogActions>
          <Button onClick={handleClose}>Cancel</Button>

          <Button type="submit" >submit</Button>


        </DialogActions>
      </Dialog>
    </div>
  );
}
