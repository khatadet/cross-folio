import React, { useEffect, useState } from 'react';
import Card from '@mui/material/Card';
import Box from '@mui/material/Box';
import config from '../config';
import './DataVisualization.css';
import TableData from './TableData';
import { interface_semester } from './interface_data';


const DataVisualization: React.FC = () => {
  const [data, setData] = useState<Array<interface_semester>>();

  useEffect(() => {
    fetch(config['backend'] + '/'
      // ,{ mode: 'no-cors' }
    )

      .then(response => {
        console.log(response);
        return response.json();

      })
      .then(data => {
        console.log("โหลดข้อมูล");
        console.log(data);
        setData(data);
      })
      .catch(error => {
        console.error('เกิดข้อผิดพลาดในการดึงข้อมูล:', error);
      });
  },
    []);

  return (
    <Card variant="outlined" >
      <Box sx={{ p: 2 }}>

<br/>
        <div>
          {data ? (
            <div>


              <TableData data={data} />


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
