import React from 'react';
import ReactDOM from 'react-dom/client';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import './index.css';
import DrawerAppBar from './DrawerAppBar';
import App from './Home/App';
import Test from './Test/Test';
import Create from './Create/Create';
import DataVisualization from './DataVisualization/DataVisualization';
import reportWebVitals from './reportWebVitals';

const root = ReactDOM.createRoot(
  document.getElementById('root') as HTMLElement
);
root.render(
  <React.StrictMode>
    <DrawerAppBar></DrawerAppBar>
     <BrowserRouter>
      <Routes>
        <Route path="/Home" element={<App />} />
          {/* เพิ่มเส้นทางอื่น ๆ ที่นี่ */}
       
        <Route path="/DataVisualization" element={<DataVisualization />}/>
        <Route path="/Test" element={<Test />}/>
        <Route path="/Create" element={<Create />}/>
        
      </Routes>
    </BrowserRouter>
  </React.StrictMode>
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
