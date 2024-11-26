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

import DateRangeIcon from '@mui/icons-material/DateRange';
import EventNoteIcon from '@mui/icons-material/EventNote';
import MenuBookIcon from '@mui/icons-material/MenuBook';
import ExpandLess from '@mui/icons-material/ExpandLess';
import ExpandMore from '@mui/icons-material/ExpandMore';
import StarBorder from '@mui/icons-material/StarBorder';
import { MenuBook, Edit } from '@mui/icons-material';
// import { interface_year} from './interface_data';
import Grid from '@mui/material/Grid2';
import Card from '@mui/material/Card';
import { FormControl, Box } from '@mui/material';
import PlaylistAddCircleIcon from '@mui/icons-material/PlaylistAddCircle';
import DataDisplay from './Display/DataDisplay';
import DataEdit from './Edit/DataEdit';
import AddEducationData from './AddEducationData';
import AddSubject from './AddSubject';
import ManualAddSemester from './ManualAddSemester';

function TableData(arg: any) {


  let data = arg.data as Array<any>;
  let subjects = arg.subject as any;
  // let subjects = arg as any;


  // console.log("arg = ",data);
  // console.log("year_name = ",data[0].name);

  let open_list = data.map(n => [false, ...Array.from(n.semesters).map((i) => false)]);

  const [open, setOpen] = React.useState(open_list);
  const [edit, setEdit] = React.useState(false);
  const [display, setDisplay] = React.useState<any>((
    <div >
    </div>
  ));

  const handleClickOpen = (index1: number, index2: number) => {
    let o = open
    o[index1][index2] = !o[index1][index2]
    setOpen([...o]);
    console.log(index1, index2)
    console.log(o)
  };
  const [subject, setSubject] = React.useState<any>();
  const handleClickPage = (item: any) => {
    console.log(item);
    setSubject(item)

  };


  return (

    <div >
      <Grid container spacing={2}>
        <Grid sx={{ width: '400px' }}>
          <Card variant="outlined">


            <List
              sx={{ width: '100%', maxWidth: 700, bgcolor: 'background.paper', maxHeight: '90vh', overflow: 'auto' }}
              component="nav"
              aria-labelledby="nested-list-subheader"
              subheader={
                <div>
                  <FormControl sx={{ minWidth: 80, width: '70%', textAlign: 'left' }}>
                    <ListSubheader component="div" id="nested-list-subheader">
                      TABEE SUT CPE

                    </ListSubheader>
                  </FormControl>
                  <FormControl sx={{ minWidth: 80, width: '30%', textAlign: 'right' }}>
                    
                    <Box sx={{ m: '10px', display: 'flex', justifyContent: 'flex-end', alignItems: 'center',  width: 'calc(100% - 25px)', }}                    >
                      <ManualAddSemester />
                      &nbsp;&nbsp;
                      <AddSubject  />
                    </Box>
                  </FormControl>
                </div>


              }
            >
              {
                data.map((item, index) => (
                  <div>
                    <ListItemButton >
                      <ListItemIcon>
                        <DateRangeIcon />
                      </ListItemIcon>
                      <ListItemText primary={item.name} />

                      {open[index][0] ?
                        <ExpandLess onClick={() => handleClickOpen(index, 0)} /> :
                        <ExpandMore onClick={() => handleClickOpen(index, 0)} />}
                    </ListItemButton>
                    <Collapse in={open[index][0]} timeout="auto" unmountOnExit>

                      {
                        Array.from(item.semesters).map((item_2, index_2) => (
                          <List component="div" disablePadding >
                            {/* <ListItemButton sx={{ pl: 4 }} onClick={() => handleClickPage(item_2)}> */}
                            <ListItemButton sx={{ pl: 4 }} >
                              <ListItemIcon>
                                <EventNoteIcon />
                              </ListItemIcon>
                              <ListItemText primary={Object(item_2).name} />
                              {/* <ListItemText primary={JSON.stringify(item_2)} /> */}

                              {AddEducationData(item.name, item_2, subjects)}
                              {open[index][index_2 + 1] ?
                                <ExpandLess onClick={() => handleClickOpen(index, index_2 + 1)} /> :
                                <ExpandMore onClick={() => handleClickOpen(index, index_2 + 1)} />}
                            </ListItemButton>
                            <Collapse in={open[index][index_2 + 1]} timeout="auto" unmountOnExit>
                              {
                                Array.from(Object(item_2).education_data).map((item_3, index_3) => (
                                  <ListItemButton sx={{ pl: 8 }} onClick={() => handleClickPage(item_3)}>
                                    <ListItemIcon>
                                      <MenuBookIcon />
                                    </ListItemIcon>
                                    <ListItemText primary={Object(Object(item_3).subject).name} />
                                    {/* <ListItemText primary={JSON.stringify(item_3)} /> */}


                                  </ListItemButton>

                                ))
                              }
                            </Collapse>
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

        <Grid sx={{ width: 'calc(100% - 420px)' }}>
          {subject ?
            <Card variant="outlined" sx={{ maxHeight: '90vh', overflow: 'auto' }}>
              {/* <DataDisplay data={subject}></DataDisplay> */}


              <FormControl sx={{ minWidth: 80, width: '100%', textAlign: 'right' }}>
                <Box
                  sx={{
                    m: '3%',
                    display: 'flex',
                    justifyContent: 'flex-end',
                    alignItems: 'center',
                    minWidth: 80,
                    width: '94%',
                  }}
                >
                  {!edit ?
                    <MenuBook onClick={() => setEdit(!edit)} /> :
                    <Edit onClick={() => setEdit(!edit)} />}
                </Box>
              </FormControl>
              {edit ?
                <DataEdit data={subject}></DataEdit> :
                <DataDisplay data={subject}></DataDisplay>}

            </Card>
            : <div></div>}
        </Grid>
      </Grid>


    </div>


  );

}

export default TableData;