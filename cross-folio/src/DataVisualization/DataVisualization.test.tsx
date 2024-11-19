import React from 'react';
import { render, screen } from '@testing-library/react';
import DataVisualization from './DataVisualization';

test('renders learn react link', () => {
  render(<DataVisualization />);
  const linkElement = screen.getByText(/learn react/i);
  expect(linkElement).toBeInTheDocument();
});
