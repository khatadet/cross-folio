import React, { useEffect, useState } from 'react';
import Card from '@mui/material/Card';
import Box from '@mui/material/Box';
import config from '../config';
import './DataVisualization.css';
import TableData from './Component/TableData';
// import { interface_year } from './interface_data';


const DataVisualization: React.FC = () => {
  // const [data, setData] = useState<Array<interface_year>>();
  const [data, setData] = useState<any>();
  const [subject, setSubject] = useState<any>();

  function getList_Data(path: string, setter: Function) {
    fetch(config['backend'] + path)
      .then(response => response.json())
      .then(data => {
        const res = data.res;
        setter(res);
        console.log('Fetched Data:',path, res);  // Logs fetched data correctly
      })
      .catch(error => {
        console.error('Error fetching semester year: ', error);
      });
  }

  useEffect(() => {
    getList_Data('/getList_subject', setSubject);
    
    getList_Data('/', setData);
    
    
    
  },
    []);

  
  return (
    <Card variant="outlined" >
      <Box sx={{ p: 2 }}>

<br/>
        <div>
          { data  && subject ? (
            <div>


              <TableData data={data} subject={subject} />
{/* {JSON.stringify(data)} */}


            </div>
          ) : (
            <p>กำลังโหลดข้อมูล...</p>
          )}
        </div>
      </Box>
    </Card>
  );
};

export default DataVisualization;
