import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import { turboBrand } from './brand/brand';
import { applyTheme } from './theme/theme';
import './theme/base.css';
import { App } from './app/App';

applyTheme(turboBrand);
document.title = turboBrand.appName;

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <App />
  </StrictMode>,
);
