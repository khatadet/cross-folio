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
import config from '../../../config';

export default function AddSubject() {

  const [open, setOpen] = React.useState(false);
  const [name, setName] = React.useState<string>('');
  const [code, setCode] = React.useState<string>('');
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
        <AddCircleIcon />

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
        <DialogTitle>Add Subject</DialogTitle>
        <DialogContent>
          {/* <DialogContentText>
           
          </DialogContentText> */}
          <TextField
            autoFocus
            required
            margin="dense"
            id="name"
            name="Subject name"
            label="Subject name"

            fullWidth
            variant="standard"

            multiline
            value={name}
            onChange={(e) => handleChange(e, setName)}
          />
          <TextField
            autoFocus
            required
            margin="dense"
            id="name"
            name="Subject code"
            label="Subject code"

            fullWidth
            variant="standard"

            multiline
            value={code}
            onChange={(e) => handleChange(e, setCode)}
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
