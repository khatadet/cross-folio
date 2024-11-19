import * as React from 'react';
import ListSubheader from '@mui/material/ListSubheader';
import List from '@mui/material/List';
import ListItemButton from '@mui/material/ListItemButton';
import ListItemIcon from '@mui/material/ListItemIcon';
import ListItemText from '@mui/material/ListItemText';
import Collapse from '@mui/material/Collapse';
import InboxIcon from '@mui/icons-material/MoveToInbox';
import DraftsIcon from '@mui/icons-material/Drafts';
import SendIcon from '@mui/icons-material/Send';
import ExpandLess from '@mui/icons-material/ExpandLess';
import ExpandMore from '@mui/icons-material/ExpandMore';
import StarBorder from '@mui/icons-material/StarBorder';
import { interface_semester ,interface_subject,interface_subject_init } from './interface_data';
import Grid from '@mui/material/Grid2';
import Card from '@mui/material/Card';
import DataInit from './DataInit';

function TableData(arg: any) {
  let data = arg.data.res as Array<interface_semester>;
  let open_list = data.map(n => false);
  const [open, setOpen] = React.useState(open_list);

  const handleClickOpen = (index: number) => {
    let o = open
    o[index] = !o[index]
    setOpen([...o]);
  };
  const [subject, setSubject] = React.useState<any>();
  const handleClickPage = (item: any) => {
    setSubject(item)
  };

  return (

    <div >
      <Grid container spacing={2}>
        <Grid  size={4}>
          <Card variant="outlined">


            <List 
              sx={{ width: '100%', maxWidth: 700, bgcolor: 'background.paper' ,maxHeight: '90vh',overflow: 'auto'}}
              component="nav"
              aria-labelledby="nested-list-subheader"
              subheader={
                <ListSubheader component="div" id="nested-list-subheader">
                  TABEE SUT CPE
                </ListSubheader>
              }
            >
              {data.map((item, index) => (
                <div>
                  <ListItemButton onClick={() => handleClickOpen(index)}>
                    <ListItemIcon>
                      <InboxIcon />
                    </ListItemIcon>
                    <ListItemText primary={item.semester_name} />
                    {open[index] ? <ExpandLess /> : <ExpandMore />}
                  </ListItemButton>
                  <Collapse in={open[index]} timeout="auto" unmountOnExit>

                    {Array.from(item.semester).map((item_2, index_2) => (
                      <List component="div" disablePadding >
                        <ListItemButton sx={{ pl: 4 }} onClick={() => handleClickPage(item_2)}>
                          <ListItemIcon>

                            <StarBorder />


                          </ListItemIcon>
                          <ListItemText primary={item_2.subject_name} />
                        </ListItemButton>
                      </List>
                    ))
                    }
                  </Collapse>
                </div>
              ))

              }
            </List>
          </Card>
        </Grid>
        
        <Grid size={8}>
          <Card variant="outlined" sx={{maxHeight: '90vh',overflow: 'auto'}}>
            <DataInit data = {subject}></DataInit>
          </Card>
        </Grid>
      </Grid>


    </div>


  );
}

export default TableData;